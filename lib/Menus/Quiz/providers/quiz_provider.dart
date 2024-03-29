import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/quiz_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/results_model.dart';

class QuizProvider with ChangeNotifier {
  Quiz? _quiz;
  int _currentIndex = 0;
  int _correctAnswer = 0;
  int? _selectedOption;

  Quiz? get quiz => _quiz;
  int get currentIndex => _currentIndex;
  int get correctAnswer => _correctAnswer;
  int? get selectedOption => _selectedOption;

  bool get isQuizComplete => _currentIndex == _quiz?.questions.length;

  void setQuiz(Quiz quiz) {
    _quiz = quiz;
    _currentIndex = 0;
    _correctAnswer = 0;
    _selectedOption = null;
    notifyListeners();
  }

  void setSelectedOption(int? value) {
    _selectedOption = value;
    notifyListeners();
  }

  void saveQuizResult(FirebaseAuth auth, String quizId, int totalQuestions) {
  // Retrieve the current user
  User? user = auth.currentUser;

  if (user != null) {
    double scorePercentage = (_correctAnswer / totalQuestions) * 100;

    // Create a QuizResult object with the user's email
    QuizResult quizResult = QuizResult(
      userEmail: user.email!,
      quizId: quizId,
      score: scorePercentage.toInt(),
    );

    // Save the QuizResult to Firestore
    quizResult.addQuizResult(quizResult);
  }
}

  void answerQuestion(BuildContext context, FirebaseAuth auth) {
    if (_selectedOption != null) {
      if (_selectedOption == quiz!.questions[_currentIndex].correctOptionId) {
        _correctAnswer++;
      }

      _currentIndex++;

      if (_currentIndex != _quiz!.questions.length) {
        _selectedOption = null;
      }

      if (_currentIndex == _quiz!.questions.length) {
        saveQuizResult(auth, _quiz!.title, _quiz!.questions.length);
        // Quiz is complete, show results
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Quiz Results'),
              content: Text(
                'You answered $_correctAnswer out of ${_quiz!.questions.length} questions correctly.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/quiz_list');
                    // Reset values for reattempt
                    _currentIndex = 0;
                    _correctAnswer = 0;
                    _selectedOption = null;
                    notifyListeners();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        notifyListeners();
      }
    }

    notifyListeners();
  }
}
