import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/multi_player_name_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/quiz_controller.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TIP: I added this screen to enable for user to select number of players.
class NumberOfPlayersScreen extends StatefulWidget {
  const NumberOfPlayersScreen({Key? key}) : super(key: key);
  static const routeName = '/number_of_player_screen';

  @override
  State<NumberOfPlayersScreen> createState() => _NumberOfPlayersScreenState();
}

class _NumberOfPlayersScreenState extends State<NumberOfPlayersScreen> {
  final countController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey();

  void _submit(context) {
    FocusScope.of(context).unfocus();
    if (!formkey.currentState!.validate()) return;
    formkey.currentState!.save();
    Get.offAndToNamed(MultiplayerNameScreen.routeName);
    Get.find<QuizController>().startTimer();
  }

  @override
  void dispose() {
    countController.dispose();
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
                    flex: 1,
                  ),
                  const Text(
                    'Number of Players',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Enter number of players to start this quiz',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: formkey,
                    child: GetBuilder<QuizController>(
                      init: Get.find<QuizController>(),
                      builder: (controller) => TextFormField(
                        keyboardType: TextInputType.number,
                        controller: countController,
                        inputFormatters: [
                          //TIP: this make field receive only digits or number
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: 'Number Of Players',
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
                            return 'Number of players should be not empty';
                            //TIP: change this value to controll number of player limit.
                          } else if (int.parse(val) < 1 || int.parse(val) > 5) {
                            return 'Number of players should be between 1 to 5 players';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (String? val) async {
                          final SharedPreferences preferences =
                              await SharedPreferences.getInstance();

                          await preferences.setInt('number_of_players',
                              int.parse(countController.text));
                              //TIP: reset previous scores for user
                          await preferences
                              .setStringList('previous_scores', []);
                          await preferences
                              .setStringList('previous_players', []);
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
                  const Spacer(
                    flex: 1,
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
