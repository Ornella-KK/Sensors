import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';
import 'db_service.dart';

class SyncService {
  final DatabaseHelper dbHelper;
  final DatabaseService databaseService;

  SyncService({required this.dbHelper, required this.databaseService});

  // Synchronize data from Firestore to SQLite for Quizzes collection
  void syncQuizzesFromFirestoreToSQLite() {
    FirebaseFirestore.instance.collection("Quizzes").get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        Map<String, dynamic> quizData = doc.data() as Map<String, dynamic>;
        await dbHelper.insertOrUpdateQuiz(quizData);
      });
    });
  }

  // Synchronize data from SQLite to Firestore for Quizzes collection
  void syncQuizzesFromSQLiteToFirestore() {
    dbHelper.getQuizData().then((quizDataList) {
      quizDataList.forEach((quizData) {
        String quizId = quizData['id'];
        databaseService.addQuizData(quizData, quizId);
      });
    });
  }

  // Synchronize data from Firestore to SQLite for Scores collection
void syncScoresFromFirestoreToSQLite() {
  FirebaseFirestore.instance.collection("Scores").get().then((querySnapshot) {
    querySnapshot.docs.forEach((doc) async {
      Map<String, dynamic> scoreData = doc.data() as Map<String, dynamic>;
      await dbHelper.insertScore(scoreData);
    });
  });
}

// Synchronize data from SQLite to Firestore for Scores collection
void syncScoresFromSQLiteToFirestore() {
  dbHelper.getScoreData().then((scoreDataList) {
    scoreDataList.forEach((scoreData) {
      String scoreId = scoreData['id'];
      databaseService.addScoreData(scoreData, scoreId);
    });
  });
}

/* // Synchronize data from Firestore to SQLite for Users collection
void syncUsersFromFirestoreToSQLite() {
  FirebaseFirestore.instance.collection("Users").get().then((querySnapshot) {
    querySnapshot.docs.forEach((doc) async {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      await dbHelper.insertUser(userData);
    });
  });
}

// Synchronize data from SQLite to Firestore for Users collection
void syncUsersFromSQLiteToFirestore() {
  dbHelper.getUserData().then((userDataList) {
    userDataList.forEach((userData) {
      String userId = userData['id'];
      databaseService.addUserData(userData, userId);
    });
  });
} */
}
