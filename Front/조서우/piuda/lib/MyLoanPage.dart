import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'main.dart';

class MyLoanPage extends StatefulWidget {
  const MyLoanPage({super.key});

  @override
  State<MyLoanPage> createState() => _MyLoanPageState();
}

class _MyLoanPageState extends State<MyLoanPage> {
  bool showFirstContent = true;


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
          '나의 대출 현황',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showFirstContent = true;
                    });
                  },
                  child: Text('대출현황'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showFirstContent = false;
                    });
                  },
                  child: Text('대출내역'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            showFirstContent
                ? FirstContent()
                : SecondContent(),

          ],
        ),
      ),
    );
  }
}





class FirstContent extends StatefulWidget {
  @override
  _FirstContentState createState() => _FirstContentState();
}

class _FirstContentState extends State<FirstContent> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.blue,
      child: Column(
        children: [
          Container(
            height: 170.0,
            width: 650.0,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(3.0),
              border: Border.all(
                color: Colors.grey, // 테두리 색상
                width: 1, // 테두리 두께
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Image.asset(
                    'assets/images/나미야.jpg', // 사진 경로
                    fit: BoxFit.cover, // 사진의 크기 조절 방식
                  ),
                ),
                Container(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '제목 ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey.shade600, // 첫 번째 텍스트의 글자색
                          ),
                        ),
                        TextSpan(
                          text: '나미야 잡화점의 기적',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey.shade900, // 두 번째 텍스트의 글자색
                          ),
                        ),
                        TextSpan(text: '\n'),
                        TextSpan(
                          text: '도서관 ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                          ),
                        ),
                        TextSpan(
                          text: '성동구립도서관',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black, // 네 번째 텍스트의 글자색
                          ),
                        ),
                        TextSpan(text: '\n'),
                        TextSpan(
                          text: '대출일 ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                          ),
                        ),
                        TextSpan(
                          text: 'YYYY-MM-DD',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black, // 네 번째 텍스트의 글자색
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 110),
                  padding: EdgeInsets.all(3.5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // 테두리 색상
                      width: 1.0, // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(11.0), // 테두리의 모서리를 둥글게 만듭니다.
                  ),
                  child: Text(
                    'D-3',
                    style: TextStyle(
                      color: Colors.cyan.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),


          Container(
            height: 170.0,
            width: 650.0,
            margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3.0),
              border: Border.all(
                color: Colors.grey, // 테두리 색상
                width: 1, // 테두리 두께
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Image.asset(
                    'assets/images/파피용.jpg', // 사진 경로
                    fit: BoxFit.cover, // 사진의 크기 조절 방식
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '제목 ',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey.shade600, 
                              ),
                            ),
                            TextSpan(
                              text: '파피용',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            TextSpan(text: '\n'),
                            TextSpan(
                              text: '도서관 ',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                              ),
                            ),
                            TextSpan(
                              text: '성수도서관',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black, // 네 번째 텍스트의 글자색
                              ),
                            ),
                            TextSpan(text: '\n'),
                            TextSpan(
                              text: '대출일 ',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                              ),
                            ),
                            TextSpan(
                              text: 'YYYY-MM-DD',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black, // 네 번째 텍스트의 글자색
                              ),
                            ),
                            TextSpan(text: '\n'),
                            TextSpan(
                              text: '반납일 ',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                              ),
                            ),
                            TextSpan(
                              text: 'YYYY-MM-DD',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black, // 네 번째 텍스트의 글자색
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // '상태평가' 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookStateReview()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
                            margin: EdgeInsets.only(top: 5, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(
                                color: Colors.grey.shade800, // 테두리 색상
                                width: 1.0, // 테두리 두께
                              ),
                              borderRadius: BorderRadius.circular(2.0), // 테두리의 모서리를 둥글게 만듭니다.
                            ),
                            child: Text(
                              '상태 평가',
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 17.5,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // '상태평가' 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookReview()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(
                                color: Colors.grey.shade800, // 테두리 색상
                                width: 1.0, // 테두리 두께
                              ),
                              borderRadius: BorderRadius.circular(2.0), // 테두리의 모서리를 둥글게 만듭니다.
                            ),
                            child: Text(
                              '도서 리뷰',
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 17.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class SecondContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.green,
      child: Text('This is the Second Content'),
    );
  }
}

class BookStateReview extends StatelessWidget {
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top:20, bottom: 10),
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
            margin: EdgeInsets.only(left: 15, top: 8),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '오염도',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
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
                        size: 15, // 별 크기 조절
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
          Container(
            margin: EdgeInsets.only(left: 15, top: 7),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '손실도',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.0),
                Container(
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
                        size: 15, // 별 크기 조절
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
                  maxLines: 3, // 여러 줄 입력 가능하도록 설정
                  decoration: InputDecoration(
                    hintText: '의견을 입력하세요...',
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


class BookReview extends StatelessWidget {
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
          '도서 리뷰',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black, // 글자색 설정
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top:20, bottom: 8),
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
                          color: Colors.grey.shade500, // 첫 번째 텍스트의 글자색
                        ),
                      ),
                      TextSpan(
                        text: '파피용\n',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black, // 두 번째 텍스트의 글자색
                        ),
                      ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
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
                  size: 15, // 별 크기 조절
                );
              },
              onRatingUpdate: (rating) {
                // 별점이 업데이트될 때의 로직을 추가할 수 있습니다.
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
                  maxLines: 7, // 여러 줄 입력 가능하도록 설정
                  decoration: InputDecoration(
                    hintText: '의견을 입력하세요...',
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

