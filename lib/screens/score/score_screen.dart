import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controller/question_controller.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              const Spacer(flex: 3),
              Text(
                (_controller.numOfCorrectAns == _controller.questions.length ? "Perfect\n" : "") + "Score",
                style: Theme.of(context)
                  .textTheme.
                  headline3?.
                  copyWith(color: kSecondaryColor)
              ),
              const Spacer(),
              Text(
                "${_controller.numOfCorrectAns * 10}/${_controller.questions.length * 10}",
                style: Theme.of(context)
                  .textTheme.
                  headline4?.
                  copyWith(color: kSecondaryColor)
              ),
              const Spacer(),
              Row(
                children: _controller.answerStatus(),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.of(context)..pop()..pop(),
                child: const Text('Back to Main Screen'),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ],
      ),
    );
  }
}
