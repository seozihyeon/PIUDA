import 'package:flutter/material.dart';
import 'package:piuda/MyLog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'LoginPage.dart';
import 'MyLoanPage.dart';
import 'ReadingLogPage.dart';
import 'MyInterestBooksPage.dart';
import 'Agreement.dart';
import 'BookSearch.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'users.dart';

final Uri _url = Uri.parse('https://www.sdlib.or.kr/main/');


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  final String? username;
  final int? userid;
  final Users? userInfo;


  HomePage({Key? key, this.username, this.userid, this.userInfo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLibrary = '성동구립';
  Map<String, Map<String, String>> libraryUrls = {
    '성동구립': {
      '공지사항': 'https://www.sdlib.or.kr/SD/contents.do?a_num=25663758',
      '문화행사': 'https://www.sdlib.or.kr/SD/edusat/list.do',
    },
    '금호': {
      '공지사항': 'https://www.sdlib.or.kr/KH/contents.do?a_num=20831646',
      '문화행사': 'https://www.sdlib.or.kr/KH/edusat/list.do',
    },
    '용답': {
      '공지사항': 'https://www.sdlib.or.kr/YD/contents.do?a_num=55661714',
      '문화행사': 'https://www.sdlib.or.kr/YD/edusat/list.do',
    },
    '무지개': {
      '공지사항': 'https://www.sdlib.or.kr/RB/contents.do?a_num=48121466',
      '문화행사': 'https://www.sdlib.or.kr/RB/edusat/list.do',
    },
    '성수': {
      '공지사항': 'https://www.sdlib.or.kr/SS/contents.do?a_num=22326537',
      '문화행사': 'https://www.sdlib.or.kr/SS/edusat/list.do',
    },
    '청계': {
      '공지사항': 'https://www.sdlib.or.kr/CG/contents.do?a_num=33672856',
      '문화행사': 'https://www.sdlib.or.kr/CG/edusat/list.do',
    },
    '숲속': {
      '공지사항': 'https://www.sdlib.or.kr/fore/contents.do?a_num=80628730',
      '문화행사': 'https://www.sdlib.or.kr/fore/edusat/list.do',
    },
    '작은': {
      '공지사항': 'https://www.sdlib.or.kr/small/main.do',
      '문화행사': 'https://www.sdlib.or.kr/small/main.do',
    },
  };

  void _onLibraryChanged(String newValue) {
    setState(() {
      selectedLibrary = newValue;
    });
  }

  Future<void> _launchLibraryUrl(String category) async {
    String url = libraryUrls[selectedLibrary]?[category] ?? '';
    if (url.isNotEmpty) {
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
        throw 'Could not launch $url';
      }
    }
  }

  String userStatus = '';
  String _selectedSearchTarget = '자료명';
  final TextEditingController _isbnController = TextEditingController();
  Set<String> selectedOptions = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Scaffold 키 추가

  void _navigateAndSearch() {
    if (_isbnController.text.isEmpty) {
      // 텍스트 필드가 비어있으면 SnackBar 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색어를 입력해주세요')),
      );
    } else {
      // 검색 로직 수행
      print('Selected Search Target: $_selectedSearchTarget');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookSearch(
            iniimageUrl: 'assets/your_default_image.png',
            searchText: _isbnController.text,
            searchOptions: selectedOptions,
            searchTarget: _selectedSearchTarget,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserStatus(); // 앱이 시작될 때 사용자 상태를 가져옴
  }

  Future<String> getUserStatus(int userId) async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:8080/userstatus/$userId'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load user status');
    }
  }

  Future<void> fetchUserStatus() async {
    try {
      String status = await getUserStatus(widget.userid ?? 0);
      setState(() {
        userStatus = status; // 상태를 업데이트하고 다시 렌더링
      });
    } catch (e) {
      print('Error fetching user status: $e');
    }
  }

  Future<void> _logout() async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8080/logout'),
      // 추가적인 헤더 또는 데이터가 필요하다면 여기에 추가
    );

    if (response.statusCode == 200) {
      // 서버에서 로그아웃 성공 응답이 오면 로컬 데이터 클리어
      // 예: 토큰, 사용자 정보 등의 로컬 데이터 삭제
      await _clearLocalData();
      MyApp.isLoggedIn = false;

      // 로그인 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // 로그아웃 실패 시 에러 메시지 출력
      print('Failed to logout. ${response.statusCode}');
    }
  }

  Future<void> _clearLocalData() async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: 'user_token');
  }





  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                _launchUrl();
              },
              child: Icon(Icons.public, color: Colors.cyan.shade800,),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/성동문화재단.jpg',
                    width: 24.0,
                    height: 24.0,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    '성동라이브러리',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Builder(
            builder: (BuildContext innerContext) {
              return IconButton(
                icon: Icon(Icons.account_circle, color: Colors.cyan.shade800,),
                onPressed: () {
                  if (MyApp.isLoggedIn) {
                    Scaffold.of(innerContext).openEndDrawer();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),


      //마이페이지 드로어
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
              ),
              accountName: Text(widget.username ?? 'Guest'),
              accountEmail: Text(widget.userid != null ? widget.userid.toString() : ''),
              decoration: BoxDecoration(
                color: Colors.cyan[800],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.wifi_protected_setup,
                color: Colors.grey[850],
              ),
              title: Text('회원상태: $userStatus'),
              onTap: () {
                print('Home button is clicked!');
              },
            ),
            Divider(thickness: 1,),
            ListTile(
              leading: Icon(
                Icons.question_answer,
                color: Colors.grey[850],
              ),
              title: Text('나의 독서 로그'),
              onTap: () {
                print('Q&A button is clicked!');
              },
              //trailing: Icon(Icons.add),
            ),
            Divider(thickness: 1,),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black, // 로그아웃 버튼 아이콘 색상 변경
              ),
              title: Text('로그아웃'),
              onTap: _logout,
            ),

          ],
        ),
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
                    items: ['자료명', '저자명', '발행처']
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
                            controller: _isbnController,
                          ),
                        ),
                        GestureDetector(
                          onTap: _navigateAndSearch,
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
                    height:50, width: screenSize.width * 0.1,
                    color: Colors.cyan.shade800,
                    child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white)
                ),
                Container(
                  height: 165.0,
                  width: screenSize.width * 0.8,
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
                          width: screenSize.width * 0.8,
                          height: screenSize.height * 0.15,
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
                                  text: widget.username,
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
                                  text: widget.userid.toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white70, // 네 번째 텍스트의 글자색
                                  ),
                                ),
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
                    height:50, width:screenSize.width*0.1,
                    color: Colors.cyan.shade800,
                    child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white)
                ),
              ],
            ),


            //3분할 아이콘
             Container(
              height: 85,
              margin: EdgeInsets.only(top: 13, left: 10, right: 10, bottom:13),
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
                        // '예약내역' 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyLog()),
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
                                  '예약내역',
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
                Spacer(flex: 3), // 좌측 마진
                Expanded(
                  flex: 25, //
                  child: LibDropdown(
                    selectedLibrary: selectedLibrary,
                    onLibraryChanged: _onLibraryChanged,
                    libraryUrls: libraryUrls,
                  ),
                ),
                Expanded(
                  flex: 29, // '공지사항' 버튼을 위한 공간
                  child: GestureDetector(
                    onTap: () => _launchLibraryUrl('공지사항'),
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 5, bottom: 5, left: 10.0, right: 10),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.arrow_forward_ios,
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
                ),
                Container(height: 18, decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2)))),
                Expanded(
                  flex: 29, // '문화행사' 버튼을 위한 공간
                  child: GestureDetector(
                    onTap: () => _launchLibraryUrl('문화행사'),
                    child: Container(
                      height: 50,
                      // width: screenSize.width*0.3, // 이제 필요 없음
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.only(top: 5, bottom: 5, left: 10.0, right: 10.0),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.arrow_forward_ios,
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
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}


class Login {
  final String username;
  final int userIdInt;

  Login(this.username, this.userIdInt, );

  Login.fromJson(Map<String, dynamic> json)
      : username = json['user_name'],
        userIdInt = json['user_id'];

  Map<String, dynamic> toJson() => {
    'user_name': username,
    'user_id': userIdInt,
  };
}

class LibDropdown extends StatefulWidget {
  final String selectedLibrary;
  final Function(String) onLibraryChanged;
  final Map<String, Map<String, String>> libraryUrls;

  LibDropdown({
    Key? key,
    required this.selectedLibrary,
    required this.onLibraryChanged,
    required this.libraryUrls,
  }) : super(key: key);

  @override
  _LibDropdownState createState() => _LibDropdownState();
}

class _LibDropdownState extends State<LibDropdown> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screenWidth*0.25, // 원하는 너비로 설정
          child: DropdownButton<String>(
            value: widget.selectedLibrary,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  widget.onLibraryChanged(newValue);
                });
              }
            },
            items: widget.libraryUrls.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(
                  fontSize: 17,)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}






