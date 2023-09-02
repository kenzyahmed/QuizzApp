import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/multi_player_name_screen.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/quiz_controller.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);
  static const routeName = '/result_screen';

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // Obtain shared preferences.
  late SharedPreferences preferences;
  late List<String> previousScores = [];
  late List<String> previousPlayers = [];
  late int numberOfPlayers = 0;

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

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
                String n = controller.name;
                String v = '${controller.scoreResult.round()} /100';
                previousScores.add(v);
                previousPlayers.add(n);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Congratulation',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      n, // Use the variable 'n'
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: KPrimaryColor,
                          ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Your Score is',
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Colors.black,
                              ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      v, // Use the variable 'v'
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: KPrimaryColor,
                          ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                      //TIP: change button value if user end all quizes.
                      text: previousScores.length >= numberOfPlayers
                          ? 'Scores'
                          : 'Other Player',
                      onPressed: () async {
                        await preferences.setStringList(
                            "previous_scores", previousScores);
                        await preferences.setStringList(
                            "previous_players", previousPlayers);
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MultiplayerNameScreen(isForScoreOnly: previousScores.length == numberOfPlayers,)));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) async{
                          if (kDebugMode) {
                            print("Signed Out");
                          }
                          //TIP: this command is for clear all values that saved in shared preferences
                          await preferences.clear();
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()));
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
          _storeDataInFirestore(
              controller.name, '${controller.scoreResult.round()} /100');
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void initPreferences() async {
    preferences = await SharedPreferences.getInstance();
    previousScores = preferences.getStringList("previous_scores") ?? [];
    previousPlayers = preferences.getStringList("previous_players") ?? [];
    numberOfPlayers = preferences.getInt("number_of_players") ?? 0;
    setState(() {});
  }
}
