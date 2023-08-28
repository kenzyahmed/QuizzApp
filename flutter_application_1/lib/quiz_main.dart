import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter_application_1/screens/result_screen/result_screen.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:flutter_application_1/utils/bindings_app.dart';
import 'package:get/get.dart';

class quizMain extends StatelessWidget {
  const quizMain({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BilndingsApp(),
      title: 'Flutter Quiz App',
      home:  WelcomeScreen(),
      getPages: [
        GetPage(name: WelcomeScreen.routeName, page: () => WelcomeScreen()),
        GetPage(name: QuizScreen.routeName, page: () =>  QuizScreen()),
        GetPage(name: ResultScreen.routeName, page: () =>  ResultScreen()),
      ],
    );
  }
}
