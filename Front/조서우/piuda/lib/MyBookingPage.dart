import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'BookDetail.dart';
import 'package:intl/intl.dart';



class UserBooking{
  final int id;
  final User user;
  final Book book;
  final String reserve_date;
  String expectedDate;

  UserBooking({
    required this.id,
    required this.user,
    required this.book,
    required this.reserve_date,
    this.expectedDate = '',
  });
  factory UserBooking.fromJson(Map<String, dynamic> json) {
    return UserBooking(
      id: json['id'] as int? ?? 0,
      user: User.fromJson(json['user'] ?? {}),
      book: Book.fromJson(json['book'] ?? {}),
      reserve_date: json['reserve_date'] as String? ?? '',
    );
  }
}

class User {
  final String name;
  final int id;
  final String status;
  final String barcode;

  User({
    required this.name,
    required this.id,
    required this.status,
    required this.barcode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      barcode: json['barcode'] as String? ?? '',
    );
  }
}

class Book {
  String imageUrl = '';
  final String author;
  final String publisher;
  final String bookIsbn;
  final String fieldName;
  final String bookIi;
  final String library;
  final String location;
  final bool borrowed;
  final bool reserved;
  final String book_id;
  final String size;
  final String title;
  final int price;
  final String media;
  final String? series;
  final String classification;
  final bool loanstatus;

  Book({
    required this.imageUrl,
    required this.author,
    required this.publisher,
    required this.bookIsbn,
    required this.fieldName,
    required this.bookIi,
    required this.library,
    required this.location,
    required this.borrowed,
    required this.reserved,
    required this.book_id,
    required this.size,
    required this.title,
    required this.price,
    required this.media,
    required this.classification,
    required this.series,
    required this.loanstatus,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      imageUrl: '',
      author: json['author'] as String? ?? '',
      publisher: json['publisher'] as String? ?? '',
      bookIsbn: json['book_isbn'] as String? ?? '',
      fieldName: json['field_name'] as String? ?? '',
      bookIi: json['book_ii'] as String? ?? '',
      library: json['library'] as String? ?? '',
      location: json['location'] as String? ?? '',
      borrowed: json['borrowed'] as bool? ?? false,
      reserved: json['reserved'] as bool? ?? false,
      book_id: json['id'] as String? ?? '',
      size: json['size'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: json['price'] as int ?? 0,
      media: json['media'] as String? ?? '',
      series: json['series'] as String?,
      classification: json['classification'] as String? ?? '',
      loanstatus: !json['borrowed'] as bool? ?? false,
    );
  }
}

class BookingList extends StatefulWidget {
  const BookingList({Key? key}) : super(key: key);

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  List<UserBooking> userBooking = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MyApp.userId != null) {
        loadUserBooking();
      }
    });
  }

  Future<void> fetchBookCover(String book_isbn, int index) async {
    final String clientId = 'uFwwNh4yYFgq3WtAYl6S';
    final String clientSecret = 'WElJXwZDhV';

    print('API 요청 시작');

    try {
      final response = await http.get(
        Uri.parse(
            'https://openapi.naver.com/v1/search/book_adv.json?d_isbn=$book_isbn'),
        headers: {
          'X-Naver-Client-Id': clientId,
          'X-Naver-Client-Secret': clientSecret,
        },
      );

      print('API 응답 받음');

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        setState(() {
          userBooking[index].book.imageUrl =
              decodedData['items'][0]['image'] ?? '';
        });
      } else {
        print('Failed to fetch book cover.');
      }
    } catch (e) {
      print('fetchBookCover 함수에서 오류 발생: $e');
    }
  }

  Future<void> loadUserBooking() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    final url = Uri.parse(
        'http://10.0.2.2:8080/api/userbooking/list/${MyApp.userId}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonBody = jsonDecode(decodedBody);
        Iterable jsonList = jsonBody as Iterable;
        List<UserBooking> userBookingData = jsonList.map((userBooking) =>
            UserBooking.fromJson(userBooking)).toList();

        // fetchBookCover 함수를 호출하기 전에 userBooking 상태를 설정합니다.
        setState(() {
          userBooking = userBookingData;
        });

        // 각 예약에 대한 책 표지를 비동기적으로 로드합니다.
        for (int i = 0; i < userBooking.length; i++) {
          await fetchBookCover(userBooking[i].book.bookIsbn, i);
          await getExpectedDate(userBooking[i].book.book_id);
        }

        // 모든 책 표지가 로드되면 로딩 상태를 업데이트합니다.
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user booking.');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // 오류 발생 시 로딩 상태 업데이트
      });
      print('Error loading user booking: $e');
      // 에러 처리: 사용자에게 메시지를 표시하거나 로깅을 수행합니다.
    }
  }

  Future<void> removeUserBooking(int userId, String bookId) async {
    try {
      print('Removing User Booking. User ID: $userId, Book ID: $bookId');

      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8080/api/userbooking/remove/$userId/$bookId'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // 서버에서 성공적으로 응답을 받았을 때의 처리
        print('Book removed from user\'s booking list successfully');

        // 상태를 변경하고 화면을 다시 그리도록 setState 호출
        setState(() {
          userBooking.removeWhere((book) => book.book.book_id == bookId);
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('예약이 취소되었습니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인', style: TextStyle(color: Colors.cyan.shade800),),
                ),
              ],
            );
          },
        );
      } else {
        // 서버에서 오류 응답을 받았을 때의 처리
        print('Failed to remove book from user\'s booking list');
      }
    } catch (e) {
      // 네트워크 오류 등 예외가 발생했을 때의 처리
      print('Error removing booking list: $e');
    }
  }

  Future<void> getExpectedDate(String bookId) async {
    try {
      print('Book ID: $bookId');

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/loan/expected-dates/$bookId'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> expectedDates = jsonDecode(response.body);
        String nearestDate = expectedDates.isNotEmpty ? expectedDates.first : '';

        setState(() {
          for (var booking in userBooking) {
            if (booking.book.book_id == bookId) {
              booking.expectedDate = nearestDate;
            }
          }
        });
      } else {
        print('Failed to load expected date');
      }
    } catch (e) {
      print('Error loading expected date: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          // AppBar 설정은 그대로 유지합니다.
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
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          // AppBar 설정은 그대로 유지합니다.
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
        body: _buildBookingList(),
      );
    }
  }

  Widget _buildBookingList() {
    return userBooking.isEmpty
        ? Center(
      child: Text(
        '예약 도서가 없습니다.',
        style: TextStyle(fontSize: 16),
      ),
    )
        : SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: userBooking.map((booking) {
              return BookingContainer(
                id: booking.id.toString(),
                imageUrl: Image.network(booking.book.imageUrl),
                bookTitle: booking.book.title,
                author: booking.book.author,
                library: booking.book.library,
                location: booking.book.location,
                reserve_date: booking.reserve_date,
                book_isbn: booking.book.bookIsbn,
                booking: booking,
                onRemove: () {
                  removeUserBooking(MyApp.userId ?? 0, booking.book.book_id);
                },
              );
            }).toList(),
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
  final UserBooking booking;

  final VoidCallback onRemove;

  String formatDateString(String dateString) {
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      // 날짜 파싱에 실패할 경우 로그를 출력하고 기본값 반환
      print('Date parsing error: $e');
      return '날짜 정보 없음';
    }
  }



  BookingContainer({
    required this.id,
    required this.imageUrl,
    required this.bookTitle,
    required this.author,
    required this.library,
    required this.location,
    required this.reserve_date,
    required this.book_isbn,
    required this.booking,
    required this.onRemove,

  });


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetail(
              imageUrl: booking.book.imageUrl,
              bookTitle: booking.book.title,
              author: booking.book.author,
              library: booking.book.library,
              location: booking.book.location,
              loanstatus: booking.book.loanstatus,
              book_isbn: booking.book.bookIsbn,
              reserved: booking.book.reserved,
              publisher: booking.book.publisher,
              size: booking.book.size,
              price: booking.book.price,
              classification: booking.book.classification,
              media: booking.book.media,
              field_name: booking.book.fieldName,
              book_id: booking.book.book_id,
              book_ii: booking.book.bookIi,
            ),
          ),
        );
      },
      child: Container(
        width: width * 0.95,
        margin: EdgeInsets.only(bottom: 10),
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
            Container(child: imageUrl, height: height * 0.25 * 0.6),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("상태: 예약", style: TextStyle(color: Colors.cyan.shade800),),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(softWrap: true, text: TextSpan(children: [
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
                                TextSpan(text: '\n'),                                TextSpan(
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
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                if (booking.expectedDate.isNotEmpty) ...[
                                  WidgetSpan(
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '예상도착일 ',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: formatDateString(booking.expectedDate),
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.grey.shade900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 1,),
                                        Tooltip(
                                          message: '실제 도착일과 차이가 있을 수 있습니다.\n도서가 도착하면 알림을 통해 바로 알려드리겠습니다!',
                                          child: Icon(Icons.info_outline, size: 20.0,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
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
                        child: GestureDetector(
                          onTap: onRemove,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(
                                color: Colors.white, // 테두리 색상
                                width: 1.0, // 테두리 두께
                              ),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: Text(
                              '예약 취소',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}