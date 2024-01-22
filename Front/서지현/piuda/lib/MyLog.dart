import 'package:flutter/material.dart';
import 'package:piuda/LastLog.dart';
import 'package:piuda/ReadingLogPage.dart';
import 'package:piuda/LogList.dart';

class MyLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: Text(
          '나의 독서 로그',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: '이번 달은 ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '3',
                    style: TextStyle(
                      color: Colors.cyan.shade800,
                    ),
                  ),
                  TextSpan(
                    text: '권 읽었습니다.',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 0.5),
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom:0.0),
                  child: Image.asset('assets/images/차트.png'),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LogList()),
                          );
                        },
                        child: Icon(Icons.dehaze),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.zero,
                          primary: Colors.grey[350],
                          onPrimary: Colors.black,
                          elevation: 0,
                        ),
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 57.0), // 왼쪽 여백 추가
                        child: Text(
                          '나의 독서 기록장',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center, // 텍스트 가운데 정렬
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_left),
                    SizedBox(width: 4),
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      child: Image.asset('assets/images/돈의심리학.png'),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LastLog()),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 150,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                    ),
                    child: Image.asset('assets/images/인간실격.png'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      child: Image.asset('assets/images/챗gpt.png'),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ],
            ),
          ),
          // ... (다른 위젯들)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReadingLogPage()),
          );
        },
        child: Icon(Icons.create),
        backgroundColor: Colors.cyan.shade800,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
