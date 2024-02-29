import 'package:flutter/material.dart';

class QuestionMarkButton extends StatefulWidget {
  @override
  _QuestionMarkButtonState createState() => _QuestionMarkButtonState();
}

class _QuestionMarkButtonState extends State<QuestionMarkButton> {
  bool isShowingText = false;

  void toggleTextVisibility() {
    setState(() {
      isShowingText = !isShowingText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: toggleTextVisibility,
              ),
              SizedBox(width: 8), // 아이콘과 텍스트 사이 간격 조정
              Visibility(
                visible: isShowingText,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '페이지 오염, 표지 오염, 냄새, 색상 변화 등을 고려하여 오염 정도를 평가해주세요.',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                        softWrap: true,
                      ),
                      Text(
                        '[1점: 매우 나쁨, 5점: 매우 좋음]',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class QuestionMarkButton2 extends StatefulWidget {
  @override
  _QuestionMarkButton2State createState() => _QuestionMarkButton2State();
}

class _QuestionMarkButton2State extends State<QuestionMarkButton2> {
  bool isShowingText = false;

  void toggleTextVisibility() {
    setState(() {
      isShowingText = !isShowingText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: toggleTextVisibility,
              ),
              SizedBox(width: 8), // 아이콘과 텍스트 사이 간격 조정
              Visibility(
                visible: isShowingText,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '페이지 찢김, 표지 파손, 내부 내용 손실 등을 고려하여 손상 정도를 평가해주세요.', // 여기에 표시할 텍스트를 넣으세요.
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                        softWrap: true,
                      ),
                      Text(
                        '[1점: 매우 나쁨, 5점: 매우 좋음]',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WhatIsCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('상태평가란?', ),
              content: Text('대출한 도서에 대한 상태를 평가할 수 있습니다. 이제 직접 도서관에 방문하지 않고도 어디에서든 도서의 상태를 확인해보세요! 손상된 책을 발견하면 도서관이 신속하게 조치를 취할 수 있도록 도와주세요. 상태 평가는 반납 후 30일이 지나면 작성할 수 없습니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('닫기', style: TextStyle(color: Colors.cyan.shade800),),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(20),
        shape: CircleBorder(
          side: BorderSide(color: Colors.cyan.shade800, width: 2.0),
        ),
        elevation: 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.question_mark, color: Colors.cyan.shade700), // 물음표 아이콘
          SizedBox(height: 2), // 간격 조절
          Text(
            '상태평가란?',
            style: TextStyle(color: Colors.cyan.shade700, fontSize: 13), // 텍스트 색상 설정
          ), // 텍스트
        ],
      ),
    );
  }
}