import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageWorks {
  Future<File> compressImage(XFile image) async {
    File originalImage = File(image.path);
    int imageSize = await originalImage.length();
    double imageSizeInMB = imageSize / (1024 * 1024); //converted into MB
    if (imageSizeInMB > 1) {
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          p.join(tempDir.path, "compressed_${p.basename(originalImage.path)}");
      XFile? compressedXImage = await FlutterImageCompress.compressAndGetFile(
          originalImage.absolute.path, targetPath,
          quality: 70);
      return File(compressedXImage!.path);
    }
    return originalImage; // return same image if size <= 1MB
  }

  Future<void> uploadAndUpdateImage(
      File profileImage, String userId, String email, String? imageUrl) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    await storageRef.putFile(profileImage);
    imageUrl = await storageRef.getDownloadURL();
    var querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('data')
        .where('email', isEqualTo: email)
        .get();
    var documentId = querySnapshot.docs.first.id;

    await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('data')
        .doc(documentId)
        .update({'image': imageUrl});
  }

  Future<void> _pickImage(
      ImageSource source, String location, Function(File) onImagePicked) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      File compressedImage = await compressImage(image);
      onImagePicked(compressedImage);
    }
  }

  void showImageSourceDialog(
      BuildContext context, String location, Function(File) onImagePicked) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(
                      ImageSource.gallery, location, onImagePicked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera, location, onImagePicked);
                },
              ),
            ],
          ));
        });
  }

  void showImagePreviewAndOptions(BuildContext context, String imageUrl,
      String location, Function() onImageChange) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundImage:
                    imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                radius: 80,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Change Profile Image'),
              onTap: () {
                Navigator.pop(context);
                onImageChange();
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Close'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
