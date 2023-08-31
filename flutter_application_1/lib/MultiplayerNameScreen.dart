
import 'package:flutter/material.dart';
import 'package:flutter_application_1/MultiplayerNameScreen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/quiz_controller.dart';
import 'package:flutter_application_1/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
class MultiplayerNameScreen extends StatefulWidget {
  const MultiplayerNameScreen({Key? key}) : super(key: key);
  static const routeName = '/welcome_screen';

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
        constraints: BoxConstraints.expand(),
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
                  Text(
                    'Let\'s start Quiz,',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'Enter your name to start',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 25,),
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
                  SizedBox(height: 10),
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
