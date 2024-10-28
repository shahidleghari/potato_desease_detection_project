import 'package:flutter/material.dart';
import 'package:potato_disease_detection_app/auth_service.dart';
import 'package:potato_disease_detection_app/homepage.dart';
import 'package:potato_disease_detection_app/signup.dart';
import 'package:potato_disease_detection_app/user_model.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  AuthService authService = AuthService();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Login Page"),
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
                // Email text field
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'e.g: abc123@gmail.com',
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
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                SizedBox(height: screenHeight * 0.04),
                // Password text field
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
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
                      return 'Incorrect Password';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                SizedBox(height: screenHeight * 0.04),
                // Login Button
                SizedBox(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        authService
                            .signIn(
                                emailController.text, passwordController.text)
                            .then((user) async {
                          if (user != null) {
                            MyUser myUser = MyUser();
                            MyUser? fetchedUser = await myUser.fetchUser();
                            if (fetchedUser != null) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return HomePage(currentUser: fetchedUser);
                              }));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    'Error in fetching user data from firebase'),
                                duration: Duration(milliseconds: 3000),
                              ));
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("User does not exist"),
                              duration: Duration(milliseconds: 3000),
                            ));
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Failure in validation"),
                          duration: Duration(milliseconds: 3000),
                        ));
                      }
                    },
                    child: Text('Login',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                // Create account button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  icon: const Icon(Icons.account_circle_outlined,
                      color: Colors.white),
                  label: Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: Size(screenWidth * 0.6, screenHeight * 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 5,
                    shadowColor: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
