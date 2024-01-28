import 'package:flutter/material.dart';
import 'main.dart';
import 'BookSearch.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'BookDetail.dart';

class MyInterestBooksPage extends StatefulWidget {
  @override
  State<MyInterestBooksPage> createState() => _MyInterestBooksPageState();
}



class _MyInterestBooksPageState extends State<MyInterestBooksPage> {
  List<Widget> _bookWidgets = [];
  String _imageUrl = '';



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
          '나의 관심 도서',
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _bookWidgets.length,
              itemBuilder: (context, index) {
                return _bookWidgets[index];
              },
            ),
          ],
        ),
      ),
    );
  }
}




class InterestBook extends StatefulWidget {
  final String id;
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

  InterestBook({
    required this.id,
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
  });

  @override
  State<InterestBook> createState() => _InterestBookState();
}

class _InterestBookState extends State<InterestBook> {
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

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    String loanStatusText = widget.loanstatus ? '대출가능' : '대출불가';
    Color loanStatusColor = widget.loanstatus ? Colors.cyan.shade700 : Colors.red.shade400;
    String loanStatusBox = widget.loanstatus ? '책누리신청' : '예약하기';


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetail(
              id: widget.id,
              imageUrl: widget.imageUrl,
              bookTitle: widget.bookTitle,
              author: widget.author,
              library: widget.library,
              publisher: widget.publisher,
              location: widget.location,
              loanstatus: widget.loanstatus,
              book_isbn: widget.book_isbn,
              reserved: widget.reserved,
              size: widget.size,
              price: widget.price,
              classification: widget.classification,
              media: widget.media,
              field_name: widget.field_name,
              book_ii: widget.book_ii,
              series: widget.series,
            ),
          ),
        );
      },
      child:  Container(
          width: Width *0.95,
          margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
          padding: EdgeInsets.all(12),
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
              Image.network(widget.imageUrl, height: Height*0.25*0.6
              ),
              SizedBox(width: 20,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      widget.loanstatus ? Icon(Icons.check, color: Colors.cyan.shade700, weight: 20) : Icon(Icons.clear, color: Colors.red.shade400),
                      Text(loanStatusText, style: TextStyle(color: loanStatusColor, fontSize: 16, fontWeight: FontWeight.bold,
                      )),
                    ],),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(softWrap:true, text: TextSpan(children: [
                            TextSpan(text: '['+widget.library+']', style: TextStyle(color: Colors.cyan.shade900, fontSize: 18, fontWeight: FontWeight.bold),),
                            TextSpan(text: ' '+widget.bookTitle, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
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
                                    TextSpan(
                                      text: '저자 ',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.author,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey.shade900, // 두 번째 텍스트의 글자색
                                      ),
                                    ),
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                      text: '발행처 ',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.publisher,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black, // 네 번째 텍스트의 글자색
                                      ),
                                    ),
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                      text: '자료위치 ',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.location,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey.shade900, // 두 번째 텍스트의 글자색
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12,),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}









