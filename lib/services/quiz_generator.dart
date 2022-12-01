import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/answer.dart';
import '../models/question.dart';


class QuizGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF101010),
        title: Text("New Quiz",style: new TextStyle(color: Colors.lightGreen,fontSize: 35),),
      ),
      body: QuizGeneratorStateful(),

    );
  }
}

class QuizGeneratorStateful extends StatefulWidget {
  @override
  _QuizGeneratorState createState() => _QuizGeneratorState();
}


class _QuizGeneratorState extends State<QuizGeneratorStateful> {
  List _questions = [];
  //TODO remove answers when we'll use spotify
  Answer answer = Answer();
  Answer answer2 = Answer();
  late String _name;
  late String _album;
  late PageController _controller;
  late int _question_tot;
  int _score = 0;
  int _question_number = 1;
  bool _isLocked = false;
  bool _can_show_button = true;
  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('json/question.json');
    final data = await json.decode(response);
    setState(() {
      _questions = data["questions"];
      answer.text = 'ciao';
      answer.correct = false;
      answer2.text = 'addio';
      answer2.correct = true;
      _question_tot = _questions.length;
      _name = "Rocket";
      _album = "ANN";
      _can_show_button = false;
    });

  }


  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage:0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightGreen,
        padding: const EdgeInsets.all(25),
        child: Column(

            children: [
              !_can_show_button
                  ? const SizedBox.shrink(
              ):
              ElevatedButton(

                onPressed: readJson,
                child: const Text('Start Quiz'),
              ),

              _questions.isNotEmpty
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          const SizedBox(height: 32,),
                          Text("Question $_question_number/${_questions.length}", style: TextStyle(color: Color(0xFF101010), fontSize: 20, fontWeight: FontWeight.bold),),
                          const Divider(thickness:1, color: Colors.grey),
                          Expanded(child: PageView.builder(
                              itemCount: _questions.length,
                              controller: _controller,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final question = Question();
                                question.question1 =
                                    _questions[index]['question1'].toString();
                                question.name =
                                    _name;
                                question.question2 =
                                    _questions[index]['question2'].toString();
                                question.artist_album =
                                    _album;

                                question.options = [answer,answer2];
                                return buildQuestion(question);
                              }
                          )
                          ),
                          _isLocked? buildElevatedButton() : const SizedBox.shrink(),
                          const SizedBox(height:20),
                        ],
                      ),
              ) : Container(),
            ]
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
                builder: (context) => ResultPage(score: _score,total: _question_tot,),
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
  final int total;
  const ResultPage({Key?key, required this.score, required this.total}): super (key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Text('You got $score/$total'),
      ),
    );
  }
}