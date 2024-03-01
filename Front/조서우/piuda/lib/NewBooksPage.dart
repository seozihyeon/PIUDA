import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piuda/BookSearch.dart';
import 'package:intl/intl.dart';


class newbookspage extends StatefulWidget {
  const newbookspage({super.key});

  @override
  State<newbookspage> createState() => _newbookspageState();
}

class _newbookspageState extends State<newbookspage> {
  Set<String> _selectedLibrary = {};
  String _selectedSearchTarget = '자료명';
  String _imageUrl = '';
  List<Widget> _newbookWidget = [];
  final List<String> _libraries = ['도서관전체', '성동구립도서관', '금호도서관', '용답도서관', '무지개도서관', '성수도서관', '청계도서관', '숲속도서관',];

  bool isLoading =true;



  void _updateSelectedLibrary(String selectedLibrary) {
    setState(() {
      _selectedLibrary.clear();
      _selectedLibrary.add(selectedLibrary);
      currentPage = 1;
    });

    fetchNewBooks(selectedLibrary, startDate: _startDate, endDate: _endDate);
  }


  @override
  void initState() {
    super.initState();
    fetchNewBooks('도서관전체');

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

  }

  DateTime? _startDate;
  DateTime? _endDate;



  Future<void> fetchNewBooks(String selectedLibrary, {DateTime? startDate, DateTime? endDate}) async {
    try {
      String url = selectedLibrary == '도서관전체'
          ? 'http://10.0.2.2:8080/newbooks/all'
          : 'http://10.0.2.2:8080/newbooks/$selectedLibrary';

      if (startDate != null && endDate != null) {
        // 시작 날짜와 끝나는 날짜가 있는 경우 쿼리 파라미터에 추가
        final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
        final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
        url += '?startDate=$formattedStartDate&endDate=$formattedEndDate';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> newBooksData = jsonDecode(utf8.decode(response.bodyBytes));
        List<BookContainer> newBooks = [];

        setState(() {
          _imageUrl = '';
        });

        for (var bookData in newBooksData) {
          // 책 정보를 BookContainer 위젯으로 변환하여 리스트에 추가
          await fetchBookCover(bookData['book']['book_isbn']);

          newBooks.add(BookContainer(
            book_id: bookData['book']['id'] ?? '',
            imageUrl: _imageUrl,
            bookTitle: bookData['book']['bookTitle'] ?? '',
            author: bookData['book']['author'] ?? '',
            library: bookData['book']['library']?? '',
            publisher: bookData['book']['publisher']?? '',
            location: bookData['book']['location']?? '',
            loanstatus: bookData['book']['loanstatus']?? false,
            book_isbn: bookData['book']['book_isbn']?? '',
            reserved: bookData['book']['reserved']?? false,
            size: bookData['book']['size']?? '',
            price: bookData['book']['price']?? 0,
            classification: bookData['book']['classification']?? '',
            media: bookData['book']['media']?? '',
            field_name: bookData['book']['field_name']?? '',
            book_ii: bookData['book']['book_ii']?? '',
            series: bookData['book']['series']?? '',
            onReservationCompleted: () {
              // 예약이 완료되었을 때 수행할 작업을 여기에 추가
            },
          ));
        }

        setState(() {
          _newbookWidget = newBooks;
        });
      } else {
        print('Failed to fetch new books');
      }
    } catch (e) {
      print('Error fetching new books: $e');
    }
  }


  Widget _buildDateDropdown() {
    return Row(
      children: [
        TextButton(
          onPressed: () => _showDatePicker(context, true),
          child: Text(_startDate != null ? '시작 날짜: ${DateFormat('yyyy-MM-dd').format(_startDate!)}' : '시작 날짜: ${DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day))}'),
        ),
        SizedBox(width: 10),
        TextButton(
          onPressed: () => _showDatePicker(context, false),
          child: Text(_endDate != null ? '끝나는 날짜: ${DateFormat('yyyy-MM-dd').format(_endDate!)}' : '끝나는 날짜: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });

      // 페치 실행
      fetchNewBooks(
        _selectedLibrary.isNotEmpty ? _selectedLibrary.first : '도서관전체',
        startDate: _startDate,
        endDate: _endDate,
      );
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
          '신착자료검색',
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
                                  //controller: _isbnController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none, // 밑줄 제거
                                    // 기타 필요한 데코레이션 설정
                                  ),
                                ),
                              ),
                              GestureDetector(
                                //onTap: searchBook,
                                child: Icon(Icons.search, color: Colors.cyan.shade700),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DropdownButton<String>(
              value: _selectedLibrary.isNotEmpty ? _selectedLibrary.first : '도서관전체',
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _updateSelectedLibrary(newValue);
                }
              },
              items: _libraries.map((String library) {
                return DropdownMenuItem<String>(
                  value: library,
                  child: Text(library),
                );
              }).toList(),
            ),
            _buildDateDropdown(),

            Column(
              children: _newbookWidget,
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


