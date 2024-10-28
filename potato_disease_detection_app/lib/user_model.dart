import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// MyUser class for circulating user data inside app overall
class MyUser {
  String? name;
  String? email;
  String? phone;
  String? password;
  String? imageUrl;

// Constructor for creating object of class
  MyUser({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.imageUrl,
  });

// For creating user on Firebase
  void createUser({
    required String? name,
    required String? email,
    required String? phone,
    required String? password,
    required String? imageUrl,
  }) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('data')
        .add({
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'image': imageUrl,
    });
  }

// Fetching user data from firebase and returning through this method
  Future<MyUser?> fetchUser() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print('userId....$userId');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('data')
        .get();
    print("snapshot........$snapshot");
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = snapshot.docs.first;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      MyUser user = MyUser(
          name: data['name'],
          email: data['email'],
          phone: data['phone'],
          password: data['password'],
          imageUrl: data['image']);
      return user;
    } else {
      return null;
    }
  }
}
