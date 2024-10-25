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
  bool _isHoovering = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LogIn Page"),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                width: 300,
                height: 50,
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
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
                ),
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefix: Icon(Icons.lock)),
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
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    authService
                        .signIn(emailController.text, passwordController.text)
                        .then((user) {
                      if (user != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomePage(
                                  currentUser: MyUser(),
                                )));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("User does not exist"),
                          duration: Duration(milliseconds: 3000),
                        ));
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Failure in validation"),
                      duration: Duration(milliseconds: 3000),
                    ));
                  }
                },
                child: const Text('SignIn'),
              ),
              const SizedBox(
                width: 300,
                height: 50,
              ),
              SizedBox(
                  width: 300,
                  height: 100,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      setState(() {
                        _isHoovering = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _isHoovering = false;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: Text(
                        "Don't have an account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: _isHoovering ? Colors.blue : Colors.red[400],
                            fontSize: 18,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
