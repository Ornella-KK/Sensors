import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final _databaseName = 'quiz.db';
  static final _databaseVersion = 1;

  static final tableQuizzes = 'quizzes';
  static final tableQuestions = 'questions';
  static final tableScores = 'scores';
  static final tableUsers = 'users';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnQuestionText = 'questionText';
  static final columnOptions = 'options';
  static final columnCorrectOptionIndex = 'correctOptionIndex';
  static final columnUserId = 'userId';
  static final columnQuizTitle = 'quizTitle';
  static final columnScore = 'score';
  static final columnIsAdmin = 'isAdmin';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableQuizzes (
      $columnId TEXT PRIMARY KEY,
      $columnTitle TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE $tableQuestions (
      $columnId TEXT PRIMARY KEY,
      $columnQuestionText TEXT NOT NULL,
      $columnOptions TEXT NOT NULL,
      $columnCorrectOptionIndex INTEGER NOT NULL,
      $columnUserId TEXT NOT NULL,
      FOREIGN KEY ($columnUserId) REFERENCES $tableQuizzes($columnId) ON DELETE CASCADE
    )
  ''');

    await db.execute('''
    CREATE TABLE $tableScores (
      $columnId TEXT PRIMARY KEY,
      $columnUserId TEXT NOT NULL,
      $columnQuizTitle TEXT NOT NULL,
      $columnScore INTEGER NOT NULL,
      FOREIGN KEY ($columnUserId) REFERENCES $tableQuizzes($columnId) ON DELETE CASCADE
    )
  ''');

    await db.execute('''
    CREATE TABLE $tableUsers (
      $columnId TEXT PRIMARY KEY,
      $columnIsAdmin INTEGER NOT NULL
    )
  ''');
  }

  Future<int> insertUser(Map<String, dynamic> userData) async {
    Database db = await database;
    return await db.insert(tableUsers, userData);
  }

  Future<int> insertQuiz(Map<String, dynamic> quizData) async {
    Database db = await database;
    return await db.insert(tableQuizzes, quizData);
  }

  Future<int> insertQuestion(Map<String, dynamic> questionData) async {
    Database db = await database;
    return await db.insert(tableQuestions, questionData);
  }

  Future<int> insertScore(Map<String, dynamic> scoreData) async {
    Database db = await database;
    return await db.insert(tableScores, scoreData);
  }

  Future<List<Map<String, dynamic>>> getScoreData() async {
    Database db = await database;
    return await db.query(tableScores);
}

  Future<int> updateQuiz(String quizId, Map<String, dynamic> updatedData) async {
    Database db = await database;
    return await db.update(
      tableQuizzes,
      updatedData,
      where: '$columnId = ?',
      whereArgs: [quizId],
    );
  }

  Future<int> updateQuestion(
      String questionId, Map<String, dynamic> updatedData, String userId) async {
    Database db = await database;
    // Update question with userId
    return await db.update(
      tableQuestions,
      updatedData,
      where: '$columnId = ? AND $columnUserId = ?',
      whereArgs: [questionId, userId],
    );
  }

  Future<int> updateScore(
      String scoreId, Map<String, dynamic> updatedData, String userId) async {
    Database db = await database;
    // Update score with userId
    return await db.update(
      tableScores,
      updatedData,
      where: '$columnId = ? AND $columnUserId = ?',
      whereArgs: [scoreId, userId],
    );
  }

  Future<int> deleteQuiz(String quizId) async {
    Database db = await database;
    return await db.delete(
      tableQuizzes,
      where: '$columnId = ?',
      whereArgs: [quizId],
    );
  }

  Future<int> deleteQuestion(String questionId, String userId) async {
    Database db = await database;
    // Delete question with userId
    return await db.delete(
      tableQuestions,
      where: '$columnId = ? AND $columnUserId = ?',
      whereArgs: [questionId, userId],
    );
  }

  Future<int> deleteScore(String scoreId, String userId) async {
    Database db = await database;
    // Delete score with userId
    return await db.delete(
      tableScores,
      where: '$columnId = ? AND $columnUserId = ?',
      whereArgs: [scoreId, userId],
    );
  }

  Future<int> insertOrUpdateQuiz(Map<String, dynamic> quizData) async {
    Database db = await database;
    return await db.insert(tableQuizzes, quizData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getQuizData() async {
    Database db = await database;
    return await db.query(tableQuizzes);
  }
}
