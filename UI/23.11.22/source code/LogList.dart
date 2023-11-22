import 'package:flutter/material.dart';
import 'main.dart';
import 'package:piuda/LastLog.dart';


class LogList extends StatelessWidget {
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
          '나의 독서 기록장',
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
                        'assets/images/챗gpt.png', // 사진 경로
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
                                  text: '챗GPT 교사 마스터···',
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
                                  text: '한민철',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black, // 네 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(text: '\n'),
                                TextSpan(
                                  text: '출판사 ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(
                                  text: '책바세',
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
                                          ),
                                        ),
                                        TextSpan(
                                          text: '2023.11.12',
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
                      margin: EdgeInsets.only(left: 11, bottom: 121),
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
                        '삭제',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LastLog()),
                  );
                },
                child: Container(
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
                        'assets/images/인간실격.png', // 사진 경로
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
                                  text: '인간 실격',
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
                                  text: '다자이 오사무',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black, // 네 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(text: '\n'),
                                TextSpan(
                                  text: '출판사 ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(
                                  text: '민음사',
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
                                          ),
                                        ),
                                        TextSpan(
                                          text: '2023.11.01',
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
                      margin: EdgeInsets.only(left: 75, bottom: 121),
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
                        '삭제',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ),
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
                        'assets/images/돈의심리학.png', // 사진 경로
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
                                  text: '돈의 심리학',
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
                                  text: '모건 하우절',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black, // 네 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(text: '\n'),
                                TextSpan(
                                  text: '출판사 ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey.shade600, // 세 번째 텍스트의 글자색
                                  ),
                                ),
                                TextSpan(
                                  text: '인플루엔셜',
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
                                          ),
                                        ),
                                        TextSpan(
                                          text: '2023.10.27',
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
                        '삭제',
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