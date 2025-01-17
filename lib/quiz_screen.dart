import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question_screen.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final response =
        await http.get(Uri.parse('https://api.jsonserve.com/Uw5CrX'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _questions =
            List<Map<String, dynamic>>.from(jsonData['questions'] ?? []);
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void _nextQuestion(bool isCorrect) {
    if (isCorrect) {
      _score += 10;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: _score),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
            title: Text(
          'Quiz App',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        body: _questions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : QuestionScreen(
                question: _questions[_currentQuestionIndex],
                onNextQuestion: _nextQuestion,
              ),
      ),
    );
  }
}
