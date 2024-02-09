import 'package:flutter/material.dart';
import 'package:piuda/MyInterestBooksPage.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'BookDetail.dart';
import 'LoginPage.dart';


class BookSearch extends StatefulWidget {
  final String searchText;
  final Set<String> searchOptions;
  final String iniimageUrl;
  final String searchTarget;

  BookSearch({required this.iniimageUrl,
    required this.searchText,
    required this.searchOptions,
    required this.searchTarget,
  });

  @override
  _BookSearchState createState() => _BookSearchState();
}



class _BookSearchState extends State<BookSearch> {
  Set<String> _selectedLibraries = {};
  String _selectedSearchTarget = '자료명';
  Set<String> selectedOptions = Set<String>();
  TextEditingController _isbnController;

  String _imageUrl = '';
  List<Widget> _bookWidgets = [];

  _BookSearchState() : _isbnController = TextEditingController(); // 생성자에서 초기화
  bool isLoading =true;

  void _updateSelectedLibraries(Set<String> selected) {
    setState(() {
      _selectedLibraries = selected;
      currentPage = 1;
    });
    searchBook();
  }


  @override
  void initState() {
    super.initState();
    _selectedSearchTarget = widget.searchTarget;
    _isbnController.text = widget.searchText;
    selectedOptions = widget.searchOptions;
    searchBook();

    // _scrollController를 초기화
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  int currentPage = 1;
  int pageSize = 4;
  bool hasMoreData = true;
  late ScrollController _scrollController;
  int totalPages = 1;


  int calculateTotalPages(http.Response response) {
    final totalHeader = response.headers['total-pages'];
    if (totalHeader != null) {
      final totalPages = int.tryParse(totalHeader);
      print('total-pages header value: $totalPages');
      return totalPages ?? 1;
    } else {
      print('total-pages header not found');
      return 1;
    }
  }

  void _scrollListener() {
    print("Current Page: $currentPage, Total Pages: $totalPages");
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (hasMoreData && currentPage < totalPages) {
        goToPage(currentPage + 1);
      }
    } else {
      // 페이지 수가 변경될 때 현재 페이지가 총 페이지 수를 초과하지 않도록 조정
      if (currentPage > totalPages) {
        goToPage(totalPages);
      }
    }
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) {
      return;
    }

    setState(() {
      currentPage = page;
    });

    searchBook();
  }


  // searchBook 함수
  Future<void> searchBook() async {
    if (_isbnController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("검색어를 입력하세요"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final String searchText = _isbnController.text;
      print("검색어: $searchText");

      String url;
      if (_selectedSearchTarget == '자료명') {
        url = 'http://10.0.2.2:8080/api/books/search?title=$searchText&page=$currentPage';
      } else if (_selectedSearchTarget == '저자명') {
        url = 'http://10.0.2.2:8080/api/books/search?author=$searchText&page=$currentPage';
      } else {
        url = 'http://10.0.2.2:8080/api/books/search?publisher=$searchText&page=$currentPage';
      }

      if (pageSize > 0) {
        url += '&pageSize=$pageSize';
      }

      // 도서관 정보를 추가
      if (_selectedLibraries.isNotEmpty) {
        final selectedLibrariesQueryParam = _selectedLibraries.join(',');
        url += '&libraries=$selectedLibrariesQueryParam';
      }

      final response = await http.get(Uri.parse(url));


      print('Response status: ${response.statusCode}');
      final decodedResponse = utf8.decode(response.bodyBytes);
      print('Decoded response: $decodedResponse');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(decodedResponse);

        totalPages = calculateTotalPages(response); // 실제로는 서버 응답에서 페이지 정보를 추출하여 계산해야 합니다.

        if (responseData.isEmpty) { // 더 이상 가져올 데이터가 없음
          setState(() {
            hasMoreData = false;
          });
        }
        final filteredData = responseData.where((bookData) {
          if (_selectedLibraries.isEmpty) {
            return true;
          }
          return _selectedLibraries.any((selectedLibrary) =>
              (bookData['library'] as String).contains(selectedLibrary));
        }).toList();
        if (filteredData.isNotEmpty) {
          List<Widget> bookWidgets = []; // 책 데이터를 위한 위젯 리스트
          for (var bookData in filteredData) {
            final book_isbn = bookData['book_isbn'] as String? ?? '9788901241760';

            print('ISBN: $book_isbn');

            setState(() {
              _imageUrl = '';
            });
            await fetchBookCover(book_isbn);

            final bookWidget = BookContainer(
              imageUrl: _imageUrl.isNotEmpty ? _imageUrl : widget.iniimageUrl,
              book_id: bookData['id'] as String? ?? '등록번호 없음',
              book_ii : bookData['book_ii'] as String? ?? '청구기호 없음',
              bookTitle: bookData['title'] as String? ?? '제목 없음',
              author: bookData['author'] as String? ?? '저자 없음',
              library: bookData['library'] as String? ?? '도서관 없음',// 예시 값, 실제 값으로 대체 필요
              publisher: bookData['publisher'] as String? ?? '출판사 없음',
              location: bookData['location'] as String? ?? '자료위치 없음', // 예시 값, 실제 값으로 대체 필요
              loanstatus: !bookData['borrowed'] as bool? ?? false, // 예시 값, 실제 값으로 대체 필요
              book_isbn: book_isbn,
              reserved: bookData['reserved'] as bool? ?? false,
              size: bookData['size'] as String? ?? '형태사항 없음',
              price: bookData['price'] as int ?? 0,
              classification: bookData['classification'] as String ?? '분류기호 없음',
              media: bookData['media'] as String ?? '매체구분 없음',
              field_name: bookData['field_name'] as String? ?? '분야 없음',
              series: bookData['series'] as String?,
              onReservationCompleted: () => searchBook(),

            );
            bookWidgets.add(bookWidget);
          }
          setState(() {
            _bookWidgets = bookWidgets;
          });
        } else {
          // 검색 결과가 없을 때 메시지를 표시하는 위젯을 추가
          setState(() {
            _bookWidgets = [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '검색 결과가 없습니다',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              )
            ];
          });
        }
      }
      else {
        print('Failed to fetch book data.');
      }
    } catch (e) {
      print('searchBook 함수에서 오류 발생: $e');
    } finally {
      setState(() {
        isLoading = false; // 로딩 종료
      });
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
                        LibraryOptions(_updateSelectedLibraries),

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
            isLoading
                ? Container(height: MediaQuery.of(context).size.height * 0.7, child: Center(child: CircularProgressIndicator()))
                : ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: _bookWidgets.length,
              itemBuilder: (context, index) {
                return _bookWidgets[index];
              },
            ),

            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentPage > 1)
                    ElevatedButton(
                      onPressed: () => goToPage(currentPage - 1),
                      child: Text('이전'),
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
                    ),
                  for (int i = 1; i <= totalPages; i++)
                    if (i >= (currentPage - 1) ~/ 3 * 3 + 1 && i <= (currentPage - 1) ~/ 3 * 3 + 3)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () => goToPage(i),
                          child: Text('$i'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: i == currentPage ? Colors.white : Colors.black,
                            backgroundColor: i == currentPage ? Colors.cyan.shade700 : null,
                          ),
                        ),
                      ),
                  if (currentPage < totalPages)
                    ElevatedButton(
                      onPressed: () => goToPage(currentPage + 1),
                      child: Text('다음'),
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
                    ),
                ],
              ),
            ),
            SizedBox(height: 4,)
          ],
        ),
      ),
    );
  }
}


//책 정보박스
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

  });


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
                  child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
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
                  child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
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
                      child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
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
                      onReservationCompleted?.call();
                    },
                    child: Text('확인',  style: TextStyle(color: Colors.cyan.shade800)),
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
                    child: Text('확인',  style: TextStyle(color: Colors.cyan.shade800)),
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
                  child: Text('확인',  style: TextStyle(color: Colors.cyan.shade800)),
                ),
              ],
            );
          },
        );
      }
    }}



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
              imageUrl: imageUrl,
              bookTitle: bookTitle,
              author: author,
              library: library,
              publisher: publisher,
              location: location,
              loanstatus: loanstatus,
              book_isbn: book_isbn,
              reserved: reserved,
              size: size,
              price: price,
              classification: classification,
              media: media,
              field_name: field_name,
              book_ii: book_ii,
              series: series,
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
                        GestureDetector(
                          onTap: () {
                            addInterestBook(context, MyApp.userId ?? 0, book_id.toString());
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
                        if (!loanstatus && !reserved)
                          GestureDetector(
                            onTap: () {
                              reserveBook(context, MyApp.userId.toString(), book_id);
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
    );
  }
}




//도서관 체크박스
class LibraryOptions extends StatefulWidget {

  final Function(Set<String>) onSelectedLibrariesChanged;

  LibraryOptions(this.onSelectedLibrariesChanged);
  _LibraryOptionsState createState() => _LibraryOptionsState();
}

class _LibraryOptionsState extends State<LibraryOptions> {

  final List<String> libraries = ['성동구립도서관', '금호도서관', '용답도서관', '무지개도서관', '성수도서관', '청계도서관', '숲속도서관',];
  Set<String> selectedLibraries = Set<String>.from([
    '성동구립도서관', '금호도서관', '용답도서관', '무지개도서관', '성수도서관', '청계도서관', '숲속도서관',
  ]);

  void _onCheckboxChanged(bool? value, String libraryName) {
    if (value == true) {
      selectedLibraries.add(libraryName);
    } else {
      selectedLibraries.remove(libraryName);
    }
    widget.onSelectedLibrariesChanged(selectedLibraries);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(right: 10),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 0.0,
        children: libraries.map((library) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                checkColor: Colors.white, // 체크 표시 색상은 항상 흰색
                fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Color(0xFF00838F); // 선택됐을 때 배경색 cyan 800
                  }
                  return Colors.white; // 선택되지 않았을 때 배경색 흰색
                }),
                side: BorderSide(color: Color(0xFF00838F), width: 1.0), // 모든 상태에서 테두리 색상 cyan 800
                value: selectedLibraries.contains(library),
                onChanged: (bool? value) {
                  _onCheckboxChanged(value, library);
                },
              ),

              Text(library),
            ],
          );
        }).toList(),
      ),
    );
  }
}


//작은도서관 체크박스
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
    double screenWidth = MediaQuery.of(context).size.width;
    return
      Padding(padding:EdgeInsets.only(right: 10),
        child: Wrap(
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
        ),
      );
  }
}