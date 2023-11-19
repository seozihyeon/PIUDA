import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'LoginPage.dart';
import 'ReadingLogPage.dart';
import 'package:webview_flutter/webview_flutter.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
//메인 컬러들
const Color lavender = Color.fromRGBO(154, 132, 188, 1.0);
const Color ourpink = Color.fromRGBO(218, 118, 172, 1.0);
const Color ourblue = Color.fromRGBO(108, 155, 210, 1.0);
const Color ourred = Color.fromRGBO(234, 83, 93, 1.0); // #ea535d 색상
const Color ouryellow = Color.fromRGBO(248, 181, 0, 1.0); // #f8b500 색상
const Color ourgreen = Color.fromRGBO(170, 206, 55, 1.0); // #aace37 색상
const Color ourmint = Color.fromRGBO(101, 191, 161, 1.0); // #65bfa1 색상

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
                color: lavender, // 아이콘 색상 설정
              ),
            ),
          ),
        ],
      ),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: ourmint, // 테두리 색상
                  width: 2.0, // 테두리 두께
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.search, color: ourmint),
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
                color: ourmint, // 테두리 색상
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
                    color: ourmint,
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
                              Icons.storage,
                              color: ourblue,
                              size: 48.0,
                            ),
                            Text(
                                '대출\n현황',
                                style: TextStyle(
                                    color: ourblue,
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
                              color: ourpink,
                              size: 48.0,
                            ),
                            Text(
                                '관심\n도서',
                                style: TextStyle(
                                    color: ourpink,
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
                              Icons.timeline,
                              color: ouryellow,
                              size: 48.0,
                            ),
                            Text(
                                '독서\n로그',
                                style: TextStyle(
                                    color: ouryellow,
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
                      _launchURL('https://www.sdlib.or.kr/main/');
                    },
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 가로 중앙 정렬 추가
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance,
                              color: ourgreen,
                              size: 48.0,
                            ),
                            Text(
                                '홈페\n이지',
                                style: TextStyle(
                                    color: ourgreen,
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
          // 공지사항 창
          GestureDetector(
            child: Container(
              width: double.infinity,
              color: Colors.blueGrey.shade100,
              padding: EdgeInsets.all(9.0),
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '휴관일 안내',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCircleDay('6'),
                          SizedBox(width: 5.0),
                          _buildCircleDay('13'),
                          SizedBox(width: 5.0),
                          _buildCircleDay('20'),
                          SizedBox(width: 5.0),
                          _buildCircleDay('27'),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '2023. 11',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),






          // GestureDetector(
          //   onTap: () {
          //     // 공지사항 웹 페이지로 이동
          //     _launchURL(
          //         'https://www.sdlib.or.kr/SD/contents.do?a_num=25663758'); // 원하는 웹사이트 주소로 변경
          //   },
          //   child: Container(
          //     width: double.infinity,
          //     height: 80,
          //     color: Colors.blueGrey.shade100,
          //     padding: EdgeInsets.all(9.0),
          //     margin:
          //     EdgeInsets.only(top: 5, bottom: 5, left: 10.0, right: 10.0),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         RichText(
          //           text: TextSpan(
          //             children: [
          //               WidgetSpan(
          //                 child: Icon(
          //                   Icons.arrow_forward_ios, // 공지사항 아이콘
          //                   color: Colors.black,
          //                   size: 20.0,
          //                 ),
          //               ),
          //               TextSpan(
          //                 text: '공지사항\n',
          //                 style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 20.0,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               TextSpan(
          //                 text: '이곳에 공지사항 내용이 들어갑니다.',
          //                 style: TextStyle(fontSize: 16.0, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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

Widget _buildCircleDay(String day) {
  return Container(
    width: 40.0,
    height: 40.0,
    margin: EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey,
    ),
    child: Center(
      child: Text(
        day,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}