import 'package:flutter/material.dart';
import 'main.dart';
import 'BookSearch.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final String id;
  final String book_ii;
  final String? series;

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
    required this.id,
    required this.book_ii,
    this.series,
  });

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  String bookDescription = ""; // 책 소개를 저장할 변수
  bool isExpanded = false;

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
          child: Column(
          children: [
            Container(
            width: Width * 0.95,
            margin: EdgeInsets.all(10),
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
              padding: EdgeInsets.only(top:12, left:15),
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
              margin: EdgeInsets.only(top:5, bottom:10, right:5, left:5),
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
              padding: EdgeInsets.only(top:12, left:15),
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
                margin: EdgeInsets.only(top:5, bottom:10, right:5, left:5),
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
                                            text: widget.id,
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
                              Container(
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
                              SizedBox(width: 10,),
                              if (!widget.loanstatus && !widget.reserved)
                                Container(
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
      ),
    );
  }
}