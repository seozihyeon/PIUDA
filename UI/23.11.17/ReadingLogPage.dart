import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'main.dart';

class ReadingLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('독서로그'),
      ),
      body: Center(
        child: Text('독서로그가 표시될 곳입니다.'),
      ),
    );
  }
}