import 'package:flutter/material.dart';
import 'package:quiz_app/final_page.dart';
import 'package:quiz_app/question.dart';
import 'dart:async';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int score = 0;
  int questionIndex = 0;
  int lives = 3;
  int totalTime = 120;
  Timer? timer2;
  double progressValue = 1.0;
  List<Question> questions = [
    Question(
      'What is the value of 5 * 3?',
      '15',
      ['8', '12', '15', '18'],
    ),
    Question(
      'Simplify the expression: 3 + 4 * 2 - 5',
      '6',
      ['8', '10', '12', '14'],
    ),
    Question(
      'What is the square root of 64?',
      '8',
      ['5', '6', '7', '8'],
    ),
    Question(
      'What is the value of 10 / 2 - 3 * 4?',
      '5',
      ['3', '5', '7', '9'],
    ),
    Question(
      'What is the value of 2^4?',
      '2',
      ['2', '4', '6', '8'],
    ),
    Question(
      'What is the square of 9?',
      '81',
      ['16', '25', '36', '81'],
    ),
    Question(
      'What is the result of 2^3?',
      '8',
      ['2', '4', '6', '8'],
    ),
    Question(
      'Simplify the expression: 2 + 5 - 3 * 2 + 4',
      '8',
      ['4', '6', '8', '10'],
    ),
    Question(
      'What is the value of 7 * (4 - 2)?',
      '14',
      ['7', '10', '14', '28'],
    ),
    Question(
      'What is the square root of 64?',
      '8',
      ['4', '6', '8', '10'],
    ),
    Question(
      'Simplify the expression: 3^2 + 4 * 2',
      '19',
      ['19', '20', '25', '28'],
    ),
    Question(
      'What is the value of 6 / 2 + 3 * 4?',
      '18',
      ['12', '14', '18', '24'],
    ),
    Question(
      'What is the result of 5^2 - 3^2?',
      '16',
      ['4', '6', '16', '22'],
    ),
    Question(
      'Simplify the expression: 4 + (3 - 1) * 5',
      '14',
      ['10', '14', '16', '20'],
    ),
    Question(
      'What is the value of 9 * (6 - 2) + 3?',
      '39',
      ['33', '39', '45', '51'],
    ),
    Question(
      'What is the square root of 100?',
      '10',
      ['4', '6', '8', '10'],
    ),
    Question(
      'Simplify the expression: 2^4 - 3 * 2 + 5',
      '9',
      ['5', '9', '11', '17'],
    ),
    Question(
      'What is the value of 15 / (3 + 2) - 4?',
      '1',
      ['1', '2', '3', '4'],
    ),
    Question(
      'What is the result of 2^5?',
      '32',
      ['16', '25', '32', '64'],
    ),
    Question(
      'Simplify the expression: 6 + 3 * 4 - 5',
      '13',
      ['13', '14', '15', '16'],
    ),
    Question(
      'What is the value of 8 / (4 - 2)?',
      '4',
      ['2', '4', '6', '8'],
    ),
    Question(
      'What is the square of 12?',
      '144',
      ['64', '100', '121', '144'],
    ),
  ];

  String? selectedOption;
  Timer? timer;
  late Stopwatch stopwatch;
  late String totalTimeSW;
  String elapsedTime = '';
  int secondsRemaining = 5;

  @override
  void initState() {
    super.initState();
    startTimer1();
    startTimer2();
    stopwatch = Stopwatch();
    stopwatch.start();
  }

  void startTimer1() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (secondsRemaining < 1) {
          lives--;
          if (lives <= 0) {
            // No more lives, end the quiz
            t.cancel();
            navigateToFinalPage();
          } else {
            // Reset the time for the next question
            moveToNext();
            secondsRemaining = 5;
          }
        } else {
          secondsRemaining--;
        }
      });
    });
  }

  void moveToNext() {
    resetTimer(); // Reset the timer for the next question
    questionIndex++;
    if (questionIndex == questions.length) {
      // All questions answered, navigate to the final page
      stopwatch.stop();
      navigateToFinalPage();
    } else {
      startTimer1();
    }
  }

  void startTimer2() {
    timer2 = Timer.periodic(Duration(seconds: 1), (timer2) {
      setState(() {
        if (totalTime > 0) {
          totalTime--;
          progressValue = totalTime / 120;
        } else {
          // Time runs out, reduce a life and check if the quiz should end
          timer2.cancel();
          navigateToFinalPage();
        }
      });
    });
  }

  void answerQuestion(String? selectedOption) {
    if (selectedOption == questions[questionIndex].correctAnswer) {
      score += 10; // Increase the score for correct answers
    }
    setState(() {
      questions[questionIndex].selectedOption =
          selectedOption; // Assign the selected option to the current question
      questionIndex++;
      selectedOption = null; // Reset the selected option
      resetTimer(); // Reset the timer for the next question
    });
    if (questionIndex == questions.length) {
      // All questions answered, navigate to the final page
      stopwatch.stop();
      navigateToFinalPage();
    }
  }

  void resetTimer() {
    secondsRemaining = 5;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void navigateToFinalPage() {
    timer2?.cancel();
    totalTimeSW = stopwatch.elapsed.inSeconds.toString();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FinalPage(score: score, totalTime: totalTimeSW),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = questionIndex == questions.length - 1;
    final buttonText = isLastQuestion ? 'Submit' : 'Next';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Quiz Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${questionIndex + 1}/${questions.length}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              questions[questionIndex].questionText,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            ...questions[questionIndex]
                .options
                .map(
                  (option) => RadioListTile(
                    title: Text(option),
                    value: option,
                    groupValue: questions[questionIndex].selectedOption,
                    activeColor: Colors.blueGrey,
                    onChanged: (value) {
                      setState(() {
                        questions[questionIndex].selectedOption =
                            value as String?;
                      });
                    },
                  ),
                )
                .toList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (questions[questionIndex].selectedOption != null) {
                  answerQuestion(questions[questionIndex].selectedOption!);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey), // Change the color here
              ),
              child: Text(buttonText),
            ),
            SizedBox(height: 16),
            Text(
              'Lives: $lives',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: progressValue,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
            ),
            Text(
              'Time remaining: $secondsRemaining seconds',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//commit trial
