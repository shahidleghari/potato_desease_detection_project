import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:potato_disease_detection_app/auth_service.dart';
import 'package:potato_disease_detection_app/images_work.dart';
import 'package:potato_disease_detection_app/login.dart';
import 'package:potato_disease_detection_app/machine_learning.dart';
import 'package:potato_disease_detection_app/user_model.dart';

class HomePage extends StatefulWidget {
  final MyUser? currentUser;
  const HomePage({super.key, required this.currentUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImageWorks imageWorks = ImageWorks();
  final MachineLearning machineLearning = MachineLearning();
  String prediction = 'Potato_Healthy';
  double? accuracy = 99.98;
  String? imageUrl;
  File? _image;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    machineLearning.loadModel();
  }

  Future<void> _onPickImage(String location, File image) async {
    if (location == 'profile') {
      var uid = FirebaseAuth.instance.currentUser!.uid;
      await imageWorks.uploadAndUpdateImage(
          image, uid, widget.currentUser!.email!, imageUrl);
      setState(() {
        widget.currentUser?.imageUrl = imageUrl;
      });
    } else {
      final result = await machineLearning.predictDisease(image);
      setState(() {
        prediction = result['prediction'];
        accuracy = result['confidence'];
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final avatarRadius = screenWidth * 0.1;
    final padding = screenWidth * 0.1;
    final imageSize = screenWidth * 0.5;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        leading: GestureDetector(
          onTap: () => imageWorks.showImagePreviewAndOptions(
              context,
              widget.currentUser?.imageUrl ?? '',
              'profile',
              () => imageWorks.showImageSourceDialog(context, 'profile',
                  (image) => _onPickImage('profile', image))),
          child: CircleAvatar(
            backgroundImage: widget.currentUser?.imageUrl != null
                ? NetworkImage(widget.currentUser!.imageUrl!)
                : null,
            radius: avatarRadius,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${widget.currentUser?.name.toString()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: screenHeight * 0.05),
              IconButton(
                  onPressed: () {
                    _authService.signOut();
                    Navigator.of(context).pushReplacement(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              IconButton(
                onPressed: () => imageWorks.showImageSourceDialog(context,
                    'screen', (image) => _onPickImage('screen', image)),
                icon: const Icon(Icons.camera_alt_rounded, size: 100),
              ),
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/images/image.JPG'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text("Type of Disease:      $prediction",
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
              Text("Accuracy:             ${accuracy?.toStringAsFixed(2)}%",
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
