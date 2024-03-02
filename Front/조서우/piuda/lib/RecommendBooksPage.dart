import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piuda/BookSearch.dart';
import 'package:intl/intl.dart';
import 'package:piuda/Utils/BookUtils.dart';
import 'package:piuda/Widgets/bookcontainer_widget.dart';


class recommendbookspage extends StatefulWidget {
  const recommendbookspage({super.key});

  @override
  State<recommendbookspage> createState() => _recommendbookspageState();
}

class _recommendbookspageState extends State<recommendbookspage> {
  String _imageUrl = '';
  List<Widget> _recommendbookWidget = [];
  bool isLoading =true;
  late int _selectedYear;
  late int _selectedMonth;


  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
    fetchRecommendBooks(_selectedYear, _selectedMonth); // 이 부분을 이동
  }

  Future<void> fetchRecommendBooks(selectedYear, selectedMonth) async {
    try {
      String url = 'http://10.0.2.2:8080/recommendbooks/filter?year=$selectedYear&month=$selectedMonth';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> recommendBooksData = jsonDecode(utf8.decode(response.bodyBytes));
        List<BookContainer> recommendBooks = [];

        setState(() {
          _imageUrl = '';
        });

        for (var bookData in recommendBooksData) {
          // 책 정보를 BookContainer 위젯으로 변환하여 리스트에 추가
          String _imageUrl = await BookUtils.fetchBookCover(bookData['book']['book_isbn']);

          recommendBooks.add(BookContainer(
            book_id: bookData['book']['id'] ?? '',
            imageUrl: _imageUrl,
            bookTitle: bookData['book']['title'] ?? '',
            author: bookData['book']['author'] ?? '',
            library: bookData['book']['library']?? '',
            publisher: bookData['book']['publisher']?? '',
            location: bookData['book']['location']?? '',
            loanstatus: !bookData['book']['borrowed'],
            book_isbn: bookData['book']['book_isbn']?? '',
            reserved: bookData['book']['reserved'],
            size: bookData['book']['size']?? '',
            price: bookData['book']['price']?? 0,
            classification: bookData['book']['classification']?? '',
            media: bookData['book']['media']?? '',
            field_name: bookData['book']['field_name']?? '',
            book_ii: bookData['book']['book_ii']?? '',
            series: bookData['book']['series']?? '',
            onReservationCompleted: () {
            },
            recommender: bookData['recommender']?? ''
          ));
        }

        setState(() {
          _recommendbookWidget = recommendBooks;
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
        Text('날짜범위'),
        SizedBox(width: 10),
        DropdownButton<int>(
          value: _selectedYear,
          onChanged: (int? newValue) {
            setState(() {
              _selectedYear = newValue!;
              fetchRecommendBooks(_selectedYear, _selectedMonth);
            });
          },
          items: List.generate(15, (index) {
            return DropdownMenuItem<int>(
              value: 2010 + index,
              child: Text('${2010 + index}년'),
            );
          }),
        ),
        SizedBox(width: 10),
        DropdownButton<int>(
          value: _selectedMonth,
          onChanged: (int? newValue) {
            setState(() {
              _selectedMonth = newValue!;
              fetchRecommendBooks(_selectedYear, _selectedMonth);
            });
          },
          items: List.generate(12, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text('${index + 1}월'),
            );
          }),
        ),
      ],
    );
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
          '사서추천도서',
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
              margin: EdgeInsets.only(left: 9, right: 9, bottom: 9, top: 9),
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: Colors.grey.shade500, // 테두리 색상
                  width: 1.0, // 테두리 두께
                ),
              ),
              child: Column(
                children: [
                  _buildDateDropdown(),
                ],
              ),
            ),

            Column(
              children: _recommendbookWidget,
            ),
            SizedBox(height: 4,)
          ],
        ),
      ),
    );
  }
}



