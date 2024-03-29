class Quiz {
  final String id;
  final String title;
  final List<Question> questions;

  Quiz({
    this.id = '',
    required this.title,
    required this.questions,
  });
}


class Question {
  final String questionText;
  final List<String> options;
  final int correctOptionId;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionId,
  });
}
