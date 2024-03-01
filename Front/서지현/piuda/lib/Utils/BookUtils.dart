import 'package:http/http.dart' as http;
import 'dart:convert';

class BookUtils {
  static Future<String> fetchBookCover(String bookIsbn) async {
    if (bookIsbn.isEmpty) {
      return 'assets/images/디폴트.png';
    }

    final String clientId = 'uFwwNh4yYFgq3WtAYl6S';
    final String clientSecret = 'WElJXwZDhV';

    try {
      final response = await http.get(
        Uri.parse('https://openapi.naver.com/v1/search/book_adv.json?d_isbn=$bookIsbn'),
        headers: {
          'X-Naver-Client-Id': clientId,
          'X-Naver-Client-Secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return decodedData['items'][0]['image'] ?? 'assets/images/디폴트.png';
      } else {
        print('Failed to fetch book cover. Status code: ${response.statusCode}');
        return 'assets/images/디폴트.png';
      }
    } catch (e) {
      print('Error fetching book cover: $e');
      return 'assets/images/디폴트.png';
    }
  }
}
