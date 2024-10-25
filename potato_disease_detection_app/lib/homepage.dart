import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_disease_detection_app/auth_service.dart';
import 'package:potato_disease_detection_app/login.dart';
import 'package:potato_disease_detection_app/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  MyUser currentUser;
  HomePage({super.key, required this.currentUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _prediction = 'abc';
  final double _accuracy = 123;
  File? _image;
  File? _profileImage;
  String? imageUrl;
  final firebaseAuth = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    fetchUser();
    loadModel();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(model: 'assets/potato_disease_model.tflite');
  }

  Future<void> predictDisease(File image) async {
    var imageBytes = await image.readAsBytes();
    img.Image? imageInput = img.decodeImage(imageBytes);
  }

  Future uploadAndUpdateImage() async {
    // uploading image
    final userId = firebaseAuth?.uid;
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    try {
      await storageRef.putFile(_profileImage!);
      imageUrl = await storageRef.getDownloadURL();
      var querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('data')
          .where('email', isEqualTo: widget.currentUser.email)
          .get();
      var documentId = querySnapshot.docs.first.id;

      // updating image in firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('data')
          .doc(documentId)
          .update({'image': imageUrl});

      // also assigning same Image URL to the imageUrl variable of user model so that it can be shown on profile
      setState(() {
        widget.currentUser.imageUrl = imageUrl;
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> fetchUser() async {
    final userId = firebaseAuth?.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('data')
        .get();
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = snapshot.docs.first;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      MyUser user = MyUser(
          name: data['name'],
          email: data['email'],
          phone: data['phone'],
          password: data['password'],
          imageUrl: data['image']);

      setState(() {
        widget.currentUser = user;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User not found!"),
        duration: Duration(milliseconds: 3000),
      ));
    }
  }

  Future<File> compressImage(XFile image) async {
    File originalImage = File(image.path);
    int imageSize = await originalImage.length();
    double imageSizeInMB = imageSize / (1024 * 1024); //converted into MB
    XFile? compressedXImage;
    if (imageSizeInMB > 1) {
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          p.join(tempDir.path, "compressed_${p.basename(originalImage.path)}");
      compressedXImage = await FlutterImageCompress.compressAndGetFile(
          originalImage.absolute.path, targetPath,
          quality: 70);
      return File(compressedXImage!.path); //return compressed image
    }
    return File(image.path); //else return same image
  }

  // Function to pick image from gallery or capturing through camera
  Future<void> _pickImage(ImageSource source, String location) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    final File compressedImage;
    if (image != null) {
      compressedImage = await compressImage(image);
      if (location == 'profile') {
        setState(() {
          _profileImage = compressedImage;
        });
      } else if (location == 'screen') {
        setState(() {
          _image = compressedImage;
        });
      }
    }
  }

  // when user clicks on profile image
  void _showImagePreviewAndOptions(String location) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundImage: widget.currentUser.imageUrl != null
                    ? NetworkImage(widget.currentUser.imageUrl!)
                    : null,
                radius: 80,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Change Profile Image'),
              onTap: () {
                Navigator.pop(context);
                _showImageSourceDialog(location);
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

  // Function to show source of selecting image i.e. Camera and Gallery
  void _showImageSourceDialog(String location) {
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
                  await _pickImage(ImageSource.gallery, location);
                  if (location == 'profile') {
                    await uploadAndUpdateImage();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera, location);
                  if (location == 'profile') {
                    await uploadAndUpdateImage();
                  }
                },
              )
            ],
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[400],
        leading: GestureDetector(
          onTap: () {
            _showImagePreviewAndOptions('profile');
          },
          child: CircleAvatar(
            backgroundImage: widget.currentUser.imageUrl != null
                ? NetworkImage(widget.currentUser.imageUrl!)
                : null,
            radius: 50,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${widget.currentUser.name.toString()}',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    _authService.signOut();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LogIn()));
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  )),
            ],
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: 120,
              height: 110,
              child: IconButton(
                  onPressed: () {
                    _showImageSourceDialog('screen');
                  },
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    size: 100,
                  )),
            ),
            const SizedBox(height: 30),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/images/image.JPG'),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 10.0,
              children: <Widget>[
                const Text(
                  "Type of Disease: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(_prediction,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            Wrap(
              spacing: 10.0,
              children: <Widget>[
                const Text(
                  "Accuracy: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(_accuracy.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
