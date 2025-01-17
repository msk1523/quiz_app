import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(bool) onNextQuestion;

  QuestionScreen({required this.question, required this.onNextQuestion});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int? _selectedAnswerIndex;

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  void _submitAnswer() {
    if (_selectedAnswerIndex != null) {
      bool isCorrect = widget.question['options'][_selectedAnswerIndex]
              ['is_correct'] ==
          true;
      widget.onNextQuestion(isCorrect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: Text(
      //   'Quiz App',
      //   style: TextStyle(fontWeight: FontWeight.bold),
      // )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.question['description'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            ...List.generate(widget.question['options'].length, (index) {
              return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: RadioListTile<int>(
                    title: Text(
                        widget.question['options'][index]['description'],
                        style: TextStyle(fontSize: 16)),
                    value: index,
                    groupValue: _selectedAnswerIndex,
                    onChanged: (value) => _selectAnswer(value!),
                  ));
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswerIndex != null ? _submitAnswer : null,
              child: Text('Submit', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
