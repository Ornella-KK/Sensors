import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  Future<void> addUserData(Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(userData)
        .catchError((e) {
      print(e);
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return await FirebaseFirestore.instance.collection("users").doc(uid).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserData() {
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }

  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update(updatedData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> deleteUserData() async {
    await FirebaseFirestore.instance.collection("users").doc(uid).delete();
  }

  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quizzes")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getQuizData(String quizId) async {
    return await FirebaseFirestore.instance.collection("Quizzes").doc(quizId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamQuizData(String quizId) {
    return FirebaseFirestore.instance.collection("Quizzes").doc(quizId).snapshots();
  }

  Future<void> updateQuestion(String quizId, String questionId, String newQuestionText) async {
    try {
      await FirebaseFirestore.instance
          .collection('Quizzes')
          .doc(quizId)
          .update({
            'question$questionId.questionText': newQuestionText,
          });
      print('Question updated successfully');
    } catch (e) {
      print('Failed to update question: $e');
    }
  }

  Future<void> deleteQuizData(String quizId) async {
    await FirebaseFirestore.instance.collection("Quizzes").doc(quizId).delete();
  }

  Future<void> addScoreData(Map<String, dynamic> scoreData, String scoreId) async {
    await FirebaseFirestore.instance
        .collection("Scores")
        .doc(scoreId)
        .set(scoreData)
        .catchError((e) {
      print(e);
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getScoreData(String scoreId) async {
    return await FirebaseFirestore.instance.collection("Scores").doc(scoreId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamScoreData(String scoreId) {
    return FirebaseFirestore.instance.collection("Scores").doc(scoreId).snapshots();
  }

  Future<void> deleteScoreData(String scoreId) async {
    await FirebaseFirestore.instance.collection("Scores").doc(scoreId).delete();
  }
}
