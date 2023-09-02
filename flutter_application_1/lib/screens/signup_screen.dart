import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'images/back.jpg'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                      "Enter UserName",
                      Icons.person_outline,
                      false,
                      _userNameTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                      "Enter Email Id",
                      Icons.person_outline,
                      false,
                      _emailTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                      "Enter Password",
                      Icons.lock_outlined,
                      true,
                      _passwordTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseUIButton(context, "Sign Up", () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      )
                          .then((value) {
                        if (kDebugMode) {
                          print("Created New Account");
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()),
                        );
                      }).onError((error, stackTrace) {
                        if (kDebugMode) {
                          print("Error ${error.toString()}");
                        }
                      });
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
