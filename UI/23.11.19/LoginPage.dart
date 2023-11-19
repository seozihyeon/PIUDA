import 'package:flutter/material.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _loginUsernameController = TextEditingController();
  TextEditingController _loginPasswordController = TextEditingController();
  TextEditingController _signupUsernameController = TextEditingController();
  TextEditingController _signupEmailController = TextEditingController();
  TextEditingController _signupPasswordController = TextEditingController();

  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? '로그인' : '회원가입'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLogin) ...[
              TextField(
                controller: _loginUsernameController,
                decoration: InputDecoration(labelText: '아이디'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _loginPasswordController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // 로그인 버튼이 눌렸을 때 수행할 동작을 여기에 추가
                  String username = _loginUsernameController.text;
                  String password = _loginPasswordController.text;

                  // 예: 실제 로그인 로직은 여기에 구현
                  print('아이디: $username, 비밀번호: $password');

                  // 로그인 후 메인 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text('로그인'),
              ),
              SizedBox(height: 12.0),
              Text('아직 계정이 없으신가요?'),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = false;
                  });
                },
                child: Text('회원가입'),
              ),
            ] else ...[
              TextField(
                controller: _signupUsernameController,
                decoration: InputDecoration(labelText: '아이디'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _signupEmailController,
                decoration: InputDecoration(labelText: '이메일'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _signupPasswordController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // 회원가입 버튼이 눌렸을 때 수행할 동작을 여기에 추가
                  String username = _signupUsernameController.text;
                  String email = _signupEmailController.text;
                  String password = _signupPasswordController.text;

                  // 예: 실제 회원가입 로직은 여기에 구현
                  print('아이디: $username, 이메일: $email, 비밀번호: $password');

                  // 회원가입 후 메인 화면으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text('회원가입'),
              ),
              SizedBox(height: 12.0),
              Text('이미 계정이 있으신가요?'),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = true;
                  });
                },
                child: Text('로그인'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}