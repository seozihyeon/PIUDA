import 'package:flutter/material.dart';
import 'main.dart';
import 'LoginPage.dart';

class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  late PageController _pageController;
  int _currentPageIndex = 999;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    setState(() {
      _currentPageIndex = _pageController.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        GestureDetector(
          onTap: () {_goToPreviousPage();
          },
          child: Container(margin: EdgeInsets.only(top: 5),
              height:50, width: screenSize.width * 0.1,
              decoration: BoxDecoration(color: Colors.cyan.shade800, border: Border.symmetric(horizontal: BorderSide(color: Colors.cyan.shade900, width: 2.5))),
              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white)
          ),
        ),
        SizedBox(
          height: 166,
          width: MediaQuery.of(context).size.width * 0.8,
          child: buildPageView(),
        ),
        GestureDetector(
          onTap: () {_goToNextPage();},
          child: Container(margin: EdgeInsets.only(top: 5),
              height:50, width: screenSize.width*0.1,
              decoration: BoxDecoration(color: Colors.cyan.shade800, border: Border.symmetric(horizontal: BorderSide(color: Colors.cyan.shade900, width: 2.5))),
              child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white)
          ),
        ),
      ],
    );
  }

  Widget buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        return buildContent(index % 3 + 1);
      },
      itemCount: 3000, // Set a large number of items to enable infinite scrolling
    );
  }

  Widget buildContent(int pageIndex) {
    Size screenSize = MediaQuery.of(context).size;
    switch (pageIndex) {
      case 1:
        return Container(
          margin: EdgeInsets.only(top: 5, bottom: 3, left: 0.0, right: 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: Colors.cyan.shade900,
              width: 3.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(color: Colors.cyan.shade800, border: Border(bottom: BorderSide(color: Colors.cyan.shade900, width: 2))),
                  width: screenSize.width * 0.8,
                  height: screenSize.height * 0.15,
                  padding: EdgeInsets.only(left: 15),
                  child:
                  (MyApp.isLoggedIn != true)?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("모바일 회원증", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
                      Text("로그인 후 이용 가능한 서비스입니다", style: TextStyle(color: Colors.white, fontSize: 15),)
                    ],
                  )
                      :RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '이름 ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // 첫 번째 텍스트의 글자색
                          ),
                        ),
                        TextSpan(
                          text:MyApp.userName,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white70, // 두 번째 텍스트의 글자색
                          ),
                        ),
                        TextSpan(text: '\n'),
                        TextSpan(
                          text: '회원번호 ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // 세 번째 텍스트의 글자색
                          ),
                        ),
                        TextSpan(
                          text:MyApp.userId.toString(),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white70, // 네 번째 텍스트의 글자색
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                  child: (MyApp.isLoggedIn == true && MyApp.barcodeImageUrl != null) ?
                  Image.network(
                    MyApp.barcodeImageUrl!,
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.contain,
                  )
                      :Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          ).then((result) {
                            // 로그인 페이지에서 반환된 데이터 처리
                            if (result != null && result['isLoggedIn']) {
                              setState(() {
                                MyApp.isLoggedIn = result['isLoggedIn'];
                                MyApp.userName = result['username'];
                                MyApp.userId = result['userId'];
                                // 필요한 경우 여기에서 추가 UI 업데이트 로직을 구현합니다.
                              });
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.cyan.shade900,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.cyan.shade800, width: 1.5),
                          ),
                        ),
                        child: Text('로그인하러 가기', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case 2:
        return Container(
          margin: EdgeInsets.only(top: 5, bottom: 3, left: 0.0, right: 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: Colors.cyan.shade900,
              width: 3.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(color: Colors.cyan.shade800, border: Border(bottom: BorderSide(color: Colors.cyan.shade900, width: 2))),
                  width: screenSize.width * 0.8,
                  height: screenSize.height * 0.15,
                  padding: EdgeInsets.only(left: 15),
                  child:
                  (MyApp.isLoggedIn != true)?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("추천도서", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
                    ],
                  )
                      :RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '이름 ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // 첫 번째 텍스트의 글자색
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                  child: (MyApp.isLoggedIn == true && MyApp.barcodeImageUrl != null) ?
                  Image.network(
                    MyApp.barcodeImageUrl!,
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.contain,
                  )
                      :Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          ).then((result) {
                            // 로그인 페이지에서 반환된 데이터 처리
                            if (result != null && result['isLoggedIn']) {
                              setState(() {
                                MyApp.isLoggedIn = result['isLoggedIn'];
                                MyApp.userName = result['username'];
                                MyApp.userId = result['userId'];
                                // 필요한 경우 여기에서 추가 UI 업데이트 로직을 구현합니다.
                              });
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.cyan.shade900,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.cyan.shade800, width: 1.5),
                          ),
                        ),
                        child: Text('로그인하러 가기', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case 3:
        return Container(
          color: Colors.green,
          child: Center(
            child: Text(
              '세 번째 페이지',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}