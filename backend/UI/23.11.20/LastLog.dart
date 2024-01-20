import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:piuda/MyLog.dart';
import 'main.dart';
import 'package:piuda/EditLog.dart';
import 'package:piuda/MyLog.dart';

class LastLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyLog()),
              ModalRoute.withName('/'),
            );
          },
          color: Colors.black,
        ),
        title: Text(
          '2023년 11월 1일',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 8, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/인간실격.png',
                      fit: BoxFit.cover,
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
                              color: Colors.grey.shade500,
                            ),
                          ),
                          TextSpan(
                            text: '인간실격',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(text: '\n'),
                          TextSpan(
                            text: '저자 ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          TextSpan(
                            text: '다자이 오사무',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(text: '\n'),
                          TextSpan(
                            text: '출판사 ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          TextSpan(
                            text: '민음사',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(text: '\n'),
                          TextSpan(
                            text: '만족도 ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
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
                        ignoreGestures: true, // 사용자 입력 무시
                        itemBuilder: (context, _) {
                          return Icon(
                            Icons.star,
                            color: Colors.amber.shade400,
                            size: 7,
                          );
                        },
                        onRatingUpdate: (rating) {},
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
                  maxLines: 2,
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '부끄럼 많은 생애를 보냈습니다.',
                    hintStyle: TextStyle(color: Colors.black),
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
                  maxLines: 6,
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '청춘의 한 시기를 통과 의례처럼 거쳐야 하는 일본 데카당스 문학의 대표작',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditLog()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan.shade800,
            ),
            child: Text('편집'),
          ),
        ],
      ),
    );
  }
}
