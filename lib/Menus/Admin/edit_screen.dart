import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_quiz.dart'; // Assuming this is the correct import for EditQuestionScreen

class EditQuizScreen extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> quiz;

  EditQuizScreen({required this.quiz});

  @override
  _EditQuizScreenState createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  @override
  Widget build(BuildContext context) {
    print('EditQuizScreen - Quiz ID: ${widget.quiz?.id}');

    if (widget.quiz == null ||
        widget.quiz.data() == null ||
        widget.quiz.data()?['questions'] == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Quiz data is missing or invalid.'),
        ),
      );
    }

    print('Quiz Questions: ${widget.quiz.data()?['questions']}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz'),
      ),
      body: ListView.builder(
        itemCount: widget.quiz.data()?['questions'].length,
        itemBuilder: (context, index) {
          var question = widget.quiz.data()?['questions'][index];
          return Card(
            child: ListTile(
              title: Text('Question ${index + 1}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditQuestionScreen(
                      quizId: widget.quiz.id,
                      questionIndex: index,
                      quiz: widget.quiz.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
