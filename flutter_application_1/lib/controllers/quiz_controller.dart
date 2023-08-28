import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models/question_model.dart';
import 'package:flutter_application_1/screens/result_screen/result_screen.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';

class QuizController extends GetxController{
  String name = '';
 //question variables
  int get countOfQuestion => _questionsList.length;
  final List<QuestionModel> _questionsList = [
    QuestionModel(
      id: 1,
      question: "Which widget is used to create a button in search Flutter?",
      answer: 2,
      options: ['Text', 'Image','RaisedButton','IconButton'],
    ),
    QuestionModel(
      id: 2,
      question: "Which programming language is used to build Flutter applications?",
      answer: 1,
      options: ['Kotlin', 'Dart', 'Java', 'Go'],
    ),
    QuestionModel(
      id: 3,
      question: "How many types of widgets are there in Flutter?",
      answer: 2,
      options: ['6', '4', '2', '8+'],
    ),
    QuestionModel(
      id: 4,
      question: "Access to a cloud database through Flutter is available through which service?",
      answer: 1,
      options: ['SQLite', 'Firebase Database', 'NOSQL', 'MYSQL'],
    ),
    QuestionModel(
      id: 5,
      question:
          "What element is used as an identifier for components when programming in Flutter?",
      answer: 3,
      options: ['Widgets','Elements','Serial','Keys'],
    ),
    QuestionModel(
      id: 6,
      question: "Which function will return the widgets attached to the screen as a root of the widget tree to be rendered on screen?",
      answer: 2,
      options: ['main()','container()','runApp()','root()'],
    ),
    QuestionModel(
      id: 7,
      question: "Which component allows us to specify the distance between widgets on the screen?",
      answer: 3,
      options: ['SafeArea', 'table', 'AppBar','SizedBox'],

    ),
    QuestionModel(
      id: 8,
      question: "What language is Flutter's rendering engine primarily written in?",
      answer: 3,
      options: ['Kotlin','Dart', 'Java','C++'],
    ),
    QuestionModel(
      id: 9,
      question:
      "What widget would you use for repeating content in Flutter?",
      answer: 2,
      options: ['ExpandedView','Stack', 'ListView', 'ArrayView'],
    ),

    QuestionModel(
      id: 10,
      question:
      "Who developed the Flutter Framework and continues to maintain it today? ",
      answer: 1,
      options: ['Facebook','Google','Microsoft','Oracle '],
    ),
  ];

  List<QuestionModel> get questionsList => [..._questionsList];
  bool _isPressed = false;
  bool get isPressed => _isPressed; //To check if the answer is pressed
  double _numberOfQuestion = 1;
  double get numberOfQuestion => _numberOfQuestion;
  int? _selectAnswer;
  int? get selectAnswer => _selectAnswer;
  int? _correctAnswer;
  int _countOfCorrectAnswers = 0;
  int get countOfCorrectAnswers => _countOfCorrectAnswers;
  //map for check if the question has been answered
  final Map<int, bool> _questionIsAnswerd = {};
  //page view controller
  late PageController pageController;
  //timer
  Timer? _timer;
  final maxSec = 15;
  final RxInt _sec = 15.obs;
  RxInt get sec => _sec;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    resetAnswer();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  //get final score
  double get scoreResult {
    return _countOfCorrectAnswers * 100 / _questionsList.length;
  }

  void checkAnswer(QuestionModel questionModel, int selectAnswer) {
    _isPressed = true;

    _selectAnswer = selectAnswer;
    _correctAnswer = questionModel.answer;

    if (_correctAnswer == _selectAnswer) {
      _countOfCorrectAnswers++;
    }
    stopTimer();
    _questionIsAnswerd.update(questionModel.id, (value) => true);
    Future.delayed(const Duration(milliseconds: 500)).then((value) => nextQuestion());
    update();
  }

  //check if the question has been answered
  bool checkIsQuestionAnswered(int quesId) {
    return _questionIsAnswerd.entries
        .firstWhere((element) => element.key == quesId)
        .value;
  }

  void nextQuestion() {
    if (_timer != null || _timer!.isActive) {
      stopTimer();
    }

    if (pageController.page == _questionsList.length - 1) {
      Get.offAndToNamed(ResultScreen.routeName);
    } else {
      _isPressed = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);

      startTimer();
    }
    _numberOfQuestion = pageController.page! + 2;
    update();
  }

  //called when start again quiz
  void resetAnswer() {
    for (var element in _questionsList) {
      _questionIsAnswerd.addAll({element.id: false});
    }
    update();
  }

  //get right and wrong color
  Color getColor(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Colors.green.shade700;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Colors.red.shade700;
      }
    }
    return Colors.white;
  }

  //het right and wrong icon
  IconData getIcon(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Icons.done;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Icons.close;
      }
    }
    return Icons.close;
  }

  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sec.value > 0) {
        _sec.value--;
      } else {
        stopTimer();
        nextQuestion();
      }
    });
  }

  void resetTimer() => _sec.value = maxSec;

  void stopTimer() => _timer!.cancel();
  //call when start again quiz
  void startAgain() {
    _correctAnswer = null;
    _countOfCorrectAnswers = 0;
    resetAnswer();
    _selectAnswer = null;
    Get.offAllNamed(WelcomeScreen.routeName);
  }
}
