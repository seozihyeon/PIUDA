import 'review.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewService {
  Future<List<Review>> fetchReviews(String isbn) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/review/get/by-isbn/$isbn'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // UTF-8 인코딩으로 디코딩
      final String decodedResponse = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(decodedResponse);
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
