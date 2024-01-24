import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'users.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _UsernameController = TextEditingController();
  var _UseridController = TextEditingController();
  dynamic userInfo = '';

  static final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    //비동기로 flutter secure storage 정보를 불러오는 작업.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key:'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      Navigator.pushNamed(context, '/main');
    } else {
      print('로그인이 필요합니다');
    }
  }


  Future<void> _login() async {
    String username = _UsernameController.text;
    String userId = _UseridController.text;
    int? userIdInt = int.tryParse(userId);

    if (userIdInt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('올바른 회원정보를 입력하세요.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    var loginurl = Uri.parse('http://10.0.2.2:8080/login');

    try {
      var param = {'user_name': username, 'user_id': userIdInt};

      var response = await http.post(
          loginurl,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(param)
      );

      print('Sending request with data: ${jsonEncode(param)}');


      if (response.statusCode == 200) {
        var loginObject = Login(username, userIdInt);
        var val = jsonEncode(loginObject.toJson());

        await storage.write(
          key: 'login',
          value: val,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인에 성공했습니다.'),
            duration: Duration(seconds: 3),
          ),
        );
        MyApp.isLoggedIn = true;
        // 로그인 성공 후 처리, 예를 들면 홈 페이지로 이동
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(username: username, userid: userIdInt)), // 로그인 성공 후 이동할 페이지
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인에 실패했습니다. 올바른 이름과 회원번호를 입력하세요.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패했습니다. 서버 연결을 확인하세요.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan.shade700,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
              );
            },
            child: Icon(Icons.close),
          ),
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
                      color: Colors.white,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: Offset(0, 3),
                      )
                    ]
                ),
                margin: EdgeInsets.only(top: 120, left: 30, right: 30),
                padding: EdgeInsets.only(top: 10, bottom: 0, left: 24, right: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(child: Text("본인의 성명과 회원번호로 로그인하세요.", style: TextStyle(fontWeight: FontWeight.bold),), margin: EdgeInsets.all(20)),
                      TextField(
                        controller: _UsernameController,
                        decoration: InputDecoration(
                          labelText: '성명',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextField(
                        controller: _UseridController,
                        decoration: InputDecoration(labelText: '회원번호',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),)
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _login,
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black54),
                        ),
                        child: Text('로그인', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 20.0),
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