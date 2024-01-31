import 'package:flutter/material.dart';
import 'main.dart';
import 'BookSearch.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginPage.dart';

class BookDetail extends StatefulWidget {
  final String bookTitle;
  final String author;
  final String library;
  final String location;
  final bool loanstatus;
  final String book_isbn;
  final bool reserved;
  final String imageUrl;
  final String publisher;
  final String size;
  final int price;
  final String classification;
  final String media;
  final String field_name;
  final String book_id;
  final String book_ii;
  final String? series;
  final VoidCallback? onReservationCompleted;


  BookDetail({
    required this.imageUrl,
    required this.bookTitle,
    required this.author,
    required this.library,
    required this.location,
    required this.loanstatus,
    required this.book_isbn,
    required this.reserved,
    required this.publisher,
    required this.size,
    required this.price,
    required this.classification,
    required this.media,
    required this.field_name,
    required this.book_id,
    required this.book_ii,
    this.series,
    this.onReservationCompleted,

  });

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  String bookDescription = ""; // 책 소개를 저장할 변수
  bool isExpanded = false;
  bool showBookReviewContent = true;
  ScrollController _pageController = ScrollController();

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded; // 상태 전환
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBookDescription(widget.book_isbn);
  }

  Future<void> fetchBookDescription(String isbn) async {
    const clientId = 'uFwwNh4yYFgq3WtAYl6S'; // 발급받은 클라이언트 ID
    const clientSecret = 'WElJXwZDhV'; // 발급받은 클라이언트 Secret

    final response = await http.get(
      Uri.parse('https://openapi.naver.com/v1/search/book_adv.json?d_isbn=$isbn'),
      headers: {
        'X-Naver-Client-Id': clientId,
        'X-Naver-Client-Secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'].length > 0) {
        setState(() {
          bookDescription = data['items'][0]['description'];
        });
      }
    } else {
      print('Failed to fetch book data');
    }
  }

  Future<void> addInterestBook(BuildContext context, int userId, String bookId) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/userinterest/add'),
        body: {'user_id': userId.toString(), 'book_id': bookId},
      );

      if (response.statusCode == 200) {
        // 서버에서 성공적으로 응답을 받았을 때의 처리
        print('Book added to user\'s interest list successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('도서가 관심 도서에 추가되었습니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 400) {
        // 중복된 경우에 대한 처리
        print('Failed to add book to user\'s interest list: Duplicate book');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('이미 관심 도서에 추가된 책입니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      } else {
        // 서버에서 오류 응답을 받았을 때의 처리
        print('Failed to add book to user\'s interest list');
      }
    } catch (e) {
      // 네트워크 오류 등 예외가 발생했을 때의 처리
      print('Error adding interest book: $e');
    }
  }

  Future<void> reserveBook(BuildContext context, String userId, String bookId) async {
    // 로그인 상태 확인
    if (MyApp.userId == null) {
      // 로그인하지 않은 경우, 로그인 유도 팝업 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('로그인 후 이용 가능한 서비스입니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                },
                child: Text('확인'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('로그인하러 가기'),
              ),
            ],
          );
        },
      );
      return; // 함수 종료
    }
    else{
      // 로그인 상태일 때의 예약 처리 로직
      try {
        // 현재 사용자의 예약 내역을 확인
        final reservationsResponse = await http.get(
          Uri.parse('http://10.0.2.2:8080/api/userbooking/reservations?user_id=$userId'),
        );

        if (reservationsResponse.statusCode == 200) {
          final List<dynamic> reservations = json.decode(reservationsResponse.body);

          // 최대 예약 가능 권수를 초과했을 경우
          if (reservations.length >= 3) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text('예약은 최대 3권까지 가능합니다.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 팝업 닫기
                      },
                      child: Text('확인'),
                    ),
                  ],
                );
              },
            );
            return; // 함수 종료
          }
        }

        // 예약 가능한 경우 예약 요청 수행
        final DateTime now = DateTime.now();
        final String reserveDate = "${now.year}-${now.month}-${now.day}";
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/userbooking/add'),
          body: {
            'user_id': userId,
            'book_id': bookId,
            'reserve_date': reserveDate,
          },
        );

        // 예약 요청 응답 처리
        if (response.statusCode == 200) {
          // 예약 성공 메시지 표시
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('예약이 완료되었습니다.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 팝업 닫기
                      widget.onReservationCompleted?.call();
                    },
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
        } else {
          // 예약 실패 메시지 표시
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('예약은 최대 3권까지 가능합니다.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        // 네트워크 오류 등 예외 처리
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('예약 처리 중 오류가 발생했습니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      }
    }}
  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    String loanStatusText = widget.loanstatus ? '대출가능' : '대출불가';
    Color loanStatusColor = widget.loanstatus ? Colors.cyan.shade700 : Colors.red.shade400;
    String loanStatusBox = widget.loanstatus ? '책누리신청' : '예약하기';

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
          '도서 상세 정보',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black, // 글자색 설정
          ),
        ),
        backgroundColor: Colors.white,
      ),


      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  width: Width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      color: Colors.grey, // 테두리 색상
                      width: 1, // 테두리 두께
                    ),
                  ),

                  child: Column(
                    children: [
                      // 제목 컨테이너
                      Container(
                        width: double.infinity,
                        // margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border(
                              bottom: BorderSide(color: Colors.grey,
                                width: 1,)
                          ),
                        ),
                        child: Center( // Center 위젯 추가
                          child: RichText(
                            softWrap: true,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.bookTitle,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // 이미지 컨테이너
                      Container(
                        margin: EdgeInsets.only(bottom: 3),
                        child: Image.network(widget.imageUrl, height: Height * 0.3),
                      ),
                      Container(
                        width: Width * 0.35,
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          border: Border.all(
                            color: Colors.cyan.shade700, // 테두리 색상
                            width: 1.2, // 테두리 두께
                          ),
                        ),
                        child: Center( // Center 위젯 추가
                          child: RichText(
                            softWrap: true,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.field_name,
                                  style: TextStyle(
                                    color: Colors.cyan.shade700,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 상세 정보 컨테이너
                      Container(
                          width: Width *0.95,
                          margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(

                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 20,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            //decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade500,), top: BorderSide(color: Colors.grey.shade500,)))
                                            child: RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '도서관 ',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey.shade900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: widget.library,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                                      ),
                                                    ),
                                                    TextSpan(text: '\n'),
                                                    TextSpan(
                                                      text: '저자 ',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey.shade900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: widget.author,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                                      ),
                                                    ),
                                                    TextSpan(text: '\n'),
                                                    TextSpan(
                                                      text: '발행처 ',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey.shade900, // 세 번째 텍스트의 글자색
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: widget.publisher,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.grey.shade800, // 네 번째 텍스트의 글자색
                                                      ),
                                                    ),
                                                    TextSpan(text: '\n'),
                                                    TextSpan(
                                                      text: '자료위치 ',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey.shade900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: widget.location,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                                      ),
                                                    ),
                                                    TextSpan(text: '\n'),
                                                    TextSpan(
                                                      text: '형태사항 ',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey.shade900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: widget.size,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                                      ),
                                                    ),
                                                    TextSpan(text: '\n'),
                                                    if (widget.series != null) ...[
                                                      TextSpan(
                                                        text: '총서명 ',
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.grey.shade900,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: widget.series,
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.grey.shade800,
                                                        ),
                                                      ),
                                                      TextSpan(text: '\n'),
                                                    ],
                                                    TextSpan(
                                                      text: 'ISBN ',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey.shade900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: widget.book_isbn,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                                      ),
                                                    ),
                                                    TextSpan(text: '\n'),
                                                    TextSpan(
                                                      text: '가격 ',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey.shade900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: widget.price.toString(),
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                                      ),
                                                    ),
                                                    TextSpan(text: '\n'),
                                                    TextSpan(
                                                      text: '분류기호 ',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey.shade900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: widget.classification,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                                      ),
                                                    ),
                                                    TextSpan(text: '\n'),
                                                    TextSpan(
                                                      text: '매체구분 ',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey.shade900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: widget.media,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top:12, ),
                  child: RichText(
                    softWrap: true,
                    text: TextSpan(
                      children: const [
                        TextSpan(
                          text: "책 소개",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 책 소개 컨테이너
                Container(
                  width: Width * 0.95,
                  margin: EdgeInsets.only(top:5, bottom:10, ),
                  padding: EdgeInsets.only(top: 20, right:20, left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      color: Colors.grey, // 테두리 색상
                      width: 1, // 테두리 두께
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isExpanded ? bookDescription : bookDescription.length > 100 ? bookDescription.substring(0, 100) + '...' : bookDescription,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      bookDescription.length > 100 ? TextButton(
                        onPressed: toggleExpanded,
                        child: Text(
                          isExpanded ? '접기' : '더보기',
                          style: TextStyle(color: Colors.cyan.shade700, fontSize: 15, fontWeight: FontWeight.bold,),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.5), // 버튼 내부 패딩
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // 버튼 모서리 둥글게
                          ),
                        ),
                      ) : SizedBox.shrink(),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top:12, ),
                  child: RichText(
                    softWrap: true,
                    text: TextSpan(
                      children: const [
                        TextSpan(
                          text: "소장 정보",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //소장 정보 Container
                Container(
                    width: Width *0.95,
                    margin: EdgeInsets.only(top:5, bottom:10, ),
                    padding: EdgeInsets.only(top: 15, right:20, left: 20, bottom:20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      border: Border.all(
                        color: Colors.grey, // 테두리 색상
                        width: 1, // 테두리 두께
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                widget.loanstatus ? Icon(Icons.check, color: Colors.cyan.shade700, weight: 20) : Icon(Icons.clear, color: Colors.red.shade400),
                                Text(loanStatusText, style: TextStyle(color: loanStatusColor, fontSize: 16, fontWeight: FontWeight.bold,)),
                              ],),
                              SizedBox(height: 4,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade500,), top: BorderSide(color: Colors.grey.shade500,))),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '등록번호 ',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade900,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.book_id,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                              ),
                                            ),
                                            TextSpan(text: '\n'),
                                            TextSpan(
                                              text: '청구기호 ',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade900,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.book_ii,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                              ),
                                            ),
                                            TextSpan(text: '\n'),
                                            TextSpan(
                                              text: '자료위치 ',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade900,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.location,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                              ),
                                            ),
                                            TextSpan(text: '\n'),
                                            TextSpan(
                                              text: '매체구분 ',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade900,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.media,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12,),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      addInterestBook(context, MyApp.userId ?? 0, widget.book_id.toString());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        border: Border.all(
                                          color: Colors.grey.shade700, // 테두리 색상
                                          width: 1.0, // 테두리 두께
                                        ),
                                        borderRadius: BorderRadius.circular(2.0), // 테두리의 모서리를 둥글게 만듭니다.
                                      ),
                                      child: Text(
                                        '관심도서담기',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 17.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  if (!widget.loanstatus && !widget.reserved)
                                    GestureDetector(
                                      onTap: () {
                                        reserveBook(context, MyApp.userId.toString(), widget.book_id);
                                      },
                                     child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: loanStatusColor,
                                        border: Border.all(
                                          color: Colors.white, // 테두리 색상
                                          width: 1.0, // 테두리 두께
                                        ),
                                        borderRadius: BorderRadius.circular(2.0), // 테두리의 모서리를 둥글게 만듭니다.
                                      ),
                                      child: Text(
                                        loanStatusBox,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.5,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
    ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                ),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top:12,),
                  child: Text(
                    "리뷰",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    child: Text("이 책이 마음에 드셨나요? 다양한 후기를 감상해보세요!", style: TextStyle(color: Colors.grey.shade700, fontSize: 14),)
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showBookReviewContent = true;
                        });
                      },
                      child: Text('도서리뷰'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showBookReviewContent ? Colors.cyan.shade800 : Colors.white,
                        foregroundColor: showBookReviewContent ? Colors.white : Colors.black,
                        side: BorderSide(
                          color: showBookReviewContent ? Colors.transparent : Colors.cyan.shade800, // Border color
                          width: 1.0, // Border width
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showBookReviewContent = false;
                        });
                      },
                      child: Text('상태평가'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showBookReviewContent ? Colors.white : Colors.cyan.shade800,
                        foregroundColor: showBookReviewContent ? Colors.black : Colors.white,
                        side: BorderSide(
                          color: showBookReviewContent ? Colors.cyan.shade800 : Colors.transparent, // Border color
                          width: 1.0, // Border width
                        ),
                      ),
                    ),
                  ],
                ),
                showBookReviewContent ? BookReviewContent(pageController: _pageController) : StateReviewContent(pageController: _pageController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class BookReviewContent extends StatefulWidget {
  final ScrollController pageController;
  BookReviewContent({required this.pageController});

  @override
  State<BookReviewContent> createState() => _BookReviewContentState();
}

class _BookReviewContentState extends State<BookReviewContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ReviewBox(user_name: "서**", review_date: "2024-01-05", review_score: 5, review_content: "너무재밋어요~"),
          ReviewBox(user_name: "서**", review_date: "2024-01-05", review_score: 5, review_content: "너무재밋어요~"),
          ReviewBox(user_name: "서**", review_date: "2024-01-05", review_score: 5, review_content: "너무재밋어요~"),
        ],
      ),
    );
  }
}



class StateReviewContent extends StatefulWidget {
  final ScrollController pageController;
  StateReviewContent({required this.pageController});

  @override
  State<StateReviewContent> createState() => _StateReviewContentState();
}

class _StateReviewContentState extends State<StateReviewContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          StateReviewBox(user_name: "조**", state_date: "2024-01-02", lost_score: 4, taint_score: 3, condi_op: "깨끗해요! 관리 굿굿"),
          StateReviewBox(user_name: "조**", state_date: "2024-01-02", lost_score: 4, taint_score: 3, condi_op: "깨끗해요! 관리 굿굿"),
          StateReviewBox(user_name: "조**", state_date: "2024-01-02", lost_score: 4, taint_score: 3, condi_op: "깨끗해요! 관리 굿굿"),
        ],
      ),
    );
  }
}



class ReviewBox extends StatelessWidget {
  final String user_name;
  final int review_score;
  final String review_content;
  final String review_date;

  ReviewBox({
    required this.user_name,
    required this.review_score,
    required this.review_content,
    required this.review_date,
  });

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;

    return Container(
      width: Width * 0.95,
      margin: EdgeInsets.only(bottom:5),
      padding: EdgeInsets.only(top: 10, bottom: 10, right:20, left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(
          color: Colors.grey, width: 1, // 테두리 두께
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(user_name, style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(width: 10,),
              Text(review_date, style: TextStyle(color: Colors.grey.shade700),)
            ],
          ),
          Text("별점 " + review_score.toString(), style: TextStyle(color: Colors.cyan.shade800), ),
          Text(review_content)
        ],
      ),
    );
  }
}

class StateReviewBox extends StatelessWidget {
  final String user_name;
  final int lost_score;
  final int taint_score;
  final String condi_op;
  final String state_date;

  StateReviewBox({
    required this.user_name,
    required this.lost_score,
    required this.taint_score,
    required this.condi_op,
    required this.state_date,
  });

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;

    return Container(
      width: Width * 0.95,
      margin: EdgeInsets.only(bottom:5),
      padding: EdgeInsets.only(top: 10, bottom: 10, right:20, left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(
          color: Colors.grey, width: 1, // 테두리 두께
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(user_name, style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(width: 10,),
              Text(state_date, style: TextStyle(color: Colors.grey.shade700),)
            ],
          ),
          Text("손실도 " + lost_score.toString(), style: TextStyle(color: Colors.cyan.shade800), ),
          Text("오염도 " + taint_score.toString(), style: TextStyle(color: Colors.cyan.shade800), ),
          Text(condi_op),
        ],
      ),
    );
  }
}

