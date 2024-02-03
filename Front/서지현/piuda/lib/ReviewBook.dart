import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

Future<void> sendReviewToServer(int loanId, String reviewText, int reviewScore) async {
  final url = Uri.parse('http://10.0.2.2:8080/api/review/add');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'loan_id': loanId.toString(),
        'review_content': reviewText,
        'review_score': reviewScore.toString(),
      },
    );

    if (response.statusCode != 200) {
      // 서버로부터 오류 응답이 온 경우 예외 발생
      throw Exception('Failed to add review');
    }
  } catch (e) {
    throw Exception('Error sending review: $e');
  }
}


class BookReview extends StatefulWidget {
  final String bookTitle;
  final String bookAuthor;
  final String imageUrl;
  final String bookIsbn;
  final int loanId;

  BookReview({
    required this.bookTitle,
    required this.bookAuthor,
    required this.imageUrl,
    required this.bookIsbn,
    required this.loanId,
  });

  @override
  _BookReviewState createState() => _BookReviewState();
}

class _BookReviewState extends State<BookReview> {
  TextEditingController reviewController = TextEditingController(); // reviewController 정의

  int rating = 3; // rating 변수를 int 형식으로 변경

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
          '도서 리뷰',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    widget.imageUrl, // widget을 사용하여 부모 클래스의 속성에 접근
                    fit: BoxFit.cover,
                    height: 200.0,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
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
                          text: widget.bookTitle + '\n', // widget을 사용하여 부모 클래스의 속성에 접근
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '저자 ',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        TextSpan(
                          text: widget.bookAuthor + '\n', // widget을 사용하여 부모 클래스의 속성에 접근
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: RatingBar.builder(
                initialRating: rating.toDouble(), // rating을 double로 변환
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, _) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber.shade400,
                    size: 15,
                  );
                },
                onRatingUpdate: (newRating) {
                  setState(() {
                    rating = newRating.toInt(); // newRating을 int로 변환
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '리뷰 내용',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  TextField(
                    controller: reviewController,
                    maxLines: 7,
                    decoration: InputDecoration(
                      hintText: '리뷰를 작성하세요...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                String reviewText = reviewController.text;
                int loanId = widget.loanId;

                try {
                  await sendReviewToServer(loanId, reviewText, rating);
                  _showSnackBar(context, "리뷰가 성공적으로 추가되었습니다.");
                  Navigator.pop(context);
                } catch (e) {
                  _showAlertDialog(context, "이미 리뷰를 작성한 책입니다.");
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan.shade800,
              ),
              child: Text('등록', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}