import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BookSearch extends StatefulWidget {
  final String searchText;
  final Set<String> searchOptions;
  final String iniimageUrl;
  final String searchTarget;
  final Set<String> selectedLibraries;

  BookSearch({required this.iniimageUrl,
    required this.searchText,
    required this.searchOptions,
    required this.searchTarget,
    required this. selectedLibraries});

  @override
  _BookSearchState createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  String _selectedSearchTarget = '자료명';
  Set<String> selectedOptions = Set<String>();
  TextEditingController _isbnController;

  _BookSearchState() : _isbnController = TextEditingController(); // 생성자에서 초기화


  @override
  void initState() {
    super.initState();
    _selectedSearchTarget = widget.searchTarget;
    _isbnController.text = widget.searchText; // 검색어 설정
    selectedOptions = widget.searchOptions; // 검색 옵션 설정
    searchBook(); // 페이지가 로드될 때 자동으로 검색 수행
  }

  //
  String _imageUrl = '';

// _BookSearchState 클래스 내부에 추가할 상태 변수
  List<Widget> _bookWidgets = [];

// searchBook 함수
  Future<void> searchBook() async {
    try {
      print("searchBook 함수 호출됨");
      final String searchText = _isbnController.text;
      print("검색어: $searchText");

      String url;
      if (_selectedSearchTarget == '자료명') {
        url = 'http://10.0.2.2:8080/api/books/search?title=$searchText';
      } else if (_selectedSearchTarget == '저자명') {
        url = 'http://10.0.2.2:8080/api/books/search?author=$searchText';
      } else { // '발행처' 선택 시
        url = 'http://10.0.2.2:8080/api/books/search?publisher=$searchText';
      }

      final response = await http.get(Uri.parse(url));


      print('Response status: ${response.statusCode}');
      final decodedResponse = utf8.decode(response.bodyBytes);
      print('Decoded response: $decodedResponse');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(decodedResponse);
        if (responseData.isNotEmpty) {
          List<Widget> bookWidgets = []; // 책 데이터를 위한 위젯 리스트
          for (var i = 0; i < responseData.length; i++) {
            final bookData = responseData[i];
            final book_isbn = bookData['book_isbn'] as String? ?? '9788901241760';

            print('ISBN: $book_isbn');

            setState(() {
              _imageUrl = '';
            });
            await fetchBookCover(book_isbn);

            final bookWidget = BookContainer(
              imageUrl: _imageUrl.isNotEmpty ? _imageUrl : widget.iniimageUrl,
              bookTitle: bookData['title'] as String? ?? '제목 없음',
              author: bookData['author'] as String? ?? '저자 없음',
              library: bookData['library'] as String? ?? '도서관 없음',// 예시 값, 실제 값으로 대체 필요
              publisher: bookData['publisher'] as String? ?? '출판사 없음',
              location: bookData['location'] as String? ?? '자료위치 없음', // 예시 값, 실제 값으로 대체 필요
              loanstatus: false, // 예시 값, 실제 값으로 대체 필요
              book_isbn: book_isbn
            );
            bookWidgets.add(bookWidget);
          }
          setState(() {
            _bookWidgets = bookWidgets;
          });
        } else {
          print('검색 결과가 없습니다.');
        }
      } else {
        print('Failed to fetch book data.');
      }
    } catch (e) {
      print('searchBook 함수에서 오류 발생: $e');
    }
  }

  Future<void> fetchBookCover(String book_isbn) async {
    final String clientId = 'uFwwNh4yYFgq3WtAYl6S';
    final String clientSecret = 'WElJXwZDhV';

    print('API 요청 시작');

    try {
      final response = await http.get(
        Uri.parse('https://openapi.naver.com/v1/search/book_adv.json?d_isbn=$book_isbn'),
        headers: {
          'X-Naver-Client-Id': clientId,
          'X-Naver-Client-Secret': clientSecret,
        },
      );

      print('API 응답 받음');

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        setState(() {
          _imageUrl = decodedData['items'][0]['image'] ?? ''; // 이미지 URL을 상태로 설정
        });
      } else {
        setState(() {
          _imageUrl = '';
        });
        print('Failed to fetch book data.');
      }
    } catch (e) {
      print('fetchBookCover 함수에서 오류 발생: $e');
    }
  }

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
          color: Colors.black,
        ),
        title: Text(
          '통합자료검색',
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
                                onTap: searchBook,
                                child: Icon(Icons.search, color: Colors.cyan.shade700),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //도서관 체크박스 컨테이너
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


            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // 스크롤 가능성 제거
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

//책 정보박스
//책 정보박스
class BookContainer extends StatelessWidget {
  final String imageUrl;
  final String bookTitle;
  final String author;
  final String library;
  final String publisher;
  final String location;
  final bool loanstatus;
  final String book_isbn;

  BookContainer({
    required this.imageUrl,
    required this.bookTitle,
    required this.author,
    required this.library,
    required this.publisher,
    required this.location,
    required this.loanstatus,
    required this.book_isbn,
  });

  @override
  Widget build(BuildContext context) {
    String loanStatusText = loanstatus ? '대출가능' : '대출불가';
    String loanStatusBox = loanstatus ? '책누리신청' : '예약하기';
    Color loanStatusColor = loanstatus ? Colors.blue.shade300 : Colors.red.shade300;

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
            Image.network(imageUrl, height: Height*0.25*0.6
            ),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [loanstatus ? Icon(Icons.check, color: Colors.cyan.shade700, weight: 20): Icon(Icons.clear, color: Colors.red.shade400),
                    Text(loanstatus ? '대출가능' : '대출불가', style: TextStyle(color: loanstatus ? Colors.cyan.shade700 : Colors.red.shade400, fontSize: 16),),],),
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
                                    text: author,
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
                                    text: publisher,
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
                      SizedBox(width: 10,),
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

