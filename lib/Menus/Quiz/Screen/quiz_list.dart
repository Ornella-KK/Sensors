import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../session.dart';
import 'quiz_screen.dart';

class QuizListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Quizzes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final quizzes = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quizData = quizzes[index].data() as Map<String, dynamic>;
              final quizId = quizzes[index].id;

              return Card(
                child: ListTile(
                  title: Text(quizData['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(quizId: quizId),
                      ),
                    );
                    SessionManager.resetSessionTimer(context);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String currentUserEmail =
              FirebaseAuth.instance.currentUser?.email ?? '';
          if (currentUserEmail.isNotEmpty) {
            // Retrieve all attempts for the current user
            QuerySnapshot scoresSnapshot = await FirebaseFirestore.instance
                .collection('Scores')
                .doc(currentUserEmail)
                .collection('attempts')
                .get();

            List<Widget> scoreCards = scoresSnapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text('Quiz: ${data['quizTitle']}'),
                  subtitle: Text('Score: ${data['score']}'),
                ),
              );
            }).toList();

            // Display all quiz scores in a dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('My Scores'),
                content: SingleChildScrollView(
                  child: Column(
                    children: scoreCards,
                  ),
                ),
              ),
            );
          }
        },
        child: Icon(Icons.score),
      ),
    );
  }
}
