import 'package:flutter/material.dart';
import 'package:piuda/MyBookingPage.dart';
import 'package:piuda/MyLog.dart';
import 'package:piuda/Widgets/main_3widget.dart';
import 'package:piuda/Widgets/main_widget.dart';
import 'package:url_launcher/url_launcher.dart';
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
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Widgets/main_widget.dart';
import 'Utils/EventUtils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


final Uri _url = Uri.parse('https://www.sdlib.or.kr/main/');
bool isLoggedIn = false;

void main() {
  initializeDateFormatting().then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  static bool isLoggedIn = false;
  static int? userId;
  static String? userName;
  static String? barcodeImageUrl;
  static String? userStatus;


  static void updateLoginStatus(bool status) {
    isLoggedIn = status;
  }

  Widget build(BuildContext context) {
    Intl.defaultLocale = 'ko_KR';
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'), // 한국어 지원
      ],
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.cyan.shade700,
        ),
          textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.cyan.shade800,
          selectionColor: Colors.cyan.shade100, // 드래그하여 선택한 텍스트의 배경 색상
          selectionHandleColor: Colors.cyan.shade800, // 선택 핸들의 색상
        ),
      ),
      locale: Locale('ko', 'KR'),
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage(
              userInfo: snapshot.data,
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }


  Future<Users?> checkLoginStatus() async {
    final storage = new FlutterSecureStorage();
    String? userInfo = await storage.read(key: 'login');
    if (userInfo != null) {
      return Users.fromJson(json.decode(userInfo));
    }
    return null;
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

  bool isLoggedIn = false;
  int? userId;
  String? userName;
  late GlobalKey<MyPageViewState> myPageViewKey;
  late MyPageView myPageView;

  @override
  void initState() {
    super.initState();

    myPageViewKey = GlobalKey<MyPageViewState>();

    myPageView = MyPageView(
      key: myPageViewKey,
      onLibraryChanged: (newLibrary) {
        print("도서관이 변경되었습니다: $newLibrary");
        // 필요한 추가 동작을 여기에 구현합니다.
      },
    );

    _selectedDay = ValueNotifier(DateTime.now());
    _focusedDay = ValueNotifier(DateTime.now());
    fetchEvents(selectedLibrary);
    _selectedEvents = _getEventsForDay(_selectedDay.value);

    //myPageView.callFetchMainNewBooks(selectedLibrary);
  }

  // 로그인 상태를 업데이트하는 함수
  void updateLoginStatus(Map<String, dynamic> loginResult) {
    setState(() {
      isLoggedIn = loginResult['isLoggedIn'];
      userName = loginResult['username'];
      userId = loginResult['userId'];

    });
  }

  void _checkLoginAndNavigate(BuildContext context, Widget nextPage) {
    if (!MyApp.isLoggedIn) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.only(right: 30, left:30, top:40),
            content: Text('로그인 후 이용 가능한 서비스입니다.',
              style: TextStyle(fontSize: 15.0),),
            actions: <Widget>[
              TextButton(
                child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                },
              ),
              TextButton(
                child: Text('로그인하러 가기', style: TextStyle(color: Colors.cyan.shade800)),
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  ).then((result) {
                    // 로그인 페이지에서 반환된 데이터 처리
                    if (result != null && result['isLoggedIn']) {
                      setState(() {
                        MyApp.isLoggedIn = result['isLoggedIn'];
                        MyApp.userName = result['username'];
                        MyApp.userId = result['userId'];
                        // 필요한 경우 여기에서 추가 UI 업데이트 로직을 구현합니다.
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage)); // 로그인 성공 후 다음 페이지로 이동
                    }
                  });
                },
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage)); // 이미 로그인된 경우 다음 페이지로 이동
    }
  }


  late final ValueNotifier<DateTime> _selectedDay;
  late final ValueNotifier<DateTime> _focusedDay;
  String selectedLibrary = '성동구립도서관';
  Map<String, Map<String, String>> libraryUrls = {
    '성동구립도서관': {
      '공지사항': 'https://www.sdlib.or.kr/SD/contents.do?a_num=25663758',
      '문화행사': 'https://www.sdlib.or.kr/SD/edusat/list.do',
    },
    '금호도서관': {
      '공지사항': 'https://www.sdlib.or.kr/KH/contents.do?a_num=20831646',
      '문화행사': 'https://www.sdlib.or.kr/KH/edusat/list.do',
    },
    '용답도서관': {
      '공지사항': 'https://www.sdlib.or.kr/YD/contents.do?a_num=55661714',
      '문화행사': 'https://www.sdlib.or.kr/YD/edusat/list.do',
    },
    '무지개도서관': {
      '공지사항': 'https://www.sdlib.or.kr/RB/contents.do?a_num=48121466',
      '문화행사': 'https://www.sdlib.or.kr/RB/edusat/list.do',
    },
    '성수도서관': {
      '공지사항': 'https://www.sdlib.or.kr/SS/contents.do?a_num=22326537',
      '문화행사': 'https://www.sdlib.or.kr/SS/edusat/list.do',
    },
    '청계도서관': {
      '공지사항': 'https://www.sdlib.or.kr/CG/contents.do?a_num=33672856',
      '문화행사': 'https://www.sdlib.or.kr/CG/edusat/list.do',
    },
    '숲속도서관': {
      '공지사항': 'https://www.sdlib.or.kr/fore/contents.do?a_num=80628730',
      '문화행사': 'https://www.sdlib.or.kr/fore/edusat/list.do',
    },
    '작은도서관': {
      '공지사항': 'https://www.sdlib.or.kr/small/main.do',
      '문화행사': 'https://www.sdlib.or.kr/small/main.do',
    },
  };
  Map<DateTime, List<Event>> _events = {};
  List<Event> _selectedEvents = [];

  Future<void> fetchEvents(String libraryName) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/events/$libraryName');
    print("Requesting events from: $url");

    final response = await http.get(url);
    final decodedBody = utf8.decode(response.bodyBytes);
    final json = jsonDecode(decodedBody);

    print("Response status: ${response.statusCode}");
    //print("Response body: $decodedBody");

    if (response.statusCode == 200) {
      Iterable jsonList = json as Iterable; // jsonDecode의 결과를 Iterable로 캐스팅
      List<Event> events = jsonList.map((event) => Event.fromJson(event)).toList();

      //print("Fetched events: $events"); // 이벤트 로깅

      setState(() {
        _events = groupEventsByDate(events);
        //print("Updated events: $_events");
      });
    } else {
      throw Exception('Failed to load events');
    }
  }



  Map<DateTime, List<Event>> groupEventsByDate(List<Event> events) {
    Map<DateTime, List<Event>> data = {};
    for (var event in events) {
      // 시간 정보를 무시하고 날짜만 사용
      final date = DateTime(event.date.year, event.date.month, event.date.day);
      if (data[date] == null) {
        data[date] = [];
      }
      data[date]!.add(event);
    }
    return data;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색어를 입력해주세요')),
      );
    } else {
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




  void _onLibraryChanged(String newValue) {
    setState(() {
      selectedLibrary = newValue;
      if (myPageViewKey.currentState != null) {
        myPageViewKey.currentState!.updateLibrary(newValue);
      }
    });
    fetchEvents(newValue);
  }

  @override
  void dispose() {
    _selectedDay.dispose();
    _focusedDay.dispose();
    super.dispose();
  }


  Future<void> _logout() async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8080/logout'),
    );

    if (response.statusCode == 200) {
      await _clearLocalData();
      MyApp.isLoggedIn = false;
      MyApp.userId = null;  // 사용자 ID 초기화

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

  List<Event> _getEventsForDay(DateTime day) {
    // 시간 정보를 제거하고 날짜만 비교합니다.
    DateTime dateKey = DateTime(day.year, day.month, day.day);
    return _events[dateKey] ?? [];
  }

  // 날짜가 선택될 때 호출되는 콜백
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay.value = selectedDay;
      _focusedDay.value = focusedDay; // 현재 달력에 표시되는 달을 업데이트
      _selectedEvents = _getEventsForDay(selectedDay);
    });
  }

  Widget _buildTableCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
            color: Color(0xFFF0F0F0), // 테두리 색상
            width: 1.5
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(2, 5), // 수평과 수직 방향
          ),
        ],
      ),
      child: TableCalendar(
        onDaySelected: _onDaySelected,
        focusedDay: _focusedDay.value,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            bool isHoliday = events.any((event) => (event as Event).name == '휴관일');
            bool hasOtherEvents = events.any((event) => (event as Event).name != '휴관일');

            if (isToday(date)) {
              return Positioned(
                bottom: 1,
                child: Center(
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red[400],
                    ),
                  ),
                ),
              );
            } else if (hasOtherEvents || (isHoliday && events.length > 1)) {
              // 휴관일이지만 다른 이벤트도 있는 경우 또는 다른 이벤트가 있는 경우
              return Positioned(
                bottom: 1,
                child: Center(
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                ),
              );
            } else if (isHoliday) {
              // 휴관일인 경우만
              return Positioned(
                bottom: 1,
                child: Center(
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }
            return null;
          },
          // ... 나머지 코드
        ),


        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          // 여기에서 셀의 높이를 조정
          cellMargin: EdgeInsets.all(0),
          cellPadding: EdgeInsets.all(0),
          todayTextStyle: TextStyle(fontSize: 14),
          defaultTextStyle: TextStyle(fontSize: 14),
        ),
        headerStyle: HeaderStyle(
          // 헤더 높이 조정
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white,),
          leftChevronIcon: Icon(Icons.chevron_left, size: 24, color: Colors.white),
          rightChevronIcon: Icon(Icons.chevron_right, size: 24, color: Colors.white),
          decoration: BoxDecoration(
            color: Color(0xFF69C1D7),
            //border: Border(bottom: BorderSide(color: Colors.cyan.shade800)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          headerPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0),
          headerMargin: EdgeInsets.only(bottom: 12),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          // 요일 행의 스타일 조정
          weekdayStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          weekendStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        eventLoader: (day) {
          // 시간 정보를 무시하고 날짜만 사용
          DateTime dateKey = DateTime(day.year, day.month, day.day);
          //print("Events for $dateKey: ${_events[dateKey]}");
          return _events[dateKey] ?? [];
        },
      ),
    );
  }


  Widget _buildEventList() {
    var screenWidth = MediaQuery.of(context).size.width;
    var selectedDateString = DateFormat('dd').format(_selectedDay.value); // 선택된 날짜 문자열

    return Container(
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_selectedEvents.isNotEmpty)
            Column(
              children: _selectedEvents.map((event) {
                return Container(
                  alignment: Alignment.center,
                  width: screenWidth * 0.9,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(2, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xFF69C1D7),
                            shape: BoxShape.circle
                        ),
                        child: Text(
                          "$selectedDateString일 ", // 선택된 날짜 표시
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Text(
                          event.name,
                          style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }






  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
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
              onTap: () {_launchUrl();},
              child: Icon(Icons.public, color: Colors.cyan.shade900,),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/성동문화재단.jpg', width: 24.0, height: 24.0, ),
                  SizedBox(width: 5,),
                  Text('성동라이브러리', textAlign: TextAlign.center, style: TextStyle(color: Colors.black,),
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
                icon: Icon(Icons.account_circle, color: Colors.cyan.shade900,),
                onPressed: () {
                  if (MyApp.isLoggedIn) {
                    Scaffold.of(innerContext).openEndDrawer();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ).then((result) {
                      // 로그인 페이지에서 반환된 데이터 처리
                      if (result != null && result['isLoggedIn']) {
                        setState(() {
                          MyApp.isLoggedIn = result['isLoggedIn'];
                          MyApp.userName = result['username'];
                          MyApp.userId = result['userId'];
                        });
                      }
                    });
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
                child: Icon(
                  Icons.person,
                  size: 60.0, // Adjust the size as needed
                  color: Colors.grey, // Adjust the color as needed
                ),
              ),
              accountName: Text(MyApp.userName ?? 'Guest'),
              accountEmail: Text(MyApp.userId != null ? MyApp.userId.toString() : ''),
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
              title: Text('회원상태: ${MyApp.userStatus}'),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('아직 개발 중인 서비스입니다.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('확인', style: TextStyle(color: Colors.cyan.shade800),),
                          onPressed: () {
                            Navigator.of(context).pop(); // 팝업 닫기
                          },
                        ),
                      ],
                    );
                  },
                );
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
                            decoration: InputDecoration(
                              border: InputBorder.none, // 밑줄 제거
                              // 기타 필요한 데코레이션 설정
                            ),
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
            myPageView,

            //3분할 아이콘
            Container(
              height: 85,
              margin: EdgeInsets.only(top: 13, left: 10, right: 10, bottom:13),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey), bottom: BorderSide(color: Colors.grey))),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () => _checkLoginAndNavigate(context, MyLoanPage()),
                        child: MainFunction(imageUrl: 'assets/images/대출현황.jpg', text: '대출조회')
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                        onTap: () => _checkLoginAndNavigate(context, MyInterestBooksPage()),
                        child: MainFunction(imageUrl: 'assets/images/관심.jpg', text: '관심도서')
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                        onTap: () => _checkLoginAndNavigate(context, BookingList()),
                        child: MainFunction(imageUrl: 'assets/images/로그.jpg', text: '예약내역')
                    ),
                  ),
                ],
              ),
            ),


            Container(
              margin: EdgeInsets.only(left: 20, bottom: 8),
              child: Row(
                children: [
                  LibDropdown(
                    selectedLibrary: selectedLibrary,
                    onLibraryChanged: _onLibraryChanged,
                    libraryUrls: libraryUrls,
                  ),
                  GestureDetector(
                    onTap: () => _launchLibraryUrl('공지사항'),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.only(top: 5, bottom: 5, left: 10.0, right: 10),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_forward_ios, color: Colors.grey.shade800, size: 18.0,),
                          Text('공지사항', style: TextStyle(color: Colors.grey.shade800, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 18, decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2)))),
                  GestureDetector(
                    onTap: () => _launchLibraryUrl('문화행사'),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.only(top: 5, bottom: 5, left: 10.0, right: 10.0),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_forward_ios, color: Colors.grey.shade800, size: 18.0,),
                          Text('문화행사', style: TextStyle(color: Colors.grey.shade800, fontSize: 18.0, fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 35, bottom: 5),
              child: Row(
                children: [
                  DayCircle(color: Colors.red[400]!, text: '오늘',),
                  SizedBox(width: 15), // 추가 간격
                  DayCircle(color: Colors.grey, text: '휴관일',),
                  SizedBox(width: 15), // 추가 간격
                  DayCircle(color: Colors.blue, text: '행사일',),
                ],
              ),
            ),
            _buildEventList(),
            _buildTableCalendar(),
            SizedBox(height:30),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: DropdownButton<String>(
            value: widget.selectedLibrary,
            onChanged: (String? newValue) {
              if (newValue != null) {
                print("LibDropdown onChanged 호출됨, 선택된 도서관: $newValue");
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