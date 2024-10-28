import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_disease_detection_app/auth_service.dart';
import 'package:potato_disease_detection_app/homepage.dart';
import 'package:potato_disease_detection_app/user_model.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignupState();
}

class _SignupState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  AuthService authService = AuthService();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Creating new account"),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Name text field
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g: Saddar U Din',
                    labelText: 'Name',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.abc_rounded),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.04,
                        horizontal: screenWidth * 0.04),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required!!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.05),
                // Email text field
                TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'e.g abc123@gmail.com',
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.04,
                          horizontal: screenWidth * 0.04),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 16)),
                SizedBox(height: screenHeight * 0.05),
                // Phone number text field
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'e.g 03480331849',
                    labelText: 'Phone',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone_android_rounded),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.04,
                        horizontal: screenWidth * 0.04),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required!!';
                    }
                    if (value.length != 11) {
                      return 'Phone numbers must be of 11 characters';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(height: screenHeight * 0.05),
                // Password text field
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Enter new password',
                    labelText: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.04,
                        horizontal: screenWidth * 0.04),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must contain at least 6 characters';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(height: screenHeight * 0.05),
                // SignUp Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authService
                          .signUp(emailController.text, passwordController.text)
                          .then((user) {
                        if (user != null) {
                          MyUser myUser = MyUser();
                          // Storing data of user on Firebase
                          myUser.createUser(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                              imageUrl: null);

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                      currentUser: MyUser(
                                          name: nameController.text,
                                          email: emailController.text,
                                          phone: phoneController.text,
                                          password: passwordController.text,
                                          imageUrl: null))));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Error in SignUp"),
                            duration: Duration(milliseconds: 3000),
                          ));
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Validation Error"),
                        duration: Duration(milliseconds: 3000),
                      ));
                    }
                  },
                  child: const Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
