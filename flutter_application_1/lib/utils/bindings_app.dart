import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/quiz_controller.dart';

//This is a method declaration. In GetX,
// this method is used to specify the dependencies required
// by the controller.
class BilndingsApp implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuizController());
    // is to register a factory function that
    // creates an instance of the specified class
  }
}