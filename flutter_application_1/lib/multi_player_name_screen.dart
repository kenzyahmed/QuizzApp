// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_application_1/controllers/quiz_controller.dart';
import 'package:flutter_application_1/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiplayerNameScreen extends StatefulWidget {
  const MultiplayerNameScreen({
    Key? key,
    this.isForScoreOnly = false,
  }) : super(key: key);
  static const routeName = '/multi_player_welcome_screen';
  final bool isForScoreOnly;

  @override
  State<MultiplayerNameScreen> createState() => _MultiplayerNameScreenState();
}

class _MultiplayerNameScreenState extends State<MultiplayerNameScreen> {
  final _nameController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey();

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
                    flex: 3,
                  ),
                  const PreviousScoresWidget(),
                  //TIP: Remove this line if you want to show add form option
                  if (!widget.isForScoreOnly)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  const Spacer(
                    flex: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreviousScoresWidget extends StatefulWidget {
  const PreviousScoresWidget({super.key});

  @override
  State<PreviousScoresWidget> createState() => _PreviousScoresWidgetState();
}

class _PreviousScoresWidgetState extends State<PreviousScoresWidget> {
  late SharedPreferences preferences;
  late List<String> previousScores = [];
  late List<String> previousPlayers = [];

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return previousPlayers.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Player Name",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      "Score",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                for (int i = 0; i < previousScores.length; i++) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        previousPlayers[i],
                        style: const TextStyle(fontSize: 30),
                      ),
                      Text(
                        previousScores[i],
                        style: const TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ],
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          );
  }

  void initPreferences() async {
    preferences = await SharedPreferences.getInstance();
    previousScores = preferences.getStringList("previous_scores") ?? [];
    previousPlayers = preferences.getStringList("previous_players") ?? [];
    print("FDKKFOKDFOKODFKKVDF >>>>>>>>> ${previousPlayers.length}");
    setState(() {});
  }
}
