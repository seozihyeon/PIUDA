import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:piuda/state_question_widget.dart';

class BookStateReview extends StatefulWidget {
  final String bookTitle;
  final String author;
  final String library;
  final String book_isbn;
  String imageUrl;
  final int loan_id;


  BookStateReview({
    required this.imageUrl,
    required this.bookTitle,
    required this.author,
    required this.library,
    required this.book_isbn,
    required this.loan_id,
  });

  @override
  State<BookStateReview> createState() => _BookStateReviewState();
}

class _BookStateReviewState extends State<BookStateReview> {
  final TextEditingController lossScoreController = TextEditingController();
  final TextEditingController taintScoreController = TextEditingController();
  final TextEditingController conditionOpController = TextEditingController();
  double lossScore = 3.0; // 초기값은 3.0으로 설정
  double taintScore = 3.0;

  static Future<String> fetchBookCover(String bookIsbn) async {
    final String clientId = 'uFwwNh4yYFgq3WtAYl6S';
    final String clientSecret = 'WElJXwZDhV';

    print('API 요청 시작');

    try {
      final response = await http.get(
        Uri.parse('https://openapi.naver.com/v1/search/book_adv.json?d_isbn=$bookIsbn'),
        headers: {
          'X-Naver-Client-Id': clientId,
          'X-Naver-Client-Secret': clientSecret,
        },
      );

      print('API 응답 받음');

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        // 확인을 위해 표지 이미지 URL 출력
        print('이미지 URL: ${decodedData['items'][0]['image']}');

        return decodedData['items'][0]['image'] ?? '';
      } else {
        print('Failed to fetch book cover. Status code: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('fetchBookCover 함수에서 오류 발생: $e');
      return '';
    }
  }
  Future<void> fetchAndSetImageUrl() async {
    widget.imageUrl = await fetchBookCover(widget.book_isbn);
  }

  Future<void> saveReviewConditionToServer(
      int yourLossScore,
      int yourTaintScore,
      String yourConditionOp,
      ) async {
    final String apiUrl = 'http://10.0.2.2:8080/reviewCondition/write';

    final Map<String, dynamic> requestData = {
      'loan_id': widget.loan_id,
      'loss_score': yourLossScore,
      'taint_score': yourTaintScore,
      'condition_op': yourConditionOp,
    };

    try {
      print('서버로 데이터 전송 중: $requestData');
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('loanId: ${widget.loan_id}');

      if (response.statusCode == 200) {
        print('리뷰 조건이 성공적으로 생성되었습니다!');
      } else {
        print('리뷰 조건 생성에 실패했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('HTTP 요청 중 오류 발생: $e');
    }
  }

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
          '서적 상태 평가',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black, // 글자색 설정
          ),
        ),
        backgroundColor: Colors.white,
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top:20, bottom: 10),
                child: Stack(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(widget.imageUrl, // 사진 경로
                            fit: BoxFit.cover, // 사진의 크기 조절 방식
                            height: 200.0,
                          ),
                        ],
                      ),
                    ),
                    Positioned(child: WhatIsCondition(), top: 0, right: 0,)
                  ],
                )
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 8),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '오염도',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: QuestionMarkButton())
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    child: RatingBar.builder(
                      initialRating: taintScore,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, _) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber.shade400,
                          size: 15, // 별 크기 조절
                        );
                      },
                      onRatingUpdate: (rating) {
                        // 사용자가 선택한 별점을 taintScore 변수에 저장
                        setState(() {
                          taintScore = rating;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 7),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '손실도',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: QuestionMarkButton2())
                    ],
                  ),
                  SizedBox(height: 6.0),
                  Container(
                    child: RatingBar.builder(
                      initialRating: lossScore,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, _) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber.shade400,
                          size: 15, // 별 크기 조절
                        );
                      },
                      onRatingUpdate: (rating) {
                        setState(() {
                          lossScore = rating;
                        });
                      },
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
                    '기타의견',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  TextField(
                    controller: conditionOpController,
                    maxLines: 3, // 여러 줄 입력 가능하도록 설정
                    decoration: InputDecoration(
                        hintText: '의견을 입력하세요...',
                        border: OutlineInputBorder(),
                        // 외곽선 추가
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan.shade700),)
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final int yourLossScore = lossScore.toInt();
                final int yourTaintScore = taintScore.toInt();
                final String yourConditionOp = conditionOpController.text;

                await saveReviewConditionToServer(
                  yourLossScore,
                  yourTaintScore,
                  yourConditionOp,
                );
                _showSnackBar(context, "상태평가가 성공적으로 작성되었습니다");
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan.shade800, // 버튼의 배경색을 파란색으로 설정
              ),
              child: Text('등록', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}


class BookCondition {
  final int loanId;
  final int lossScore;
  final int taintScore;
  final String? conditionOp;

  BookCondition({
    required this.loanId,
    required this.lossScore,
    required this.taintScore,
    this.conditionOp,
  });

  Map<String, dynamic> toJson() {
    return {
      'loan_id': loanId,
      'loss_score': lossScore,
      'taint_score': taintScore,
      'condition_op': conditionOp,
    };
  }
}