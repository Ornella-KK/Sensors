import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<TextEditingController> _questionControllers = [];
  List<TextEditingController> _option1Controllers = [];
  List<TextEditingController> _option2Controllers = [];
  List<TextEditingController> _option3Controllers = [];
  List<TextEditingController> _option4Controllers = [];
  List<int> _correctOptionIndices = []; // Start with the first question

  void _createQuiz() {
    // Check if all 5 questions are filled
    if (_questionControllers.any((controller) => controller.text.isEmpty)) {
      // Show an error message if any question is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all 5 questions.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Collect all questions and options
    Map<String, dynamic> quizData = {};
    for (int i = 0; i < 5; i++) {
      quizData['$i'] = {
        'questionText': _questionControllers[i].text,
        'options': [
          _option1Controllers[i].text,
          _option2Controllers[i].text,
          _option3Controllers[i].text,
          _option4Controllers[i].text,
        ],
        'correctOptionId': _correctOptionIndices[i],
      };
    }

    // Check the last used quiz ID
    _firestore
        .collection('Quizzes')
        .orderBy(FieldPath.documentId, descending: true)
        .limit(1)
        .get()
        .then((querySnapshot) {
      int lastQuizId = 0; // Default to quizId1 if no quizzes are found
      if (querySnapshot.docs.isNotEmpty) {
        lastQuizId =
            int.parse(querySnapshot.docs.first.id.split('quizId').last);
      }

      int newQuizId = lastQuizId + 1;

      // Create a new quiz document in Firestore with the new quiz ID
      _firestore.collection('Quizzes').doc('quizId$newQuizId').set({
        'title': 'Quiz$newQuizId',
        'questions': quizData,
      }).then((_) {
        // Reset the text controllers and correct option indices
        for (var controller in _questionControllers) {
          controller.clear();
        }
        for (var controller in _option1Controllers) {
          controller.clear();
        }
        for (var controller in _option2Controllers) {
          controller.clear();
        }
        for (var controller in _option3Controllers) {
          controller.clear();
        }
        for (var controller in _option4Controllers) {
          controller.clear();
        }
        for (var index in _correctOptionIndices) {
          index = 0;
        }

        // Show a success message and navigate back to the admin screen
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Questions added successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Pop the current screen
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }).catchError((error) {
        // Show error message
        print('Error creating quiz: $error');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the lists with controllers and indices
    for (int i = 0; i < 5; i++) {
      _questionControllers.add(TextEditingController());
      _option1Controllers.add(TextEditingController());
      _option2Controllers.add(TextEditingController());
      _option3Controllers.add(TextEditingController());
      _option4Controllers.add(TextEditingController());
      _correctOptionIndices.add(0);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Enter 5 questions:'),
              SizedBox(height: 16.0),
              for (int i = 0; i < 5; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _questionControllers[i],
                      decoration:
                          InputDecoration(labelText: 'Question ${i + 1}'),
                    ),
                    TextField(
                      controller: _option1Controllers[i],
                      decoration: InputDecoration(
                          labelText: 'Option 1 for Question ${i + 1}'),
                    ),
                    TextField(
                      controller: _option2Controllers[i],
                      decoration: InputDecoration(
                          labelText: 'Option 2 for Question ${i + 1}'),
                    ),
                    TextField(
                      controller: _option3Controllers[i],
                      decoration: InputDecoration(
                          labelText: 'Option 3 for Question ${i + 1}'),
                    ),
                    TextField(
                      controller: _option4Controllers[i],
                      decoration: InputDecoration(
                          labelText: 'Option 4 for Question ${i + 1}'),
                    ),
                    SizedBox(height: 16.0),
                    Text('Correct Option:'),
                    RadioListTile<int>(
                      title: Text('Option 1'),
                      value: 0,
                      groupValue: _correctOptionIndices[i],
                      onChanged: (value) {
                        setState(() {
                          _correctOptionIndices[i] = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text('Option 2'),
                      value: 1,
                      groupValue: _correctOptionIndices[i],
                      onChanged: (value) {
                        setState(() {
                          _correctOptionIndices[i] = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text('Option 3'),
                      value: 2,
                      groupValue: _correctOptionIndices[i],
                      onChanged: (value) {
                        setState(() {
                          _correctOptionIndices[i] = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text('Option 4'),
                      value: 3,
                      groupValue: _correctOptionIndices[i],
                      onChanged: (value) {
                        setState(() {
                          _correctOptionIndices[i] = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ElevatedButton(
                onPressed: _createQuiz,
                child: Text('Create Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
