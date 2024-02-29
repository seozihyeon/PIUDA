import 'package:flutter/material.dart';
import 'package:piuda/ReviewBook.dart';
import 'package:piuda/ReviewState.dart';

import 'main.dart';
import 'BookDetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoanBookContainerData {
  final int loan_id;
  String imageUrl;
  final String bookTitle;
  final String author;
  final String library;
  final String loan_date;
  final String? return_date;
  final int? remain_date;
  final String? expect_date;
  final bool returnstatus;
  final String book_isbn;

  LoanBookContainerData({
    required this.loan_id,
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

  static Future<String> fetchBookCover(String bookIsbn) async {
    final String clientId = 'uFwwNh4yYFgq3WtAYl6S';
    final String clientSecret = 'WElJXwZDhV';

    print('API 요청 시작');

    try {
      final response = await http.get(
        Uri.parse('https://openapi.naver.com/v1/search/book_adv.json?d_isbn=$bookIsbn'),
        headers: {
          'X-Naver-Client-Id': clientId,
          'X-Naver-Client-Secret': clientSecret,
        },
      );

      print('API 응답 받음');

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        // 확인을 위해 표지 이미지 URL 출력
        print('이미지 URL: ${decodedData['items'][0]['image']}');

        return decodedData['items'][0]['image'] ?? '';
      } else {
        print('Failed to fetch book cover. Status code: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('fetchBookCover 함수에서 오류 발생: $e');
      return '';
    }
  }

  static String extractDateOnly(String? dateTimeString) {
    if (dateTimeString != null && dateTimeString.isNotEmpty) {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    }
    return '';
  }

  factory LoanBookContainerData.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final book = json['book'];

    return LoanBookContainerData(
      loan_id: json['loan_id'],
      imageUrl: '', // 이미지 URL fetchBookCover 함수로 가져옴
      bookTitle: book['title'],
      author: book['author'],
      library: book['library'],
      loan_date: extractDateOnly(json['loan_date']),
      return_date: extractDateOnly(json['return_date']),
      remain_date: null, // 남은 날짜 정보가 없는 경우 수정 필요
      expect_date: extractDateOnly(json['expect_date']),
      returnstatus: json['return_status'],
      book_isbn: book['book_isbn'],
    );
  }

  Future<void> fetchAndSetImageUrl() async {
    imageUrl = await fetchBookCover(book_isbn);
  }
}




class MyLoanPage extends StatefulWidget {
  const MyLoanPage({super.key});

  @override
  State<MyLoanPage> createState() => _MyLoanPageState();
}


class _MyLoanPageState extends State<MyLoanPage> {
  bool showFirstContent = true;
  ScrollController _pageController = ScrollController();
  List<LoanBookContainerData> loanData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.offset > 500) { // 스크롤 위치가 일정량 이상 내려가면 다음 페이지로 이동
        setState(() {});
      }
    });

    fetchLoanData();
  }


  Future<void> fetchLoanData() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/loan/list/${MyApp.userId}'),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonData = jsonDecode(decodedBody);

        List<LoanBookContainerData> updatedLoanData = [];
        for (final data in jsonData) {
          LoanBookContainerData loanBook = LoanBookContainerData.fromJson(data);

          await loanBook.fetchAndSetImageUrl();

          updatedLoanData.add(loanBook);
        }

        // 정렬을 수행: 가장 최근 대출이 맨 위에 오도록
        updatedLoanData.sort((a, b) {
          DateTime aLoanDate = DateTime.parse(a.loan_date);
          DateTime bLoanDate = DateTime.parse(b.loan_date);
          return bLoanDate.compareTo(aLoanDate);
        });

        setState(() {
          loanData = updatedLoanData;
        });
      } else {
        print('Failed to fetch loan data.');
      }
    } catch (e) {
      print('Error fetching loan data: $e');
      // Handle the error as needed
    } finally {
      setState(() {
        isLoading = false;
      });
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
              isLoading
                  ? Column(
                children: [
                  SizedBox(height: 200,),
                  CircularProgressIndicator(),
                ],
              )
                  : showFirstContent
                  ? FirstContent(pageController: _pageController, loanData: loanData, onLoanExtended: (){fetchLoanData();})
                  : SecondContent(pageController: _pageController, loanData: loanData, onLoanExtended: (){fetchLoanData();},)
            ],
          ),
        ),
      ),
    );
  }
}





class FirstContent extends StatefulWidget {
  final ScrollController pageController;
  final List<LoanBookContainerData> loanData;
  final VoidCallback onLoanExtended;

  FirstContent({required this.pageController, required this.loanData, required this.onLoanExtended,});

  @override
  _FirstContentState createState() => _FirstContentState();
}

class _FirstContentState extends State<FirstContent> {
  List<LoanBookContainerData> get filteredLoanData {
    // Return only items with return_status set to false
    return widget.loanData.where((data) => !data.returnstatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.pageController,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.cyan.shade800, width: 2),
        ),
        child: filteredLoanData.isEmpty // 대출 데이터가 비어 있는 경우
            ? Center(
          heightFactor: MediaQuery.of(context).size.height*0.035,
          child: Text('대출내역이 없습니다'), // 대출내역이 없다는 메시지 표시
        ): Column(
          children: filteredLoanData.map((data) {
            return LoanBookContainer(
              loan_id: data.loan_id,
              imageUrl: data.imageUrl,
              bookTitle: data.bookTitle,
              author: data.author,
              library: data.library,
              loan_date: data.loan_date,
              return_date: data.return_date,
              remain_date: data.remain_date,
              expect_date: data.expect_date,
              returnstatus: data.returnstatus,
              book_isbn: data.book_isbn,
              onLoanExtended: () {
                // Trigger UI update when loan is extended
                widget.onLoanExtended();
                setState(() {});
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}


class SecondContent extends StatefulWidget {
  final ScrollController pageController;
  final List<LoanBookContainerData> loanData;
  final VoidCallback onLoanExtended;

  SecondContent({required this.pageController, required this.loanData,  required this.onLoanExtended,});

  @override
  State<SecondContent> createState() => _SecondContentState();
}

class _SecondContentState extends State<SecondContent> {
  String selectedYear = '2024';

  List<LoanBookContainerData> get filteredLoanDataByYear {
    return widget.loanData.where((data) {
      return data.loan_date != null && data.loan_date!.startsWith(selectedYear);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> years = List.generate(25, (index) => (2024 - index).toString());

    return SingleChildScrollView(
      controller: widget.pageController,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.cyan.shade800, width: 2)),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyan.shade800),
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButton<String>(
                value: selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                    // 선택한 연도에 기반한 추가 작업 수행
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
            SizedBox(height: 10),
            ...filteredLoanDataByYear.map((data) {
              return LoanBookContainer(
                loan_id: data.loan_id,
                imageUrl: data.imageUrl,
                bookTitle: data.bookTitle,
                author: data.author,
                library: data.library,
                loan_date: data.loan_date,
                return_date: data.return_date,
                remain_date: data.remain_date,
                expect_date: data.expect_date,
                returnstatus: data.returnstatus,
                book_isbn: data.book_isbn,
                onLoanExtended: () {
                  // 대출 연장 시 UI 업데이트를 트리거
                  widget.onLoanExtended();
                  setState(() {});
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}






//대출현황: 표지, 제목, 도서관, 대출일자, 반납예정일(남은기간), 반납상태, [[반납연기버튼, 상태평가버튼, 도서리뷰버튼]]
//대출내역: 표지, 제목, 도서관, 대출일자, 반납일자, 반납상태, [[상태평가버튼, 도서리뷰버튼]]
class LoanBookContainer extends StatelessWidget {
  final int loan_id;
  final String imageUrl;
  final String bookTitle;
  final String author;
  final String library;
  final String loan_date;
  final String? return_date;
  int? remain_date; //남은날짜
  final String? expect_date; //반납예정일
  final bool returnstatus; //반납상태 t-반납완료, f-대출중
  final String book_isbn;
  final VoidCallback? onLoanExtended;


  LoanBookContainer({
    required this.loan_id,
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
    required this.onLoanExtended,

  }) {
    remain_date = calculateRemainingDays();
  }

  int calculateRemainingDays() {
    if (expect_date != null && loan_date.isNotEmpty) {
      DateTime expectDate = DateTime.parse(expect_date!);
      DateTime loanDate = DateTime.parse(loan_date);

      Duration difference = expectDate.difference(loanDate);

      return difference.inDays;
    }
    return 0; // Default value when either expect_date is null or loan_date is empty
  }

  void extendLoan(int? loanId, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8080/loan/extend/$loanId'),
      );

      if (response.statusCode == 200) {
        print('성공적으로 연장되었습니다');
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            content: Text('대출도서가 성공적으로 연장되었습니다.'),
            actions: [TextButton(onPressed: () {Navigator.of(context).pop();},child: Text('확인',  style: TextStyle(color: Colors.cyan.shade800)),),],);},);

        onLoanExtended?.call();
      } else {
        print('Failed to extend the loan. Status code: ${response.statusCode}');

        // Handling different messages from the API
        if (response.body == "대출은 한 번만 연장할 수 있습니다!") {
          print("대출은 한 번만 연장할 수 있습니다!");
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              content: Text('대출도서는 한 번만 연장할 수 있습니다.'),
              actions: [TextButton(onPressed: () {Navigator.of(context).pop();},child: Text('확인',  style: TextStyle(color: Colors.cyan.shade800)),),],);},);
        } else if (response.body == "대출 당일은 연장할 수 없습니다!") {
          print("대출 당일은 연장할 수 없습니다!");
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              content: Text('대출 당일은 연장할 수 없습니다.'),
              actions: [TextButton(onPressed: () {Navigator.of(context).pop();},child: Text('확인',  style: TextStyle(color: Colors.cyan.shade800)),),],);},);
        } else if (response.body == "반납예정일 이후에는 연장할 수 없습니다!") {
          print("반납예정일 이후에는 연장할 수 없습니다!");
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              content: Text('반납예정일 이후에는 연장할 수 없습니다.'),
              actions: [TextButton(onPressed: () {Navigator.of(context).pop();},child: Text('확인',  style: TextStyle(color: Colors.cyan.shade800)),),],);},);
        } else {
          print('Unknown error: ${response.body}');
        }
      }
    } catch (e) {
      print('Error extending loan: $e');
    }
  }

  //도서리뷰 중복체크
  void onReviewButtonPressed(BuildContext context) async {
    try {
      int userId = MyApp.userId ?? 0;
      print('Checking review status for ISBN: $book_isbn and UserID: $userId');
      bool hasReviewed = await checkIfUserReviewed(book_isbn, userId);
      if (hasReviewed) {
        print('User already reviewed this book');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('이미 리뷰 작성을 완료한 도서입니다.'),
              actions: <Widget>[TextButton(onPressed: () {Navigator.of(context).pop();}, child: Text('확인', style: TextStyle(color: Colors.cyan.shade800)),
                ),
              ],
            );
          },
        );
      } else {
        print('Navigating to review page');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookReview(
              bookTitle: bookTitle,
              bookIsbn: book_isbn,
              bookAuthor: author,
              imageUrl: imageUrl,
              loanId: loan_id,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error while checking review status: $e');
    }
  }

  Future<bool> checkIfUserReviewed(String isbn, int userId) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/review/check/review/$userId/$isbn');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body) as bool;
      } else {
        throw Exception('Failed to check if user reviewed');
      }
    } catch (e) {
      throw Exception('Error occurred while checking if user reviewed: $e');
    }
  }



  Future<bool> checkReviewStatus(int loanId) async {
    try {
      // 서버로부터 리뷰 상태를 확인하는 API 호출
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/reviewCondition/check/$loanId'),
      );

      if (response.statusCode == 200) {
        // 리뷰 조건이 없는 경우 (리뷰를 작성한 적이 없음)
        return false;
      } else if (response.body == "이미 작성한 상태평가 입니다") {
        // 리뷰 조건이 이미 존재하는 경우 (리뷰를 이미 작성함)
        return true;
      } else {
        // 다른 예외 상황에 대한 처리
        print('Failed to check review condition. Status code: ${response.statusCode}');
        return false; // 혹은 예외 처리에 맞게 반환값 설정
      }
    } catch (e) {
      // 에러 발생 시 처리
      print('Error checking review condition: $e');
      return false; // 혹은 예외 처리에 맞게 반환값 설정
    }
  }

  Future<bool> check30Status(int loanId) async {
    try {
      // 서버로부터 리뷰 상태를 확인하는 API 호출
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/reviewCondition/check/$loanId'),
      );

      if (response.statusCode == 200) {
        return false;
      } else if (response.body == "상태평가는 반납일로부터 30일 이내에만 작성 가능합니다") {
        return true;
      } else {
        print('Failed to check review condition. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error checking review condition: $e');
      return false;
    }
  }


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
            Container(
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl, // Use the imageUrl here
                height: Height * 0.25 * 0.6,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  print('Error building image: $error');
                  return Placeholder(); // 에러 발생 시 Placeholder 표시
                },
              )
                  : Placeholder(), // 이미지가 없을 경우 Placeholder 표시
            ),
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
                            child: Text('D-' + (remain_date.toString() ?? ''), style: TextStyle(fontWeight: FontWeight.w700),)
                        )
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
                          child: GestureDetector(
                            onTap: () {
                              extendLoan(loan_id, context);
                            },
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
                        ),
                      ],
                    ),
                  SizedBox(height: 3,),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onReviewButtonPressed(context), // 이벤트 연결
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
                          onTap: () async {
                            bool hasReviewed = await checkReviewStatus(loan_id);
                            bool out30 = await check30Status(loan_id);

                            if (hasReviewed) {
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text('이미 상태 평가를 완료한 도서입니다.'),
                                  actions: [TextButton(onPressed: () {Navigator.of(context).pop();},child: Text('확인',  style: TextStyle(color: Colors.cyan.shade800)),),],);},);
                            } else if (out30) {
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text('상태평가는 반납일로부터 30일 이내에만 작성 가능합니다.'),
                                  actions: [TextButton(onPressed: () {Navigator.of(context).pop();},child: Text('확인',  style: TextStyle(color: Colors.cyan.shade800)),),],);},);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookStateReview(
                                    loan_id: loan_id,
                                    imageUrl: imageUrl,
                                    bookTitle: bookTitle,
                                    author: author,
                                    library: library,
                                    book_isbn: book_isbn,
                                  ),
                                ),
                              );
                            }
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