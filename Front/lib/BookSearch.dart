import 'package:flutter/material.dart';
import 'package:piuda/MyInterestBooksPage.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'BookDetail.dart';
import 'LoginPage.dart';
import 'Utils/BookUtils.dart';
import 'package:piuda/Widgets/bookcontainer_widget.dart';


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
  int pageSize = 10;
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
        url = 'http://34.64.173.65:8080/api/books/search?title=$searchText&page=$currentPage';
      } else if (_selectedSearchTarget == '저자명') {
        url = 'http://34.64.173.65:8080/api/books/search?author=$searchText&page=$currentPage';
      } else {
        url = 'http://34.64.173.65:8080/api/books/search?publisher=$searchText&page=$currentPage';
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
            String _imageUrl = await BookUtils.fetchBookCover(book_isbn);


            print('ISBN: $book_isbn');

            setState(() {
              _imageUrl = _imageUrl;
            });

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
              recommender: null,
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
                                  decoration: InputDecoration(
                                    border: InputBorder.none, // 밑줄 제거
                                    // 기타 필요한 데코레이션 설정
                                  ),
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