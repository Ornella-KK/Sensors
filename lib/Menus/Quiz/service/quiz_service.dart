import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/quiz_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/quiz_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/quiz_model.dart';

class QuizService {
  static Future<Quiz> getQuizData(String quizId1) async {
    try {
      DocumentSnapshot quizSnapshot = await FirebaseFirestore.instance
          .collection('Quizzes')
          .doc(quizId1)
          .get();
      Quiz quiz = Quiz(
        title: quizSnapshot['title'],
        questions: (quizSnapshot['questions'] as Map<String, dynamic>).values.map((questionData) {
          return Question(
            questionText: questionData['questionText'],
            options: (questionData['options'] as List).cast<String>(),
            correctOptionId: questionData['correctOptionId'],
          );
        }).toList(),
      );
      return quiz;
    } catch (e, stackTrace) {
      print("Error fetching quiz data: $e");
      print(stackTrace); 
      throw e;
    }
  }
}

