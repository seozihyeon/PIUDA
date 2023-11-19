import 'package:flutter/material.dart';
import 'Agreement.dart';
import 'main.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<bool> AgreeList = List.filled(5, false);

  TextEditingController _loginUsernameController = TextEditingController();
  TextEditingController _loginPasswordController = TextEditingController();
  TextEditingController _signupUsernameController = TextEditingController();
  TextEditingController _signupEmailController = TextEditingController();
  TextEditingController _signupPasswordController = TextEditingController();

  bool _isLogin = true;
  String? _selectedLibrary; // 추가: 선택한 도서관 저장

  // 새로운 함수: 도서관 선택
  void _selectLibrary(String? value) {
    setState(() {
      _selectedLibrary = value;
    });
  }

  void _showAgreementPage() async {
    final List<bool>? agreedList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgreementPage(agreeList: AgreeList),
      ),
    );

    if (agreedList != null) {
      setState(() {
        AgreeList = agreedList;
        _isLogin = false; // 약관 동의 후에 회원가입 창 보여주기
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
            // 뒤로가기 동작
            Navigator.pop(context);
          },
          color: Colors.white, // 뒤로가기 버튼의 색상
        ),
        title: Text(_isLogin ? '' : '회원가입',
          style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.cyan.shade700,
      ),


      body: Stack(
        children: [
          Positioned(
            top: 0, right: 0, left: 0,
            child: Container(
              height: 270,
              decoration: BoxDecoration(
                color: Colors.cyan.shade700,
              ),
              child: Container(
                padding: EdgeInsets.only(top: 40, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '성동라이브러리',
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '우리도서관에 방문하신것을 진심으로 환영합니다.',
                      style: TextStyle(color: Colors.white) ,)
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.white, // 테두리 색상
                    width: 2.0, // 테두리 두께
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // 그림자 색상 및 투명도
                      spreadRadius: 5, // 그림자 확산 범위
                      blurRadius: 15, // 그림자 흐림 정도
                      offset: Offset(0, 3),
                    )
                  ]
              ),
              margin: EdgeInsets.only(top: 120, left: 30, right: 30),
              padding: EdgeInsets.only(top: 10, bottom: 0, left: 24, right: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (_isLogin) ...[
                      TextField(
                        controller: _loginUsernameController,
                        decoration: InputDecoration(labelText: '아이디',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue), // 포커스 시 색상 변경
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextField(
                        controller: _loginPasswordController,
                        decoration: InputDecoration(labelText: '비밀번호',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue), // 포커스 시 색상 변경
                          ),),
                        obscureText: true,
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          String username = _loginUsernameController.text;
                          String password = _loginPasswordController.text;

                          print('아이디: $username, 비밀번호: $password');

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black54), // 버튼 배경색 변경
                        ),
                        child: Text('로그인',
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 12.0),
                      Text('아직 도서관 회원이 아니신가요?'),
                      TextButton(
                        onPressed: _showAgreementPage,
                        child: Text('회원가입',
                          style: TextStyle(color: Colors.cyan.shade800),),
                      ),
                    ] else ...[
                      TextField(
                        controller: _signupUsernameController,
                        decoration: InputDecoration(
                          hintText: '이름',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // 밑줄 색상 설정
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      TextField(
                        controller: _signupEmailController,
                        decoration: InputDecoration(
                          hintText: '생년월일',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // 밑줄 색상 설정
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      TextField(
                        controller: _signupPasswordController,
                        decoration: InputDecoration(
                          hintText: '휴대전화번호',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // 밑줄 색상 설정
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 5.0),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '아이디',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // 밑줄 색상 설정
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '비밀번호',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // 밑줄 색상 설정
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '주소',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // 밑줄 색상 설정
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),

                      Container(
                        height: 60,
                        child: DropdownButtonFormField<String>(
                          value: _selectedLibrary,
                          items: [
                            '성동구립도서관',
                            '금호도서관',
                            '용답도서관',
                            '무지개도서관',
                            '성수도서관',
                            '청계도서관',
                            '숲속도서관',
                            '스마트도서관',
                            '작은도서관',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            _selectLibrary(newValue);
                          },
                          decoration: InputDecoration(
                            labelText: '도서관 선택',


                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),

                      // 추가 필드들...
                      ElevatedButton(
                        onPressed: () {
                          // 새로운 사용자 정보 수집 후 처리
                          _showCompletionPopup(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black54), // 버튼 배경색 변경
                        ),
                        child: Text('회원가입'),
                      ),
                      SizedBox(height: 11.0),
                      // Text('이미 계정이 있으신가요?'),
                      // TextButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       _isLogin = true;
                      //     });
                      //   },
                      //   child: Text('로그인'),
                      // ),
                    ],
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}

void _showCompletionPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('회원가입 완료'),
        content: Text('성동구립 통합 도서관 서비스 회원 가입이 완료되었습니다.'),
        actions: <Widget>[
          TextButton(
            child: Text('로그인 하러 가기',
              style: TextStyle(
                color: Colors.cyan.shade700, // 글자색 설정
              ),
            ),
            onPressed: () {
              Navigator.push(
                dialogContext,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      );
    },
  );
}