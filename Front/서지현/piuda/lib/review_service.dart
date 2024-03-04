import 'review.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewService {
  Future<List<Review>> fetchReviews(String isbn) async {
    final response = await http.get(
      Uri.parse('http://34.64.173.65:8080/api/review/get/by-isbn/$isbn'),
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

  Future<void> addReview(int loanId, String reviewText, int reviewScore) async {
    final response = await http.post(
      Uri.parse('http://34.64.173.65:8080/api/review/add'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'loan_id': loanId,
        'review_content': reviewText,
        'review_score': reviewScore,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add review');
    }
  }
}


class ConditionService {
  Future<List<ReviewConditionBox>> fetchConditions(String bookId) async {
    final response = await http.get(
      Uri.parse('http://34.64.173.65:8080/reviewCondition/list/$bookId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // UTF-8 인코딩으로 디코딩
      final String decodedResponse = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(decodedResponse);
      return data.map((json) => ReviewConditionBox.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load conditions');
    }
  }
}