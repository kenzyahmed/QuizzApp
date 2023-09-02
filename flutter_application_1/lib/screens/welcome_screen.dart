import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/multi_player_name_screen.dart';
import 'package:flutter_application_1/screens/number_of_players_screen/number_of_players_screen.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/quiz_controller.dart';
import 'package:flutter_application_1/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const routeName = '/welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _nameController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey();

  late SharedPreferences preferences;
  late List<String> previousScores = [];
  late int numberOfPlayers = 0;
  bool shouldShowCompleteButton = false;

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  void _submit(context) {
    FocusScope.of(context).unfocus();
    if (!_formkey.currentState!.validate()) return;
    _formkey.currentState!.save();
    Get.offAndToNamed(QuizScreen.routeName);
    Get.find<QuizController>().startTimer();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/sui.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  //TIP: make widget constant if for build it just one time and never rebuild it again. *for performance wise
                  const Text(
                    'Let\'s start Quiz,',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Enter your name to start',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: _formkey,
                    child: GetBuilder<QuizController>(
                      init: Get.find<QuizController>(),
                      builder: (controller) => TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                        ),
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return 'Name should not be empty';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (String? val) {
                          controller.name = val!.trim().toUpperCase();
                        },
                        onFieldSubmitted: (_) => _submit(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        CustomButton(
                          width: double.infinity,
                          onPressed: () => _submit(context),
                          text: 'Let\'s Start Quiz',
                        ),
                        const SizedBox(
                            height: 20), // Adding spacing between buttons
                        CustomButton(
                          width: double.infinity,
                          text: 'Let\'s Start with Multi Players',
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NumberOfPlayersScreen())),
                        ),
                        //TIP: add this button when previous scores is less than number of players
                        if(shouldShowCompleteButton)
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            CustomButton(
                              width: double.infinity,
                              text: 'Complete Previous Quiz',
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MultiplayerNameScreen())),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  // TIP: I added this to enable user to logout from this screen
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CustomButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) async {
                          if (kDebugMode) {
                            print("Signed Out");
                          }
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initPreferences() async {
    preferences = await SharedPreferences.getInstance();
    previousScores = preferences.getStringList("previous_scores") ?? [];
    numberOfPlayers = preferences.getInt("number_of_players") ?? 0;
    setState(() {
      //TIP: check if previous scores is less than number of players.
      shouldShowCompleteButton = previousScores.length < numberOfPlayers;
    });
  }
}
