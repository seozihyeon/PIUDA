import 'package:flutter/material.dart';

class BookingList extends StatefulWidget {
  const BookingList({super.key});

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  @override
  Widget build(BuildContext context) {
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
          '나의 도서 예약 내역',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black, // 글자색 설정
          ),
        ),
        backgroundColor: Colors.white,
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                BookingContainer(id: null, imageUrl: Image.asset('assets/images/나미야.jpg'), bookTitle: "젊은 베르테르의 슬픔", author: "요한 볼프강", library: "성동구립도서관", location: "어린이 열람실", reserve_date: '2024-01-11', book_isbn: null)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//표지, 제목, 저자, 도서관, 자료위치, 예약일
class BookingContainer extends StatelessWidget {
  final String? id;
  final Image imageUrl;
  final String bookTitle;
  final String author;
  final String library;
  final String location;
  final String reserve_date;
  final String? book_isbn;



  BookingContainer({
    required this.id,
    required this.imageUrl,
    required this.bookTitle,
    required this.author,
    required this.library,
    required this.location,
    required this.reserve_date,
    required this.book_isbn,
  });



  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return Container(
        width: Width *0.95,
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
                  Text("상태: 예약", style: TextStyle(color: Colors.cyan.shade800),),
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
                                    text: '저자 ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                                    ),
                                  ),
                                  TextSpan(
                                    text: author,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black, // 네 번째 텍스트의 글자색
                                    ),
                                  ),
                                  TextSpan(text: '\n'),
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
                                    text: '자료위치 ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: location,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey.shade900, // 두 번째 텍스트의 글자색
                                    ),
                                  ),
                                  TextSpan(text: '\n'),
                                  TextSpan(
                                    text: '예약일 ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: reserve_date,
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
                  SizedBox(height: 6,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey,
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
                ],
              ),
            )
          ],
        )
    );
  }
}
