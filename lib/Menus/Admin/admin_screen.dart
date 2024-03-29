import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_quiz.dart';
import 'edit_screen.dart';

class QuizAdminScreen extends StatefulWidget {
  @override
  _QuizAdminScreenState createState() => _QuizAdminScreenState();
}

class _QuizAdminScreenState extends State<QuizAdminScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<DocumentSnapshot> _quizzes;

  Future<void> _refreshQuizzes() async {
  try {
    // Fetch new data from Firestore
    QuerySnapshot querySnapshot =
        await _firestore.collection('Quizzes').get();

    setState(() {
      // Update the UI with the new data
      // Assign the new querySnapshot to a variable and use it in your ListView.builder
      _quizzes = querySnapshot.docs;
    });
  } catch (error) {
    // Handle any errors that occur during the refresh process
    print('Error refreshing quizzes: $error');
  }
}


  void _editQuiz(DocumentSnapshot<Map<String, dynamic>> quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditQuizScreen(quiz: quiz)),
    );
  }

  void _deleteQuiz(DocumentSnapshot quiz) {
    // Delete the quiz document from Firestore
    _firestore.collection('Quizzes').doc(quiz.id).delete().then((_) {
      // Show success message or update UI
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Deleted'),
          content: Text('Quiz has been deleted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);

                // Optionally, you can use Navigator.popUntil to go back multiple screens if needed
                // Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      // Show error message
    });
  }

 @override
  void initState() {
    super.initState();
    _quizzes = []; // Initialize _quizzes as an empty list
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshQuizzes,
        child: FutureBuilder<QuerySnapshot>(
          future: _firestore.collection('Quizzes').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot<Map<String, dynamic>> quiz =
                      snapshot.data!.docs[index]
                          as DocumentSnapshot<Map<String, dynamic>>;
                  return Card(
                    child: ListTile(
                      title: Text('Quiz ${quiz.id}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editQuiz(quiz);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteQuiz(quiz);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateQuizScreen()),
          );
        },
      ),
    );
  }
}
