import 'package:cloud_firestore/cloud_firestore.dart';

class QuizResult {
  final String userEmail;
  final String quizId;
  final int score;

  QuizResult({
    required this.userEmail,
    required this.quizId,
    required this.score,
  });

  factory QuizResult.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return QuizResult(
      userEmail: data['userEmail'] ?? '',
      quizId: data['quizId'] ?? '',
      score: data['score'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'quizId': quizId,
      'score': score,
    };
  }

  final CollectionReference quizResultsCollection =
      FirebaseFirestore.instance.collection('Scores');

  Future<void> addQuizResult(QuizResult quizResult) async {
    // Get a reference to the user's document
    DocumentReference userDocRef =
        quizResultsCollection.doc(quizResult.userEmail);

    // Check if the user's document exists
    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    if (!userDocSnapshot.exists) {
      // If the document doesn't exist, create it with an empty attempts map
      await userDocRef.set({'attempts': {}});
    }

    // Get the current attempts map
    Map<String, dynamic> attemptsMap = {};
    if (userDocSnapshot.exists &&
        userDocSnapshot.data() is Map<String, dynamic>) {
      Map<String, dynamic> userData =
          userDocSnapshot.data() as Map<String, dynamic>;
      if (userData.containsKey('attempts')) {
        attemptsMap = userData['attempts'] as Map<String, dynamic>;
      }
    }

    // Get the current attempt number for the quiz
    int currentAttempt = 1;
    if (attemptsMap.containsKey(quizResult.quizId)) {
      currentAttempt = attemptsMap[quizResult.quizId]['attempts'] + 1;
    }

    // Add the current attempt to the attempts map
    attemptsMap[quizResult.quizId] = {
      'score': quizResult.score,
      'quizTitle': quizResult.quizId,
      'attempts': currentAttempt,
    };

    // Add the quiz result as a document with the attempt number as the ID
    CollectionReference attemptsCollectionRef =
        userDocRef.collection('attempts');
    await attemptsCollectionRef
        .doc(currentAttempt.toString())
        .set(attemptsMap[quizResult.quizId]);

    // Update the attempts map in the user's document
    await userDocRef.update({'attempts': attemptsMap});
  }
}
