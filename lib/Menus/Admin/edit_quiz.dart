import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditQuestionScreen extends StatefulWidget {
  final String quizId;
  final int questionIndex;
  final Map<String, dynamic> quiz;

  EditQuestionScreen({
    required this.quizId,
    required this.questionIndex,
    required this.quiz,
  });

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  int _correctOptionIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _updateQuestion() {
    FirebaseFirestore.instance.collection('Quizzes').doc(widget.quizId).update({
      'questions.${widget.questionIndex}.questionText': _questionController.text,
      'questions.${widget.questionIndex}.options': [
        _option1Controller.text,
        _option2Controller.text,
        _option3Controller.text,
        _option4Controller.text,
      ],
      'questions.${widget.questionIndex}.correctOptionId': _correctOptionIndex,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question updated successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update question')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Question'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Question'),
              ),
              TextField(
                controller: _option1Controller,
                decoration: InputDecoration(labelText: 'Option 1'),
              ),
              TextField(
                controller: _option2Controller,
                decoration: InputDecoration(labelText: 'Option 2'),
              ),
              TextField(
                controller: _option3Controller,
                decoration: InputDecoration(labelText: 'Option 3'),
              ),
              TextField(
                controller: _option4Controller,
                decoration: InputDecoration(labelText: 'Option 4'),
              ),
              SizedBox(height: 16.0),
              Text('Correct Option:'),
              RadioListTile<int>(
                title: Text('Option 1'),
                value: 0,
                groupValue: _correctOptionIndex,
                onChanged: (value) {
                  setState(() {
                    _correctOptionIndex = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: Text('Option 2'),
                value: 1,
                groupValue: _correctOptionIndex,
                onChanged: (value) {
                  setState(() {
                    _correctOptionIndex = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: Text('Option 3'),
                value: 2,
                groupValue: _correctOptionIndex,
                onChanged: (value) {
                  setState(() {
                    _correctOptionIndex = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: Text('Option 4'),
                value: 3,
                groupValue: _correctOptionIndex,
                onChanged: (value) {
                  setState(() {
                    _correctOptionIndex = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateQuestion,
                child: Text('Update Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
