import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_disease_detection_app/user_model.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _prediction = 'abc';
  final double _accuracy = 123;
  File? _image;
  File? _profileImage;
  Uint8List? _imageBytes;
  Uint8List? _profileBytes;

  // Function to pick image from gallery or capturing through camera
  Future<void> _pickImage(ImageSource source, String location) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      if (mounted) {
        if (Platform.isAndroid) {
          if (location == 'profile') {
            setState(() {
              _profileImage = File(image.path);
            });
          } else if (location == 'screen') {
            setState(() {
              _image = File(image.path);
            });
          }
        } else {
          final bytes = await image.readAsBytes();
          if (location == 'profile') {
            setState(() {
              _profileBytes = bytes;
            });
          } else if (location == 'screen') {
            setState(() {
              _imageBytes = bytes;
            });
          }
        }
      }
    }
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
                onTap: () {
                  _pickImage(ImageSource.gallery, location);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  _pickImage(ImageSource.camera, location);
                  Navigator.of(context).pop();
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
        title: const Text("Potato Disease Detection App"),
        centerTitle: true,
        backgroundColor: Colors.green[400],
        actions: [
          Row(
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  _showImageSourceDialog('profile');
                },
                child: CircleAvatar(
                  backgroundImage: _profileBytes != null
                      ? MemoryImage(_profileBytes!)
                      : _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage(''),
                  radius: 50,
                ),
              )
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
                      image: _imageBytes != null
                          ? MemoryImage(_imageBytes!)
                          : _image != null
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
