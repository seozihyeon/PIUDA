import 'package:flutter/material.dart';
import 'package:piuda/ReviewBook.dart';
import 'package:piuda/ReviewState.dart';

import 'main.dart';
import 'BookDetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MyLoanPage extends StatefulWidget {
  const MyLoanPage({super.key});

  @override
  State<MyLoanPage> createState() => _MyLoanPageState();
}

class _MyLoanPageState extends State<MyLoanPage> {
  bool showFirstContent = true;
  ScrollController _pageController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      // 스크롤 위치가 일정량 이상 내려가면 다음 페이지로 이동
      if (_pageController.offset > 500) {
        setState(() {

        });
      }
    });
  }



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
          '나의 대출 조회',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showFirstContent = true;
                      });
                    },
                    child: Text('대출현황'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showFirstContent ? Colors.cyan.shade800 : Colors.white,
                      foregroundColor: showFirstContent ? Colors.white : Colors.black,
                      side: BorderSide(
                        color: showFirstContent ? Colors.transparent : Colors.cyan.shade800, // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showFirstContent = false;
                      });
                    },
                    child: Text('대출내역'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showFirstContent ? Colors.white : Colors.cyan.shade800,
                      foregroundColor: showFirstContent ? Colors.black : Colors.white,
                      side: BorderSide(
                        color: showFirstContent ? Colors.cyan.shade800 : Colors.transparent, // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                  ),
                ],
              ),
              showFirstContent
                  ? FirstContent(pageController: _pageController)
                  : SecondContent(pageController: _pageController),
            ],
          ),
        ),
      ),
    );
  }
}





class FirstContent extends StatefulWidget {
  final ScrollController pageController;
  FirstContent({required this.pageController});

  @override
  _FirstContentState createState() => _FirstContentState();
}

class _FirstContentState extends State<FirstContent> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.pageController,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.cyan.shade800, width: 2)
        ),
        child: Column(
          children: [
            LoanBookContainer(
              id: null,
              imageUrl: Image.asset('assets/images/나미야.jpg'),
              bookTitle: '나미야 잡화점의 기적',
              author: '히가시노게이고',
              library: '성동구립도서관',
              loan_date: '2022-02-28',
              return_date: null,
              remain_date: '3',
              expect_date: '2022-02-28',
              returnstatus: false,
              book_isbn: null,
            ),
            LoanBookContainer(
              id: null,
              imageUrl: Image.asset('assets/images/나미야.jpg'),
              bookTitle: '나미야 잡화점의 기적',
              author: '히가시노게이고',
              library: '성동구립도서관',
              loan_date: '2022-02-28',
              return_date: null,
              remain_date: '3',
              expect_date: '2022-02-28',
              returnstatus: false,
              book_isbn: null,
            ),
            LoanBookContainer(
              id: null,
              imageUrl: Image.asset('assets/images/나미야.jpg'),
              bookTitle: '나미야 잡화점의 기적',
              author: '히가시노게이고',
              library: '성동구립도서관',
              loan_date: '2022-02-28',
              return_date: null,
              remain_date: '3',
              expect_date: '2022-02-28',
              returnstatus: false,
              book_isbn: null,
            ),

          ],
        ),
      ),
    );
  }
}


class SecondContent extends StatefulWidget {
  final ScrollController pageController;
  SecondContent({required this.pageController});

  @override
  State<SecondContent> createState() => _SecondContentState();
}

class _SecondContentState extends State<SecondContent> {
  String selectedYear = '2024';

  @override
  Widget build(BuildContext context) {
    List<String> years = List.generate(25, (index) => (2024 - index).toString());

    return SingleChildScrollView(
      controller: widget.pageController,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.cyan.shade800, width: 2)
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.cyan.shade800),
                borderRadius: BorderRadius.circular(10)
              ),
              child: DropdownButton<String>(
                value: selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                    // Perform any additional actions based on the selected year
                  });
                },
                items: years.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                isExpanded: true,
              ),
            ),
            SizedBox(height: 10,),
            LoanBookContainer(
              id: null,
              imageUrl: Image.asset('assets/images/나미야.jpg'),
              bookTitle: '나미야 잡화점의 기적',
              author: '히가시노게이고',
              library: '성동구립도서관',
              loan_date: '2022-02-28',
              return_date: null,
              remain_date: null,
              expect_date: '2022-02-28',
              returnstatus: true,
              book_isbn: null,
            ),
            LoanBookContainer(
              id: null,
              imageUrl: Image.asset('assets/images/나미야.jpg'),
              bookTitle: '나미야 잡화점의 기적',
              author: '히가시노게이고',
              library: '성동구립도서관',
              loan_date: '2022-02-28',
              return_date: null,
              remain_date: '3',
              expect_date: '2022-02-28',
              returnstatus: false,
              book_isbn: null,
            ),
            LoanBookContainer(
              id: null,
              imageUrl: Image.asset('assets/images/나미야.jpg'),
              bookTitle: '나미야 잡화점의 기적',
              author: '히가시노게이고',
              library: '성동구립도서관',
              loan_date: '2022-02-28',
              return_date: null,
              remain_date: '3',
              expect_date: '2022-02-28',
              returnstatus: false,
              book_isbn: null,
            ),
            LoanBookContainer(
              id: null,
              imageUrl: Image.asset('assets/images/나미야.jpg'),
              bookTitle: '나미야 잡화점의 기적',
              author: '히가시노게이고',
              library: '성동구립도서관',
              loan_date: '2022-02-28',
              return_date: null,
              remain_date: null,
              expect_date: '2022-02-28',
              returnstatus: true,
              book_isbn: null,
            ),
            LoanBookContainer(
              id: null,
              imageUrl: Image.asset('assets/images/나미야.jpg'),
              bookTitle: '나미야 잡화점의 기적',
              author: '히가시노게이고',
              library: '성동구립도서관',
              loan_date: '2022-02-28',
              return_date: null,
              remain_date: null,
              expect_date: '2022-02-28',
              returnstatus: true,
              book_isbn: null,
            ),

          ],

        ),
      ),
    );
  }
}



//대출현황: 표지, 제목, 도서관, 대출일자, 반납예정일(남은기간), 반납상태, [[반납연기버튼, 상태평가버튼, 도서리뷰버튼]]
//대출내역: 표지, 제목, 도서관, 대출일자, 반납일자, 반납상태, [[상태평가버튼, 도서리뷰버튼]]
class LoanBookContainer extends StatelessWidget {
  final String? id;
  final Image imageUrl;
  final String bookTitle;
  final String author;
  final String library;
  final String loan_date;
  final String? return_date;
  final String? remain_date; //남은날짜
  final String? expect_date; //반납예정일
  final bool returnstatus; //반납상태 t-반납완료, f-대출중
  final String? book_isbn;



  LoanBookContainer({
    required this.id,
    required this.imageUrl,
    required this.bookTitle,
    required this.author,
    required this.library,
    required this.loan_date,
    required this.return_date,
    required this.remain_date,
    required this.expect_date,
    required this.returnstatus,
    required this.book_isbn,
  });



  @override
  Widget build(BuildContext context) {
    String returnStatusText = returnstatus ? '반납완료' : '대출중';
    Color returnStatusColor = returnstatus ?  Colors.cyan.shade700 : Colors.red.shade400;

    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return Container(
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
            Container(child: imageUrl, height: Height*0.25*0.6),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        returnstatus ? Icon(Icons.check, color: returnStatusColor, weight: 20) : Icon(Icons.sync, color: returnStatusColor),
                        Text(returnStatusText, style: TextStyle(color: returnStatusColor, fontSize: 16, fontWeight: FontWeight.bold,
                        )),
                      ],),
                      if (!returnstatus )
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(border: Border.all(color: Colors.red.shade400, width: 2), borderRadius: BorderRadius.circular(15)),

                            
                            child: Text('D-' + (remain_date ?? ''), style: TextStyle(fontWeight: FontWeight.w700),))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(softWrap:true, text: TextSpan(children: [
                          TextSpan(text: bookTitle, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
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
                                    text: '도서관 ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                                    ),
                                  ),
                                  TextSpan(
                                    text: library,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black, // 네 번째 텍스트의 글자색
                                    ),
                                  ),
                                  TextSpan(text: '\n'),
                                  TextSpan(
                                    text: '대출일자 ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: loan_date,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey.shade900, // 두 번째 텍스트의 글자색
                                    ),
                                  ),
                                  TextSpan(text: '\n'),
                                  TextSpan(
                                    text: returnstatus? '반납일자 ' : '반납예정일 ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: returnstatus? return_date : expect_date,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey.shade900, // 두 번째 텍스트의 글자색
                                    ),
                                  )
                                ]
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6,),
                  if (!returnstatus )
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: returnStatusColor,
                              border: Border.all(
                                color: Colors.white, // 테두리 색상
                                width: 1.0, // 테두리 두께
                              ),
                              borderRadius: BorderRadius.circular(2.0), // 테두리의 모서리를 둥글게 만듭니다.
                            ),
                            child: Text(
                              '반납연기',
                              textAlign: TextAlign.center,
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
                  SizedBox(height: 3,),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // '도서리뷰' 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookReview()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 2, bottom: 2),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(
                                color: Colors.grey.shade800, // 테두리 색상
                                width: 1.0, // 테두리 두께
                              ),
                              borderRadius: BorderRadius.circular(2.0), // 테두리의 모서리를 둥글게 만듭니다.
                            ),
                            child: Text(
                              '도서 리뷰',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 17.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6,),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // '상태평가' 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookStateReview()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 2, bottom: 2),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(
                                color: Colors.grey.shade800, // 테두리 색상
                                width: 1.0, // 테두리 두께
                              ),
                              borderRadius: BorderRadius.circular(2.0), // 테두리의 모서리를 둥글게 만듭니다.
                            ),
                            child: Text(
                              '상태 평가',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 17.5,
                              ),
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
    );
  }
}










