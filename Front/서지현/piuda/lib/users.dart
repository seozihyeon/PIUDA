class Users {
  final int userId;
  final String userName;
  final String userStatus;
  final String barcodeImg;

  Users({
    required this.userId,
    required this.userName,
    required this.userStatus,
    required this.barcodeImg,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userId: json['user_id'] as int,
      userName: json['user_name'] as String,
      userStatus: json['user_status'] as String,
      barcodeImg: json['barcode_img'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_status': userStatus,
      'barcode_img': barcodeImg,
    };
  }
}