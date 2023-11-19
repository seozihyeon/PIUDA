import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'main.dart';

class ReadingLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로가기 동작
            Navigator.pop(context);
          },
          color: Colors.black, // 뒤로가기 버튼의 색상
        ),
        title: Text(
          '나의 독서 기록장',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black, // 글자색 설정
          ),
        ),
        backgroundColor: Colors.white,
      ),



      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top:20, bottom: 8, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/파피용.jpg', // 사진 경로
                      fit: BoxFit.cover, // 사진의 크기 조절 방식
                      height: 200.0,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '제목 ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500, // 첫 번째 텍스트의 글자색
                            ),
                          ),
                          TextSpan(
                            text: '파피용',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black, // 두 번째 텍스트의 글자색
                            ),
                          ),
                          TextSpan(text: '\n'),
                          TextSpan(
                            text: '저자 ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500, // 세 번째 텍스트의 글자색
                            ),
                          ),
                          TextSpan(
                            text: '베르나르 베르베르',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black, // 네 번째 텍스트의 글자색
                            ),
                          ),
                          TextSpan(text: '\n'),
                          TextSpan(
                            text: '출판사 ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500, // 세 번째 텍스트의 글자색
                            ),
                          ),
                          TextSpan(
                            text: '열린책들',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black, // 네 번째 텍스트의 글자색
                            ),
                          ),
                          TextSpan(text: '\n'),
                          TextSpan(
                            text: '만족도 ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500, // 세 번째 텍스트의 글자색
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 7),
                      child: RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) {
                          return Icon(
                            Icons.star,
                            color: Colors.amber.shade400,
                            size: 7, // 별 크기 조절
                          );
                        },
                        onRatingUpdate: (rating) {
                          // 별점이 업데이트될 때의 로직을 추가할 수 있습니다.
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '인상 깊은 구절',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                TextField(
                  maxLines: 2, // 여러 줄 입력 가능하도록 설정
                  decoration: InputDecoration(
                    hintText: '인상 깊었던 구절을 기록하세요...',
                    border: OutlineInputBorder(), // 외곽선 추가
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '나의 소감',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                TextField(
                  maxLines: 6, // 여러 줄 입력 가능하도록 설정
                  decoration: InputDecoration(
                    hintText: '생각을 자유롭게 기록하세요...',
                    border: OutlineInputBorder(), // 외곽선 추가
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // '등록' 버튼을 눌렀을 때의 동작 정의
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan.shade800, // 버튼의 배경색을 파란색으로 설정
            ),
            child: Text('등록'),
          ),
        ],
      ),
    );
  }
}