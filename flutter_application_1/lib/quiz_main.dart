import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/multi_player_name_screen.dart';
import 'package:flutter_application_1/screens/number_of_players_screen/number_of_players_screen.dart';
import 'package:flutter_application_1/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter_application_1/screens/result_screen/result_screen.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:flutter_application_1/utils/bindings_app.dart';
import 'package:get/get.dart';

class QuizMain extends StatelessWidget {
  const QuizMain({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BilndingsApp(),
      title: 'Flutter Quiz App',
      home: const WelcomeScreen(),
      //TIP: add all pages routes.
      getPages: [
        GetPage(
            name: WelcomeScreen.routeName, page: () => const WelcomeScreen()),
        GetPage(name: QuizScreen.routeName, page: () => const QuizScreen()),
        GetPage(name: ResultScreen.routeName, page: () => const ResultScreen()),
        GetPage(
            name: MultiplayerNameScreen.routeName,
            page: () => const MultiplayerNameScreen()),
        GetPage(
            name: NumberOfPlayersScreen.routeName,
            page: () => const NumberOfPlayersScreen()),
      ],
    );
  }
}
