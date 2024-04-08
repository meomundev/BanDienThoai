class User {
  String? idNumber;
  String? accountId;
  String? fullName;
  String? phoneNumber;
  String? imageUrl;
  String? birthDay;
  String? gender;
  String? schoolYear;
  String? schoolKey;
  String? dateCreated;
  bool? status;

  User({
    required this.idNumber,
    required this.accountId,
    required this.fullName,
    required this.phoneNumber,
    required this.imageUrl,
    required this.birthDay,
    required this.gender,
    required this.schoolYear,
    required this.schoolKey,
    required this.dateCreated,
    required this.status,
  });
  static User user() {
    return User(
        idNumber: '',
        accountId: '',
        fullName: '',
        phoneNumber: '',
        imageUrl: '',
        birthDay: '',
        gender: '',
        schoolYear: '',
        schoolKey: '',
        dateCreated: '',
        status: false);
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        idNumber: json["idNumber"],
        accountId: json["accountID"],
        fullName: json["fullName"],
        phoneNumber: json["phoneNumber"],
        imageUrl: json["imageURL"] == null || json["imageURL"] == ''
            ? ""
            : json['imageURL'],
        birthDay: json["birthDay"],
        gender: json["gender"],
        schoolYear: json["schoolYear"],
        schoolKey: json["schoolKey"],
        dateCreated: json["dateCreated"],
        status: json["status"],
      );
}
