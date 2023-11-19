import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'LoginPage.dart';
import 'MyLoanPage.dart';
import 'ReadingLogPage.dart';
import 'MyInterestBooksPage.dart';
import 'Agreement.dart';
import 'BookSearch.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

const Color lavender = Color.fromRGBO(154, 132, 188, 1.0);
const Color ourpink = Color.fromRGBO(218, 118, 172, 1.0);
const Color ourblue = Color.fromRGBO(108, 155, 210, 1.0);
const Color ourred = Color.fromRGBO(234, 83, 93, 1.0); // #ea535d 색상
const Color ouryellow = Color.fromRGBO(248, 181, 0, 1.0); // #f8b500 색상
const Color ourgreen = Color.fromRGBO(170, 206, 55, 1.0); // #aace37 색상
const Color ourmint = Color.fromRGBO(101, 191, 161, 1.0); // #65bfa1 색상

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedSearchTarget = '자료명';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
            child: GestureDetector(
              onTap: () {
                // 로그인 창으로 이동하는 로직
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Image.asset('assets/images/유저1.png',),
            ),
          ),
        ],
      ),


      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top:17, left: 10, right: 10, bottom: 5),
              padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: Colors.cyan.shade700, // 테두리 색상
                  width: 2.0, // 테두리 두께
                ),
              ),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedSearchTarget,
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue != null) {
                          _selectedSearchTarget = newValue;
                        }
                      });
                    },
                    items: ['자료명', '저자명']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration.collapsed(
                              hintText: '검색어를 입력하세요',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onSubmitted: (query) {
                              // 검색 결과를 처리하는 로직 추가
                              print('검색 대상: $_selectedSearchTarget, 검색어: $query');
                              // 여기서 검색 결과에 대한 로직을 추가하면 됩니다.
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookSearch()),
                            );
                          },
                          child: Icon(Icons.search, color: Colors.cyan.shade700),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 모바일 회원증 구현
            Row(
              children: [
                Container(margin: EdgeInsets.only(top: 5),
                  height:50, width:40,
                  color: Colors.cyan.shade800,
                  child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white)
                ),
                Container(
                  height: 165.0,
                  width: 330.0,
                  margin: EdgeInsets.only(top:5, bottom:3, left: 0.0, right: 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: Colors.cyan.shade800, // 테두리 색상
                      width: 3.0, // 테두리 두께
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 330,
                          padding: EdgeInsets.only(left: 15, top: 3),
                          color: Colors.cyan.shade800,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '이름 ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white, // 첫 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(
                                  text: '유성동',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white70, // 두 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(text: '\n'),
                                TextSpan(
                                  text: '회원번호 ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white, // 세 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(
                                  text: '12345678',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white70, // 네 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(text: '\n'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 0,
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
                Container(margin: EdgeInsets.only(top: 5),
                  height:50, width:40,
                  color: Colors.cyan.shade800,
                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white)
                ),
              ],
            ),


            //3분할 아이콘
            Container(
              height: 85,
              margin: EdgeInsets.only(top: 13, left: 10, right: 10),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey), bottom: BorderSide(color: Colors.grey))),
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
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // 가로 중앙 정렬 추가
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/대출현황.jpg', scale: 1.3),
                              SizedBox(height: 2),
                              Text(
                                  '대출현황',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
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
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // 가로 중앙 정렬 추가
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/관심.jpg', scale: 1.3),
                              SizedBox(height: 2),
                              Text(
                                  '관심도서',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
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
                        // '독서로그' 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReadingLogPage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // 가로 중앙 정렬 추가
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/로그.jpg', scale: 1.3),
                              SizedBox(height: 2),
                              Text(
                                  '독서로그',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
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





            Row(
              children: [
                SizedBox(width: 10,),
                LibDropdown(),
                GestureDetector(
                  onTap: () {
                    // 공지사항 웹 페이지로 이동
                    _launchURL(
                        'https://www.sdlib.or.kr/SD/contents.do?a_num=25663758'); // 원하는 웹사이트 주소로 변경
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(top: 5, bottom: 5, left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.arrow_forward_ios, // 공지사항 아이콘
                                  color: Colors.grey.shade800,
                                  size: 18.0,
                                ),
                              ),
                              TextSpan(
                                text: '공지사항',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(height:18, child: Text(''),decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2.0)))),
                GestureDetector(
                  onTap: () {
                    // 문화행사 웹 페이지로 이동
                    _launchURL(
                        'https://www.sdlib.or.kr/SD/edusat/list.do'); // 원하는 웹사이트 주소로 변경
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(top: 5, bottom: 5, left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.arrow_forward_ios, // 공지사항 아이콘
                                  color: Colors.grey.shade800,
                                  size: 18.0,
                                ),
                              ),
                              TextSpan(
                                text: '문화행사',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
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

            Container(
                child: Container(
                    padding: EdgeInsets.only(left: 1, right: 1),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Image.asset('assets/images/달력.jpg',
                        fit: BoxFit.cover)
                )
            ),


          ],
        ),
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


class LibDropdown extends StatefulWidget {
  @override
  _LibDropdownState createState() => _LibDropdownState();
}

class _LibDropdownState extends State<LibDropdown> {
  String selectedValue = '성동구립'; // 기본 선택값
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 133.0, // 원하는 너비로 설정
          child: DropdownButton<String>(
            value: selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
            items: <String>['성동구립', '금호', '용답', '무지개', '성수', '청계', '숲속', '스마트', '작은']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0), // 오른쪽 여백 조절
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}





