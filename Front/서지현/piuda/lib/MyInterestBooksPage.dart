import 'package:flutter/material.dart';
import 'main.dart';

class MyInterestBooksPage extends StatelessWidget {
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
          '나의 관심 도서',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black, // 글자색 설정
          ),
        ),
        backgroundColor: Colors.white,
      ),


      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 170.0,
                width: 650.0,
                margin: EdgeInsets.only(top:16, bottom: 16, left: 16, right: 16),
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
                      child: Image.asset(
                        'assets/images/그대.jpg', // 사진 경로
                        fit: BoxFit.cover, // 사진의 크기 조절 방식
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '제목 ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey.shade600, // 첫 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(
                                  text: '그대 눈동자에 건배',
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
                                  text: '히가시노 게이고',
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
                                  text: '무지개 도서관',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black, // 네 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(text: '\n'),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // '대출 페이지로 이동'
                              },
                              child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                                  margin: EdgeInsets.only(top: 5, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    border: Border.all(
                                      color: Colors.grey.shade800, // 테두리 색상
                                      width: 1.0, // 테두리 두께
                                    ),
                                    borderRadius: BorderRadius.circular(2.0), // 테두리의 모서리를 둥글게 만듭니다.
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                            child: Icon(Icons.check, color: Colors.cyan.shade700, weight: 20),
                                          ),
                                        ),
                                        TextSpan(
                                          text: '대출가능',
                                          style: TextStyle(fontSize: 18, color: Colors.cyan.shade700, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 27, bottom: 121),
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1
                              )
                          )
                      ),
                      child: Text(
                        '해제',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 170.0,
                width: 650.0,
                margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
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
                      child: Image.asset(
                        'assets/images/모모.jpg', // 사진 경로
                        fit: BoxFit.cover, // 사진의 크기 조절 방식
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '제목 ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey.shade600, // 첫 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(
                                  text: '모모',
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
                                  text: '미하엘 엔데',
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
                                  text: '용답도서관',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black, // 네 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(text: '\n'),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // '대출 페이지로 이동'
                              },
                              child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                                  margin: EdgeInsets.only(top: 5, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    border: Border.all(
                                      color: Colors.grey.shade800, // 테두리 색상
                                      width: 1.0, // 테두리 두께
                                    ),
                                    borderRadius: BorderRadius.circular(2.0), // 테두리의 모서리를 둥글게 만듭니다.
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                            child: Icon(Icons.clear, color: Colors.red.shade400),
                                          ),
                                        ),
                                        TextSpan(
                                          text: '대출불가',
                                          style: TextStyle(fontSize: 18, color: Colors.red.shade400, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70, bottom: 121),
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1
                              )
                          )
                      ),
                      child: Text(
                        '해제',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}