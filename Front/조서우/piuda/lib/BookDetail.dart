import 'package:flutter/material.dart';
import 'main.dart';
import 'BookSearch.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginPage.dart';
import 'review.dart';
import 'review_service.dart';
import 'package:intl/intl.dart';


var reviewService = ReviewService();


class BookDetail extends StatefulWidget {
  final String bookTitle;
  final String author;
  final String library;
  final String location;
  final bool loanstatus;
  final String book_isbn;
  bool reserved;
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
  String expectedDate;



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
    this.expectedDate = '',


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

  List<Review> reviews = [];
  List<ReviewConditionBox> reviewconditions = [];

  @override
  void initState() {
    super.initState();
    fetchBookDescription(widget.book_isbn);
    fetchReviews();
    fetchReviewconditions();
    getExpectedDate(widget.book_id);
  }

  void fetchReviews() async {
    try {
      var reviewService = ReviewService();
      var fetchedReviews = await reviewService.fetchReviews(widget.book_isbn);
      setState(() {
        reviews = fetchedReviews;
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  void fetchReviewconditions() async {
    try {
      var conditionService = ConditionService();
      var fetchedReviewconditions = await conditionService.fetchConditions(widget.book_id);
      setState(() {
        reviewconditions = fetchedReviewconditions;
      });
    } catch (e) {
      print('Error fetching review conditions: $e');
    }
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
                child: Text(
                    '확인', style: TextStyle(color: Colors.cyan.shade800)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                    '로그인하러 가기', style: TextStyle(color: Colors.cyan.shade800)),
              ),
            ],
          );
        },
      );
      return; // 함수 종료
    }
    else {
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
                    child: Text(
                        '확인', style: TextStyle(color: Colors.cyan.shade800)),
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
                    child: Text(
                        '확인', style: TextStyle(color: Colors.cyan.shade800)),
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
                child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('로그인하러 가기', style: TextStyle(color: Colors.cyan.shade800)),
              ),
            ],
          );
        },
      );
      return; // 함수 종료
    } else {
      // 로그인 상태일 때의 예약 처리 로직
      try {
        // 예약 요청 보내기
        final DateTime now = DateTime.now();
        final String reserveDate = "${now.year}-${now.month}-${now.day}";
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080 /api/userbooking/add'),
          body: {
            'user_id': userId,
            'book_id': bookId,
            'reserve_date': reserveDate,
          },
        );

        print('서버 응답 메시지: ${response.body}');


        // 서버 응답 확인
        String message = response.body;
        if (response.statusCode == 200) {
          // 예약 성공 메시지
          if (message == "BookAddedSuccessfully")  {
            // 예약 성공 시, 상태 업데이트
            setState(() {
              widget.reserved = true; // 예약 상태를 true로 설정
              // 다른 필요한 상태 업데이트도 여기서 수행
            });
            // 성공 메시지 표시
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
                      child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
                    ),
                  ],
                );
              },
            );
          }


          // 기타 오류 메시지
          else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(message), // 서버에서 받은 메시지 표시
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 팝업 닫기
                      },
                      child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
                    ),
                  ],
                );
              },
            );
          }
        }
        // 최대 예약 권수 초과 메시지
        else if (message == "MaxReservationLimit") {
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
                    child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
                  ),
                ],
              );
            },
          );
        }
        // 이미 예약된 도서 메시지
        else if (message == "AlreadyReserved") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('이미 예약된 도서입니다.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 팝업 닫기
                    },
                    child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
                  ),
                ],
              );
            },
          );
        }
        // 서버 오류 메시지
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('서버 오류가 발생했습니다.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 팝업 닫기
                    },
                    child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
                  ),
                ],
              );
            },
          );
        }
      }
      // 예외 처리
      catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('예약 처리 중 오류가 발생했습니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 팝업 닫기
                  },
                  child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> getExpectedDate(String bookId) async {
    try {
      print('Book ID: $bookId');

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/loan/expected-dates/$bookId'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> expectedDates = jsonDecode(response.body);
        String nearestDate = expectedDates.isNotEmpty ? expectedDates.first : '';

        setState(() {
          if (widget.book_id == bookId) {
            widget.expectedDate = nearestDate;
          }
        });
      } else {
        print('Failed to load expected date');
      }
    } catch (e) {
      print('Error loading expected date: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    String loanStatusText = (widget.loanstatus && !widget.reserved) ? '대출가능' : '대출불가';
    Color loanStatusColor = (widget.loanstatus && !widget.reserved) ? Colors.cyan.shade700 : Colors.red.shade400;
    String loanStatusBox = (widget.loanstatus || widget.reserved) ? '책누리신청' : '예약하기';

    String formatDateString(String dateString) {
      try {
        DateTime parsedDate = DateTime.parse(dateString);
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (e) {
        // 날짜 파싱에 실패할 경우 로그를 출력하고 기본값 반환
        print('Date parsing error: $e');
        return '날짜 정보 없음';
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로가기 동작
            Navigator.pop(context, true);
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
                                                    TextSpan(text: '\n'),
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
                                (widget.loanstatus && !widget.reserved) ? Icon(Icons.check, color: Colors.cyan.shade700, weight: 20) : Icon(Icons.clear, color: Colors.red.shade400),
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
                                            if (widget.loanstatus == false) ...[
                                              TextSpan(text: '\n'),
                                              TextSpan(
                                                text: '반납예정일 ',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade900,
                                                ),
                                              ),
                                              TextSpan(
                                                text: formatDateString(widget.expectedDate),
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.grey.shade800, // 두 번째 텍스트의 글자색
                                                ),
                                              ),
                                            ],
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
                showBookReviewContent
                    ? BookReviewContent(pageController: _pageController, reviews: reviews)
                    : StateReviewContent(pageController: _pageController, reviewconditions: reviewconditions,),
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
  final List<Review> reviews;
  BookReviewContent({required this.pageController, required this.reviews});

  @override
  State<BookReviewContent> createState() => _BookReviewContentState();
}

class _BookReviewContentState extends State<BookReviewContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: widget.reviews.map((review) {
          return ReviewBox(
            user_name: review.userName ?? "익명", // null 처리
            review_date: review.reviewDate ?? "", // null 처리
            review_score: review.reviewScore ?? 0, // null 처리
            review_content: review.reviewContent ?? "", // null 처리
          );
        }).toList(),
      ),
    );
  }
}



class StateReviewContent extends StatefulWidget {
  final ScrollController pageController;
  final List<ReviewConditionBox> reviewconditions;
  StateReviewContent({required this.pageController, required this.reviewconditions});

  @override
  State<StateReviewContent> createState() => _StateReviewContentState();
}

class _StateReviewContentState extends State<StateReviewContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: widget.reviewconditions.map((reviewcon) {
          return StateReviewBox(
            user_name: reviewcon.userName ?? "익명", // null 처리
            state_date: reviewcon.conditionDate ?? "", // null 처리
            lost_score: reviewcon.lossScore ?? 0,
            taint_score: reviewcon.taintScore ?? 0,// null 처리
            condi_op: reviewcon.conditionOp ?? "", // null 처리
          );
        }).toList(),
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
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.95,
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(user_name, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text(review_date, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
          _buildStarRating(review_score),
          Text(review_content),
        ],
      ),
    );
  }

  Widget _buildStarRating(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      IconData starIcon = Icons.star;
      Color starColor = Colors.cyan.shade700;
      if (i >= rating) {
        starIcon = Icons.star_border;
        starColor = Colors.grey;
      }
      stars.add(
        Icon(starIcon, color: starColor, size: 20), // 별 크기를 20으로 설정
      );
    }
    return Row(children: stars);
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

  String getScoreText(int score) {
    switch (score) {
      case 1:
        return '너무 나빠요!';
      case 2:
        return '나빠요';
      case 3:
        return '보통이에요';
      case 4:
        return '만족해요';
      case 5:
        return '너무 만족해요!';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.95,
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(user_name, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text(state_date, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
          Row(
            children: [
              Text("손실도 ", style: TextStyle(color: Colors.cyan.shade900, )),
              Text(getScoreText(lost_score), style: TextStyle(color: Colors.cyan.shade700)),
            ],
          ),
          Row(
            children: [
              Text("오염도 ", style: TextStyle(color: Colors.cyan.shade900, )),
              Text(getScoreText(taint_score), style: TextStyle(color: Colors.cyan.shade700)),
            ],
          ),
          Text(condi_op),
        ],
      ),
    );
  }
}
