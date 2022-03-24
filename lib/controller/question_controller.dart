import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/screens/score/score_screen.dart';

class QuestionController extends GetxController
  with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  Animation get animation => _animation;

  late PageController _pageController;
  PageController get pageController => _pageController;

  final List<Question> _questions = sampleData.map(
      (question) => Question(
        id: question['id'],
        question: question['question'],
        options: question['options'],
        answer: question['answer_index']
      )
    ).toList();

  List<Question> get questions => _questions;

  late List<bool> _listAns;
  List get listAns => _listAns;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  late int _correctAns;
  int get correctAns => _correctAns;

  late int _selectedAns;
  int get selectedAns => _selectedAns;

  // TODO: See Documentation
  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  @override
  void onInit() {
    _animationController = AnimationController(duration: const Duration(seconds: 60), vsync: this);
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController)
      ..addListener(() {
        update();
      });

      _listAns = [];

    _animationController.forward().whenComplete(nextQuestion);
    _pageController = PageController();
    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    _pageController.dispose();
    super.onClose();
  }

  void checkAns(Question question, int selectedIndex) {
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) {
      ++_numOfCorrectAns;
      _listAns.add(true);
    }
    else {
      _listAns.add(false);
    }

    _animationController.stop();
    update();

    Future.delayed(const Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
      if (!_isAnswered) {
        listAns.add(false);
      }
      if (_questionNumber.value < _questions.length) {
        _isAnswered = false;
        _pageController.nextPage(duration: const Duration(milliseconds: 250),curve: Curves.ease);
        _animationController.reset();
        _animationController.forward().whenComplete(nextQuestion);
      }
      else {
        Get.to(const ScoreScreen());
      }
  }

  void updateTheQuestionNumber(int index) {
    _questionNumber.value = index + 1;
  }

  List<Widget> answerStatus() {
    List<Widget> list = [];
    list.add(const Spacer());
    for (bool answer in _listAns) {
      list.add(
        Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(
          color: answer ? kGreenColor : kRedColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: answer ? kGreenColor : kRedColor)
          ),
          child: Icon(answer ? Icons.done : Icons.close, size: 16),
        )
      );
      list.add(const Spacer());
    }
    return list;
  }
}
