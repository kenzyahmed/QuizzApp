import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/quiz_main.dart';
import 'package:flutter_application_1/screens/reset_password.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool _isErrorVisible = false; // Flag to control error message visibility
  late SharedPreferences preferences;

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('images/back.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        bottom: 20), // Adjust the padding as needed
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[100],
                      ),
                    ),
                  ),
                  if (_isErrorVisible)
                    const Text(
                      "Invalid username or password.",
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: _resetError,
                    child: reusableTextField(
                      "Enter Your Email",
                      Icons.person_outline,
                      false,
                      _emailTextController,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: _resetError,
                    child: reusableTextField(
                      "Enter Password",
                      Icons.lock_outline,
                      true,
                      _passwordTextController,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  forgetPassword(context),
                  firebaseUIButton(context, "Sign In", () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    )
                        .then((value) {
                      //TIP: add this command to save login value.
                      preferences.setBool("is_logged_in", true);
                      // TIP: change push to pushReplacement to route to another screen and remove auth screen.
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QuizMain()));
                    }).catchError((error) {
                      //TIP: add this check before any print to make print command only for debug moda *this recommended by flutter*
                      if (kDebugMode) {
                        print("Error ${error.toString()}");
                      }
                      setState(() {
                        _isErrorVisible = true; // Show error message
                      });
                    });
                  }),
                  signUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }

  void _resetError() {
    setState(() {
      _isErrorVisible = false;
    });
  }

  void initPreferences() async {
    preferences = await SharedPreferences.getInstance();
    //TIP: check if user is logged in before or not.
    if (preferences.getBool("is_logged_in") ?? false) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const QuizMain()));
    }
  }
}
