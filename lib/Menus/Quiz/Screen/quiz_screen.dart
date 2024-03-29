import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Menus/Quiz/model/quiz_model.dart';
import 'package:navigation/Menus/Quiz/providers/quiz_provider.dart';
import 'package:provider/provider.dart';

import '../service/quiz_service.dart';
import 'quiz_list.dart';

class QuizScreen extends StatelessWidget {
  final String quizId;

  QuizScreen({required this.quizId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: QuizService.getQuizData(quizId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          print("Error fetching quiz data: ${snapshot.error}");
          return Text("Error fetching quiz data");
        } else {
          Quiz quiz = snapshot.data as Quiz;
          // Schedule the call to setQuiz after the build phase is complete
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            Provider.of<QuizProvider>(context, listen: false).setQuiz(quiz);
          });
          return Scaffold(
            appBar: AppBar(title: Text('Quiz')),
            body: QuizWidget(),
          );
        }
      },
    );
  }
}


class QuizWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quizprovider = Provider.of<QuizProvider>(context);

    if (quizprovider.quiz == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (quizprovider.isQuizComplete) {
      return Text('');
    }

    return Column(
      children: [
        Text(
          'Question ${quizprovider.currentIndex + 1}/${quizprovider.quiz!.questions.length}',
        ),
        Container(
          height: 65, // Adjust the height as needed
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                quizprovider.quiz!.questions[quizprovider.currentIndex].questionText,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Column(
          children:
              quizprovider.quiz!.questions[quizprovider.currentIndex].options
                  .asMap()
                  .entries
                  .map(
                    (option) => RadioListTile(
                      title: Text(option.value),
                      value: option.key,
                      groupValue: quizprovider.selectedOption,
                      onChanged: (value) {
                        quizprovider.setSelectedOption(value);
                      },
                    ),
                  )
                  .toList(),
        ),
        ElevatedButton(
          onPressed: () {
            quizprovider.answerQuestion(context, FirebaseAuth.instance); 
          },
          child: Text(quizprovider.currentIndex ==
                  quizprovider.quiz!.questions.length - 1
              ? 'Finish'
              : 'Next Question'),
        ),
      ],
    );
  }
}
