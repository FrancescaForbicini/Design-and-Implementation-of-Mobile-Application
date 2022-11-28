import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/answer.dart';
import '../models/question.dart';



List<Question>  FileJson()  {
  Question _question = Question();
  List<Question> _questions = <Question>[];
  Answer answer = Answer();
  answer.text = 'ciao'.toString();
  answer.correct = false;
  Answer answer2 = Answer();
  answer2.text = 'addio'.toString();
  answer2.correct = true;
  final _name = "Rocket";
  final _album = "ANN";
  Future<void> readJson() async{
    String response = await rootBundle.loadString('json/question.json') ;
    final data =  json.decode(response);
    int i = 0;
    while (i != 5) {
      //TODO check the topic and put the right name,album and artist with spotify
      _question.topic = data[i]['topic'].toString();
      _question.name = _name.toString();
      _question.question1 = data[i]['question1'].toString();
      //TODO depends on the topic
      _question.artist_album = _album.toString();
      _question.question2 = data[i]['question2'].toString();
      _question.isLocked = false;
      _question.options = [answer, answer2];
      _questions.insert(i,_question);
      i++;
    }
  }
  readJson();
  return _questions;
}

class QuizGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NewQuiz',
        home:  Scaffold(
          body:  QuizGeneratorStateful(),
        )
    );
  }
}

class QuizGeneratorStateful extends StatefulWidget {


  @override
  _QuizGeneratorState createState() => _QuizGeneratorState();
}


class _QuizGeneratorState extends State<QuizGeneratorStateful> {

  List<Question> _questions = FileJson();

  int _question_number = 1;
  int _question_tot = 5;
  int _score = 0;
  bool _isLocked = false;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage:0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 32,),
          Text("Question $_question_number/${_question_tot}"),
          const Divider(thickness:1, color: Colors.grey),
          Expanded(
            child: PageView.builder(
              itemCount: _questions.length,
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
                final _question = _questions[index];
                return buildQuestion(_question);
            },),
          ),
          _isLocked? buildElevatedButton() : const SizedBox.shrink(),
          const SizedBox(height:20),
        ],

      ),
    );
  }
  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
        onPressed: () {
          if (_question_number < _question_tot) {
            _controller.nextPage(
              duration: const Duration(milliseconds:250),
              curve: Curves.easeInExpo,
            );
            setState(() {
              _question_number++;
              _isLocked = false;
            });
          }
          else{
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(score: _score),
                ),);
          }
        },
        child: Text(
            _question_number < _question_tot ? 'NextPage': 'See Results'
        )
    );
  }
  Column buildQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question1,
          style:const TextStyle(fontSize: 25),
        ),
        const SizedBox(height: 32,),
        Expanded(
            child: OptionsWidget(
              question:question,
              onClickedOption: (option){
                if (question.isLocked)
                  return;
                else
                  setState(() {
                    question.isLocked = true;
                    question.selectedOption = option;
                  });
                _isLocked = question.isLocked;
                if (question.selectedOption!.correct)
                  _score++;
              },
            )
        )
      ],
    );
  }
}

class OptionsWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<Answer> onClickedOption;

  const OptionsWidget(
      {Key? key, required this.question, required this.onClickedOption,})
      : super (key: key);

  @override
  Widget build(BuildContext context) =>
      SingleChildScrollView(
        child: Column(
          children: question.options.map((option) => buildOption(context,option)).toList()
        ),
      );


  Widget buildOption(BuildContext context, Answer option) {
    final color = getColorForOption(option, question);
    return GestureDetector(
        onTap: () => onClickedOption(option),
        child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option.text,
                  style: const TextStyle(fontSize: 20),
                ),
                getIconForOption(option, question)
              ],
            )
        )
    );
  }

  Color getColorForOption(Answer option, Question question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.correct ? Colors.green : Colors.red;
      }
      else if (option.correct) {
        return Colors.green;
      }
    }
    return Colors.grey.shade300;
  }

  Widget getIconForOption(Answer option, Question question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.correct ?
        const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red);
      }
      else if (option.correct) {
        return Icon(Icons.check_circle, color: Colors.green,);
      }
    }
    return const SizedBox.shrink();
  }
}

class ResultPage extends StatelessWidget{
  final int score;
  const ResultPage({Key?key, required this.score}): super (key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Text('You got $score'),
      ),
    );
  }
}