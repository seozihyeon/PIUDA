import 'package:flutter/material.dart';
import 'package:piuda/main.dart';
import 'package:piuda/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:piuda/BookDetail.dart';


class BookContainer extends StatelessWidget {
  final String book_id;
  final String imageUrl;
  final String bookTitle;
  final String author;
  final String library;
  final String publisher;
  final String location;
  final bool loanstatus;
  final String book_isbn;
  final bool reserved;
  final String size;
  final int price;
  final String classification;
  final String media;
  final String field_name;
  final String book_ii;
  final String? series; //null을 허용
  final VoidCallback? onReservationCompleted;
  final String? recommender;



  BookContainer({
    required this.book_id,
    required this.imageUrl,
    required this.bookTitle,
    required this.author,
    required this.library,
    required this.publisher,
    required this.location,
    required this.loanstatus,
    required this.book_isbn,
    required this.reserved,
    required this.size,
    required this.price,
    required this.classification,
    required this.media,
    required this.field_name,
    required this.book_ii,
    this.series, //null 허용
    this.onReservationCompleted,
    required this.recommender,
  });


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
        // 예약 가능한 경우 예약 요청 수행
        final DateTime now = DateTime.now();
        final String reserveDate = "${now.year}-${now.month}-${now.day}";
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080 /api/userbooking/add'),
          body: {
            'user_id': userId,
            'book_id': bookId,
            'reserve_date': reserveDate, // 예약 날짜 추가
          },
        );

        // 서버 응답 확인
        String message = response.body;
        if (response.statusCode == 200) {
          // 예약 성공 메시지 표시
          if (message == "BookAddedSuccessfully") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text('예약이 완료되었습니다.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 팝업 닫기
                        onReservationCompleted?.call();
                      },
                      child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
                    ),
                  ],
                );
              },
            );
          }


          // 기타 오류 메시지 표시
          else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text('서버 오류: $message'),
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
        // 예약 실패 메시지 표시
        else if (message == "MaxReservationLimit") {
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
                    child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
                  ),
                ],
              );
            },
          );
        }
        // 이미 예약된 도서 메시지 표시
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

        // 서버 오류 메시지 표시
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('서버 오류: ${response.reasonPhrase}'),
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
              content: Text('예약 처리 중 오류가 발생했습니다: $e'),
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


  @override
  Widget build(BuildContext context) {
    bool isUserLoggedIn = (MyApp.userId ?? 0) > 0;
    // String loanStatusText = loanstatus ? '대출가능' : '대출불가';
    String loanStatusText = (loanstatus && !reserved) ? '대출가능' : '대출불가';
    // String loanStatusBox = loanstatus ? '책누리신청' : '예약하기';
    String loanStatusBox = (loanstatus || reserved) ? '책누리신청' : '예약하기';
    Color loanStatusColor = (loanstatus && !reserved) ? Colors.cyan.shade700 : Colors.red.shade400;

    if (reserved) {
      //if reserved
      loanStatusText += '(예약중)';
    }

    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetail(
              book_id: book_id,
            ),
          ),
        );
        if (result == true) {
          onReservationCompleted?.call();
        }
      },
      child:  Container(
          width: Width *0.95,
          margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            border: Border.all(color: Colors.grey, width: 1,),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imageUrl, height: Height*0.25*0.6
              ),
              SizedBox(width: 20,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      (loanstatus && !reserved) ? Icon(Icons.check, color: Colors.cyan.shade700, weight: 20) : Icon(Icons.clear, color: Colors.red.shade400),
                      Text(loanStatusText, style: TextStyle(color: loanStatusColor, fontSize: 16, fontWeight: FontWeight.bold,
                      )),
                    ],),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(softWrap:true, text: TextSpan(children: [
                            TextSpan(text: '['+library+']', style: TextStyle(color: Colors.cyan.shade900, fontSize: 18, fontWeight: FontWeight.bold),),
                            TextSpan(text: ' '+bookTitle, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                          ]),),
                        ),
                      ],
                    ),
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
                                    if (recommender != null) ...[
                                      TextSpan(text: '사서 ', style: TextStyle(fontSize: 18.0, color: Colors.grey.shade600,),),
                                      TextSpan(text: recommender, style: TextStyle(fontSize: 18.0, color: Colors.grey.shade900,),),
                                    ],
                                    TextSpan(text: '\n'),
                                    TextSpan(text: '저자 ', style: TextStyle(fontSize: 18.0, color: Colors.grey.shade600,),),
                                    TextSpan(text: author, style: TextStyle(fontSize: 18.0, color: Colors.grey.shade900,),),
                                    TextSpan(text: '\n'),
                                    TextSpan(text: '발행처 ', style: TextStyle(fontSize: 18.0, color: Colors.grey.shade600,),),
                                    TextSpan(text: publisher, style: TextStyle(fontSize: 18.0, color: Colors.black,),),
                                    TextSpan(text: '\n'),
                                    TextSpan(text: '자료위치 ', style: TextStyle(fontSize: 18.0, color: Colors.grey.shade600,),),
                                    TextSpan(text: location, style: TextStyle(fontSize: 18.0, color: Colors.grey.shade900,),),
                                  ]
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
                            addInterestBook(context, MyApp.userId ?? 0, book_id.toString());
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.white70,
                              border: Border.all(
                                color: Colors.grey.shade700, // 테두리 색상
                                width: 1.0, // 테두리 두께
                              ),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: Text('관심도서담기', style: TextStyle(color: Colors.grey.shade700, fontSize: 17.5,),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        if (!loanstatus && !reserved)
                          GestureDetector(
                            onTap: () {
                              reserveBook(context, MyApp.userId.toString(), book_id);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: loanStatusColor,
                                border: Border.all(color: Colors.white, width: 1.0,),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Text(
                                loanStatusBox,
                                style: TextStyle(color: Colors.white, fontSize: 17.5, fontWeight: FontWeight.bold
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
    );
  }
}