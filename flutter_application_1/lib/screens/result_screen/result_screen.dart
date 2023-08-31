import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/MultiplayerNameScreen.dart';
import 'package:flutter_application_1/screens/home_screen.dart'; // Import the relevant files
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/quiz_controller.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';

import '../../constants.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);
  static const routeName = '/result_screen';

  // Function to store data in Firestore
  void _storeDataInFirestore(String name, String value) {
    final db = FirebaseFirestore.instance;
    db.collection('users').add({
      "name": name,
      "value": value,
    }).then((_) {
      Get.snackbar("Success", "Data created");
    }).catchError((error) {
      Get.snackbar("Error", "An error occurred while storing data");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: GetBuilder<QuizController>(
              init: Get.find<QuizController>(),
              builder: (controller) {
                var n = controller.name;
                var v = '${controller.scoreResult.round()} /100';
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Congratulation',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      n, // Use the variable 'n'
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: KPrimaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Your Score is',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      v, // Use the variable 'v'
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: KPrimaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                      text: 'Other Player',
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => MultiplayerNameScreen())),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          print("Signed Out");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => SignInScreen()));
                        });
                      },
                      text: 'Sign Out',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final controller = Get.find<QuizController>();
          _storeDataInFirestore(controller.name, '${controller.scoreResult.round()} /100');
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
