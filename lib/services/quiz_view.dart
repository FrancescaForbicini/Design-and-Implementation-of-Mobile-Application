library quiz_view;

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';

class QuizView extends StatefulWidget {
  /// Boolean to show the correct answer after the quiz is answered
  final bool showCorrect;

  /// The question
  final String question;

  /// The questonTag (question number or id)
  final String? questionTag;

  /// Color of question font
  final Color questionColor;

  /// Background color
  final Color backgroundColor;

  /// Image if any
  final Widget image;

  /// Width of the quiz view
  final double width;

  /// Height of the quiz view
  final double height;

  /// The right answer
  final String rightAnswer;

  /// The wrong answers
  final List<String> wrongAnswers;

  /// Question Tag background color
  final Color tagBackgroundColor;

  /// Question Tag font color
  final Color tagColor;

  /// Answer font color
  final Color answerColor;

  /// Answer background color
  final Color answerBackgroundColor;

  /// This function is executed if the answer is right
  final void Function() onRightAnswer;

  /// This function is executed if the answer is wrong
  final void Function() onWrongAnswer;

  QuizView(
      {this.showCorrect = true,
      this.questionTag,
      required this.question,
      this.questionColor = Colors.black,
      this.backgroundColor = Colors.white,
      required this.image,
      required this.height,
      required this.width,
      required this.rightAnswer,
      required this.wrongAnswers,
      this.tagColor = Colors.black,
      this.tagBackgroundColor = Colors.white,
      this.answerColor = Colors.black,
      this.answerBackgroundColor = Colors.white,
      required this.onRightAnswer,
      required this.onWrongAnswer});

  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  _QuizViewState();

  bool isTapped = false;
  static final Random _random = Random();
  late int answerIndex;

  @override
  Widget build(BuildContext context) {
    print("Height in quiz_view: ${widget.height}");
    print("Width in quiz_view: ${widget.width}");

    if (!isTapped) {
      answerIndex = _random.nextInt(widget.wrongAnswers.length + 1);
    }

    List<Widget> answerColumn = [];

    for (String i in widget.wrongAnswers) {
      answerColumn.add(Container(
        height: widget.height > widget.width ? widget.height * 0.15 : widget.height * 0.3,
        width: widget.height > widget.width ? widget.width : widget.width * 0.45,
        padding: EdgeInsets.all(15),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => isTapped ? Colors.red : widget.answerBackgroundColor),
            padding: MaterialStateProperty.resolveWith(
                (states) => EdgeInsets.fromLTRB(20, 10, 20, 10)),
            shape:
                MaterialStateProperty.resolveWith((states) => StadiumBorder()),
            textStyle: MaterialStateProperty.resolveWith(
                (states) => TextStyle(color: Colors.white)),
          ),
          child: Center(
            child: AutoSizeText(
              i,
              style: TextStyle(
                  color: widget.answerColor,
                  fontSize: widget.width > widget.height
                      ? widget.width / 25
                      : widget.height / 25
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          onPressed: () {
            if (!isTapped) {
              widget.onWrongAnswer();
              if (widget.showCorrect) {
                setState(() {
                  isTapped = !isTapped;
                });
              }
            }
          },
        ),
      ));
    }
    answerColumn.insert(
        answerIndex,
        Container(
          height: widget.height > widget.width ? widget.height * 0.15 : widget.height * 0.3,
          width: widget.height > widget.width ? widget.width : widget.width * 0.45,
          //width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) =>
                  isTapped ? Colors.green : widget.answerBackgroundColor),
              padding: MaterialStateProperty.resolveWith(
                  (states) => EdgeInsets.fromLTRB(20, 10, 20, 10)),
              shape: MaterialStateProperty.resolveWith(
                  (states) => StadiumBorder()),
              textStyle: MaterialStateProperty.resolveWith(
                  (states) => TextStyle(color: Colors.white)),
            ),
            child: Center(
              child: AutoSizeText(
                widget.rightAnswer,
                style: TextStyle(
                    color: widget.answerColor,
                    fontSize: widget.width > widget.height
                        ? widget.width / 25
                        : widget.height / 25
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onPressed: () {
              if (!isTapped) {
                widget.onRightAnswer();
                if (widget.showCorrect) {
                  setState(() {
                    isTapped = !isTapped;
                  });
                }
              }
            },
          ),
        ));

    late var answersWidget;

    if(widget.height > widget.width){
      answersWidget = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: answerColumn
      );
    }
    else{
      answersWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              answerColumn[0],
              answerColumn[1],
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              answerColumn[2],
              answerColumn[3],
            ],
          )
        ],
      );
    }

    return Container(
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(
                widget.height > widget.width
                    ? widget.height / 20
                    : widget.width / 20)),
            border: Border.all(
                color: Colors.black, width: 1.5, style: BorderStyle.solid)),
        width: widget.width,
        height: widget.height,
        child: widget.questionTag != null
            ? Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: widget.tagBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          widget.height > widget.width
                              ? widget.height / 20
                              : widget.width / 20),
                      bottomRight: Radius.circular(
                          widget.height > widget.width
                              ? widget.height / 20
                              : widget.width / 20),
                    )),
                child: AutoSizeText(
                  widget.questionTag!,
                  style: TextStyle(
                      color: widget.tagColor,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.width > widget.height
                          ? widget.width / 20
                          : widget.height / 20),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0,
                  widget.width > widget.height
                      ? widget.width / 10
                      : widget.height / 10,
                  0,
                  0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.image != null
                      ? [
                    Container(
                        height: widget.height * 0.2,
                        width: widget.width,
                        padding: EdgeInsets.all(20),
                        child: AutoSizeText(
                          widget.question,
                          style: TextStyle(
                              color: widget.questionColor,
                              fontWeight: FontWeight.bold,
                              fontSize: widget.width > widget.height
                                  ? widget.width / 20
                                  : widget.height / 20
                          ),
                          //overflow: TextOverflow.ellipsis,
                        )
/*                                  RichText(
                                      text: TextSpan(
                                    text:
                                  )),*/
                    ),
                    widget.image,
                    answersWidget
                  ]
                      : [
                    Container(
                        height: widget.height * 0.2,
                        width: widget.width,
                        padding: EdgeInsets.all(20),
                        child: AutoSizeText(
                          widget.question,
                          style: TextStyle(
                              color: widget.questionColor,
                              fontWeight: FontWeight.bold,
                              fontSize: widget.width > widget.height
                                  ? widget.width / 20
                                  : widget.height / 20
                          ),
                          //overflow: TextOverflow.ellipsis,
                        )
                    ),
                    answersWidget
                  ],
                ),
              ),
            ),
          ],
        )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.image != null
                      ? [
                          Container(
                            height: widget.height * 0.2,
                            width: widget.width,
                            padding: EdgeInsets.all(15),
                            child: AutoSizeText(
                              widget.question,
                              style: TextStyle(
                                  color: widget.questionColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.width > widget.height
                                      ? widget.width / 20
                                      : widget.height / 20
                              ),
                              //overflow: TextOverflow.ellipsis,
                            )
                          ),
                          widget.image,
                          answersWidget
                        ]
                      : [
                          Container(
                            height: widget.height * 0.2,
                            width: widget.width,
                            padding: EdgeInsets.all(20),
                            child: AutoSizeText(
                              widget.question,
                              style: TextStyle(
                                  color: widget.questionColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.width > widget.height
                                      ? widget.width / 20
                                      : widget.height / 20
                              ),
                              //overflow: TextOverflow.ellipsis,
                            )
                          ),
                          answersWidget
                        ],
                ),
              ));
  }
}
