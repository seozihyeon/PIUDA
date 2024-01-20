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
        title: Text(_isLogin ? '로그인' : '회원가입'),
        backgroundColor: lavender,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLogin) ...[
              TextField(
                controller: _loginUsernameController,
                decoration: InputDecoration(labelText: '아이디',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lavender), // 포커스 시 색상 변경
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _loginPasswordController,
                decoration: InputDecoration(labelText: '비밀번호',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lavender), // 포커스 시 색상 변경
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
                  backgroundColor: MaterialStateProperty.all<Color>(lavender), // 버튼 배경색 변경
                ),
                child: Text('로그인'),
              ),
              SizedBox(height: 12.0),
              Text('아직 계정이 없으신가요?'),
              TextButton(
                onPressed: _showAgreementPage,
                child: Text('회원가입',
                    style: TextStyle(color: lavender),),
              ),
            ] else ...[
              TextField(
                controller: _signupUsernameController,
                decoration: InputDecoration(labelText: '이름'),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _signupEmailController,
                decoration: InputDecoration(labelText: '생년월일'),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _signupPasswordController,
                decoration: InputDecoration(labelText: '휴대폰번호'),
                obscureText: true,
              ),
              SizedBox(height: 10.0),
              TextField(
                decoration: InputDecoration(labelText: '아이디'),
              ),
              SizedBox(height: 10.0),
              TextField(
                decoration: InputDecoration(labelText: '패스워드'),
              ),
              SizedBox(height: 10.0),
              TextField(
                decoration: InputDecoration(labelText: '주소'),
              ),
              SizedBox(height: 10.0),

              DropdownButtonFormField<String>(
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
              SizedBox(height: 10.0),

              // 추가 필드들...
              ElevatedButton(
                onPressed: () {
                  // 새로운 사용자 정보 수집 후 처리
                  _showCompletionPopup(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(lavender), // 버튼 배경색 변경
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
                color: lavender, // 글자색 설정
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
