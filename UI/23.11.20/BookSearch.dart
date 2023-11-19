import 'package:flutter/material.dart';
import 'main.dart';

import 'package:flutter/material.dart';
import 'main.dart';

class BookSearch extends StatefulWidget {
  @override
  _BookSearchState createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  String _selectedSearchTarget = '자료명';
  Set<String> selectedOptions = Set<String>();

  bool _isPanelExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black, // 뒤로가기 버튼의 색상
        ),
        title: Text(
          '통합자료검색',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black, // 글자색 설정
          ),
        ),
        backgroundColor: Colors.white,
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 3, right: 3, bottom: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: Colors.grey.shade500, // 테두리 색상
                  width: 1.0, // 테두리 두께
                ),
              ),


              //@@검색창
              child: Column(
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

                  //1.도서관 체크박스 컨테이너
                  Container(
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: Text('구립도서관전체', style: TextStyle(color: Colors.black87),),
                      children: <Widget>[
                        LibraryOptions(),
                      ],
                    ),
                  ),
                  Container(
                    child: ExpansionTile(
                      title: Text('작은도서관전체'),
                      children: <Widget>[
                        SmallLibraryOptions(),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            Container(
              child: BookContainer(
                imageUrl: 'assets/images/라플라스.jpg',
                bookTitle: '라플라스의마녀',
                author: '히가시노 게이고',
                library: '성수도서관',
                loanstatus: false,
              ),
            ),
            Container(
              child: BookContainer(
                imageUrl: 'assets/images/라플라스.jpg',
                bookTitle: '라플라스의마녀',
                author: '히가시노 게이고',
                library: '무지개도서관',
                loanstatus: true,
              ),
            ),
            Container(
              child: BookContainer(
                imageUrl: 'assets/images/라플라스.jpg',
                bookTitle: '라플라스의마녀',
                author: '히가시노 게이고',
                library: '청계도서관',
                loanstatus: true,
              ),
            ),
            Container(
              child: BookContainer(
                imageUrl: 'assets/images/라플라스.jpg',
                bookTitle: '라플라스의마녀',
                author: '히가시노 게이고',
                library: '성동구립도서관',
                loanstatus: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




//책 정보박스
class BookContainer extends StatelessWidget {
  final String imageUrl;
  final String bookTitle;
  final String author;
  final String library;
  final bool loanstatus;

  BookContainer({
    required this.imageUrl,
    required this.bookTitle,
    required this.author,
    required this.library,
    required this.loanstatus,
  });

  @override
  Widget build(BuildContext context) {
    String loanStatusText = loanstatus ? '대출가능' : '대출불가';
    String loanStatusBox = loanstatus ? '책누리신청' : '예약하기';
    Color loanStatusColor = loanstatus ? Colors.blue.shade300 : Colors.red.shade300;

    return Container(
      height: 170.0,
      width: 650.0,
      margin: EdgeInsets.only(top:8, bottom: 8, left: 16, right: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(
          color: Colors.grey, // 테두리 색상
          width: 1, // 테두리 두께
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Image.asset(imageUrl, fit: BoxFit.cover
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 230,
                padding: EdgeInsets.only(bottom: 7),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(child: Text('['+library+']', style: TextStyle(color: Colors.cyan.shade900, fontSize: 18, fontWeight: FontWeight.bold),)),
                  Container(child: Row(children: [loanstatus ? Icon(Icons.check, color: Colors.cyan.shade700, weight: 20): Icon(Icons.clear, color: Colors.red.shade400),
                  SizedBox(width: 2,),
                  Text(loanstatus ? '대출가능' : '대출불가', style: TextStyle(color: loanstatus ? Colors.cyan.shade700 : Colors.red.shade400,),),],))
                ],),
              ),
              SizedBox(height: 9,),
              Container(
                width: 230,
                padding: EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '제목 ',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      TextSpan(
                        text: bookTitle,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey.shade900, // 두 번째 텍스트의 글자색
                        ),
                      ),
                      TextSpan(text: '\n'),
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
                    ]
                  ),
                ),
              ),
              SizedBox(height: 1,),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                    margin: EdgeInsets.only(top: 5, right: 8),
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
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                    margin: EdgeInsets.only(top: 5),
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
                ],
              ),
            ],
          )
        ],
      )
    );
  }
}




//1. 체크박스
class LibraryOptions extends StatefulWidget {
  @override
  _LibraryOptionsState createState() => _LibraryOptionsState();
}

class _LibraryOptionsState extends State<LibraryOptions> {
  List<String> libraries = [
    '성동구립', '금호', '용답', '무지개', '성수', '청계', '숲속',
  ];

  Set<String> selectedLibraries = Set<String>.from([
    '성동구립', '금호', '용답', '무지개', '성수', '청계', '숲속',
  ]);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // 가로 간격 설정
      runSpacing: 0.0, // 세로 간격 설정
      children: libraries.map((library) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: selectedLibraries.contains(library),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      selectedLibraries.add(library);
                    } else {
                      selectedLibraries.remove(library);
                    }
                  }
                });
              },
            ),
            Text(library),
          ],
        );
      }).toList(),
    );
  }
}

class SmallLibraryOptions extends StatefulWidget {
  @override
  _SmallLibraryOptionsState createState() => _SmallLibraryOptionsState();
}

class _SmallLibraryOptionsState extends State<SmallLibraryOptions> {
  List<String> libraries = ['왕십리제2동', '마장동', '사근동', '행당제2동',
    '응봉동', '금호1가동', '금호2,3가동', '금호4가동',
    '옥수동', '성수1가제1동', '성수1가제2동', '성수2가제1동',
    '성수2가제3동', '송정동늘푸른', '용답동', '왕십리도선동'
  ];

  Set<String> selectedLibraries = Set<String>();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // 가로 간격 설정
      runSpacing: 0.0, // 세로 간격 설정
      children: libraries.map((library) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: selectedLibraries.contains(library),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      selectedLibraries.add(library);
                    } else {
                      selectedLibraries.remove(library);
                    }
                  }
                });
              },
            ),
            Text(library),
          ],
        );
      }).toList(),
    );
  }
}


