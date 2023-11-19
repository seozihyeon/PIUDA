import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'LoginPage.dart';
import 'ReadingLogPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/성동문화재단.jpg', // 원하는 이미지의 경로
                width: 24.0, // 이미지의 너비 설정
                height: 24.0, // 이미지의 높이 설정
              ),
            ),
            Center(
              child: Text(
                '성동라이브러리',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black, // 글자색 설정
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // 로그인 창으로 이동하는 로직
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Icon(
                Icons.account_circle,
                color: Colors.cyan.shade800, // 아이콘 색상 설정
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: Colors.cyan.shade700, // 테두리 색상
                  width: 2.0, // 테두리 두께
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.cyan.shade700),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: '검색어를 입력하세요',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onSubmitted: (query) {
                          // 검색 결과를 처리하는 로직 추가
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 모바일 회원증 구현
          Container(
            height: 180.0,
            width: 650.0,
            margin: EdgeInsets.only(left: 7.0, right: 7.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.cyan.shade800, // 테두리 색상
                width: 4.0, // 테두리 두께
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    color: Colors.cyan.shade800,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            '이름: 성동이',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            '회원번호: 12345678',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                    child: Image.asset(
                      'assets/images/barcode.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),


          // 4분할 아이콘
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // '나의 대출 현황' 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyLoanPage()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 5, left: 10.0, right: 5.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.grey.shade200],
                        ),
                        borderRadius: BorderRadius.circular(2.0),
                        border: Border.all(
                          color: Colors.grey, // 테두리 색상
                          width: 0.7, // 테두리 두께
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 가로 중앙 정렬 추가
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.business,
                              color: Colors.blue.shade300,
                              size: 48.0,
                            ),
                            Text(
                              '대출\n현황',
                              style: TextStyle(
                                color: Colors.blue.shade300,
                                fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // '나의 관심 도서' 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyInterestBooksPage()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 5, left: 5.0, right: 10.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.grey.shade300],
                        ),
                        borderRadius: BorderRadius.circular(2.0),
                        border: Border.all(
                          color: Colors.grey, // 테두리 색상
                          width: 0.7, // 테두리 두께
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 가로 중앙 정렬 추가
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red.shade300,
                              size: 48.0,
                            ),
                            Text(
                                '관심\n도서',
                                style: TextStyle(
                                    color: Colors.red.shade300,
                                    fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // '독서로그' 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReadingLogPage()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5, left: 10.0, right: 5.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.grey.shade200],
                        ),
                        borderRadius: BorderRadius.circular(2.0),
                        border: Border.all(
                          color: Colors.grey, // 테두리 색상
                          width: 0.7, // 테두리 두께
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 가로 중앙 정렬 추가
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.yellow.shade700,
                              size: 48.0,
                            ),
                            Text(
                                '독서\n로그',
                                style: TextStyle(
                                    color: Colors.yellow.shade700,
                                    fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5, left: 5.0, right: 10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.grey.shade300],
                      ),
                      borderRadius: BorderRadius.circular(2.0),
                      border: Border.all(
                        color: Colors.grey, // 테두리 색상
                        width: 0.7, // 테두리 두께
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.purple.shade100,
                        size: 48.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 공지사항 창
          GestureDetector(
            onTap: () {
              // 공지사항 웹 페이지로 이동
              _launchURL(
                  'https://www.sdlib.or.kr/SD/contents.do?a_num=25663758'); // 원하는 웹사이트 주소로 변경
            },
            child: Container(
              width: double.infinity,
              height: 80,
              color: Colors.blueGrey.shade100,
              padding: EdgeInsets.all(9.0),
              margin:
                  EdgeInsets.only(top: 5, bottom: 5, left: 10.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.arrow_forward_ios, // 공지사항 아이콘
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ),
                        TextSpan(
                          text: '공지사항\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '이곳에 공지사항 내용이 들어갑니다.',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 웹 페이지로 이동하는 함수
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class MyLoanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 대출 현황'),
      ),
      body: Center(
        child: Text('나의 대출 현황이 표시될 곳입니다.'),
      ),
    );
  }
}

class MyInterestBooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 관심 도서'),
      ),
      body: Center(
        child: Text('나의 관심 도서가 표시될 곳입니다.'),
      ),
    );
  }
}


