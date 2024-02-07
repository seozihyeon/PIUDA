import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'package:piuda/BookDetail.dart';

class UserInterestBook {
  final int id;
  final User user;
  final Book book;

  UserInterestBook({
    required this.id,
    required this.user,
    required this.book,
  });

  factory UserInterestBook.fromJson(Map<String, dynamic> json) {
    return UserInterestBook(
      id: json['id'] as int? ?? 0,
      user: User.fromJson(json['user'] ?? {}), // User.fromJson으로 변경
      book: Book.fromJson(json['book'] ?? {}), // Book.fromJson으로 변경
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




class MyInterestBooksPage extends StatefulWidget {
  const MyInterestBooksPage({Key? key}) : super(key: key);

  @override
  State<MyInterestBooksPage> createState() => _MyInterestBooksPageState();
}



class _MyInterestBooksPageState extends State<MyInterestBooksPage> {
  List<UserInterestBook> interestBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInterestBooks();
  }

  Future<void> fetchBookCover(String book_isbn, int index) async {

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
          interestBooks[index].book.imageUrl = decodedData['items'][0]['image'] ?? '';
        });
      } else {
        print('Failed to fetch book cover.');
      }
    } catch (e) {
      print('fetchBookCover 함수에서 오류 발생: $e');
    }
  }

  Future<void> loadInterestBooks() async {
    final url = Uri.parse('http://13.210.68.246:8080/api/userinterest/list/${MyApp.userId}');

    try {
      final response = await http.get(url);
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonBody = jsonDecode(decodedBody);

      print("Response status: ${response.statusCode}");
      print("Response body: $decodedBody");

      if (response.statusCode == 200) {
        Iterable jsonList = jsonBody as Iterable;
        List<UserInterestBook> interestBooksData = jsonList.map((
            interestBook) => UserInterestBook.fromJson(interestBook)).toList();

        setState(() {
          interestBooks = interestBooksData;
          print("Updated interest books: $interestBooks");
        });

        for (int i = 0; i < interestBooksData.length; i++) {
          await fetchBookCover(interestBooksData[i].book.bookIsbn, i);
        }
      } else {
        throw Exception('Failed to load interest books');
      }
    } catch (e) {
      print('Error loading interest books: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> removeInterestBook(int userId, String bookId) async {
    try {
      print('Removing interest book. User ID: $userId, Book ID: $bookId');

      final response = await http.delete(
        Uri.parse('http://13.210.68.246:8080/api/userinterest/remove/$userId/$bookId'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // 서버에서 성공적으로 응답을 받았을 때의 처리
        print('Book removed from user\'s interest list successfully');

        // 상태를 변경하고 화면을 다시 그리도록 setState 호출
        setState(() {
          interestBooks.removeWhere((book) => book.book.book_id == bookId);
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('도서가 관심 목록에서 삭제되었습니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      } else {
        // 서버에서 오류 응답을 받았을 때의 처리
        print('Failed to remove book from user\'s interest list');
      }
    } catch (e) {
      // 네트워크 오류 등 예외가 발생했을 때의 처리
      print('Error removing interest book: $e');
    }
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
          '나의 관심 도서',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : interestBooks.isEmpty
          ? Center(
        child: Text(
          '관심도서 목록이 비어있습니다.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        shrinkWrap: true,
        itemCount: interestBooks.length,
        itemBuilder: (context, index) {
          return buildInterestBookItem(index);
        },
      ),
    );
  }



  Widget buildInterestBookItem(int index) {
    if (interestBooks[index].book.imageUrl.isEmpty) {
      fetchBookCover(interestBooks[index].book.bookIsbn, index);
    }

    String loanStatusText = interestBooks[index].book.loanstatus ? '대출가능' : '대출불가';
    String loanStatusBox = interestBooks[index].book.loanstatus ? '책누리신청' : '예약하기';
    Color loanStatusColor = interestBooks[index].book.loanstatus ? Colors.cyan.shade700 : Colors.red.shade400;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookDetail(imageUrl: interestBooks[index].book.imageUrl, bookTitle: interestBooks[index].book.title, author: interestBooks[index].book.author, library: interestBooks[index].book.library, location: interestBooks[index].book.location, loanstatus: interestBooks[index].book.loanstatus, book_isbn: interestBooks[index].book.bookIsbn, reserved: interestBooks[index].book.reserved, publisher: interestBooks[index].book.publisher, size: interestBooks[index].book.size, price: interestBooks[index].book.price, classification: interestBooks[index].book.classification, media: interestBooks[index].book.media, field_name: interestBooks[index].book.fieldName, book_id: interestBooks[index].book.book_id, book_ii: interestBooks[index].book.bookIi)
            )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
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
            Image.network(
              interestBooks[index].book.imageUrl,// 여기에 이미지 URL을 넣어주세요
              height: MediaQuery.of(context).size.height * 0.25 * 0.6,
            ),
            SizedBox(width: 20.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    interestBooks[index].book.loanstatus ? Icon(Icons.check, color: Colors.cyan.shade700, weight: 20) : Icon(Icons.clear, color: Colors.red.shade400),
                    Text(loanStatusText, style: TextStyle(color: loanStatusColor, fontSize: 16, fontWeight: FontWeight.bold,
                    )),
                  ],),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          softWrap: true,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '[' + interestBooks[index].book.library + ']',
                                style: TextStyle(color: Colors.cyan.shade900, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' ' + interestBooks[index].book.title,
                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
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
                                  text: interestBooks[index].book.author,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                TextSpan(text: '\n'),
                                TextSpan(
                                  text: '발행처 ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                TextSpan(
                                  text: interestBooks[index].book.publisher,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
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
                                  text: interestBooks[index].book.location,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            removeInterestBook(MyApp.userId ?? 0, interestBooks[index].book.book_id);
                          },
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
                              '삭제하기',
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