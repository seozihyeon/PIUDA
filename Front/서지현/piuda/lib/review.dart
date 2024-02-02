class Review {
  final String? userName; // 널이 될 수 있음을 표시
  final int? reviewScore; // 널이 될 수 있음을 표시
  final String? reviewContent; // 널이 될 수 있음을 표시
  final String? reviewDate; // 널이 될 수 있음을 표시

  Review({
    this.userName,
    this.reviewScore,
    this.reviewContent,
    this.reviewDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['user_name'] as String?, // 널을 허용하는 캐스팅
      reviewScore: json['review_score'] as int?, // 널을 허용하는 캐스팅
      reviewContent: json['review_content'] as String?, // 널을 허용하는 캐스팅
      reviewDate: json['review_date'] as String?, // 널을 허용하는 캐스팅
    );
  }
}
