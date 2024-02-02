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


class ReviewConditionBox {
  final String? userName; // 널이 될 수 있음을 표시
  final int? lossScore;
  final int? taintScore;// 널이 될 수 있음을 표시
  final String? conditionOp; // 널이 될 수 있음을 표시
  final String? conditionDate; // 널이 될 수 있음을 표시

  ReviewConditionBox({
    this.userName,
    this.lossScore,
    this.taintScore,
    this.conditionOp,
    this.conditionDate,
  });

  factory ReviewConditionBox.fromJson(Map<String, dynamic> json) {
    return ReviewConditionBox(
      userName: json['user_name'] as String?,
      lossScore: json['loss_score'] as int?,
      taintScore: json['taint_score'] as int?,
      conditionOp: json['condition_op'] as String?,
      conditionDate: extractDateOnly(json['condition_date']),
    );
  }

  static String extractDateOnly(String? dateTimeString) {
    if (dateTimeString != null && dateTimeString.isNotEmpty) {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    }
    return '';
  }
}

