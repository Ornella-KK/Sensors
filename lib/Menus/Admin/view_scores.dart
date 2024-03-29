import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Scores').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = documents[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserAttemptsScreen(userEmail: document.id),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text(document.id),
                    subtitle: Text('Tap to view Scores'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserAttemptsScreen extends StatelessWidget {
  final String userEmail;

  UserAttemptsScreen({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Scores')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Scores')
            .doc(userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          Map<String, dynamic>? attemptsMap =
              snapshot.data!.data() as Map<String, dynamic>?;

          if (attemptsMap != null && attemptsMap.containsKey('attempts')) {
            attemptsMap = attemptsMap['attempts'] as Map<String, dynamic>?;
          } else {
            attemptsMap = null;
          }

          if (attemptsMap == null || attemptsMap.isEmpty) {
            return Center(
              child: Text('No attempts found'),
            );
          }

          return ListView.builder(
            itemCount: attemptsMap?.length ?? 0,
            itemBuilder: (context, index) {
              String quizId = attemptsMap?.keys.toList()[index] ?? '';
              if (quizId.isEmpty) {
                return SizedBox(); // Or any other widget for handling the empty case
              }
              Map<String, dynamic>? attemptData = attemptsMap?[quizId];
              if (attemptData == null) {
                return SizedBox(); // Or any other widget for handling the null case
              }
              return Card(
                child: ListTile(
                  title: Text('Quiz Title: ${attemptData['quizTitle']}'),
                  subtitle: Text(
                      'Score: ${attemptData['score']}, Attempt: ${attemptData['attempts']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
