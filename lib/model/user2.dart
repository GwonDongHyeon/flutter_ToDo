import 'dart:convert';

List<User2> userFromJson(String str) =>
    List<User2>.from(json.decode(str).map((x) => User2.fromJson(x)));

String userToJson(List<User2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User2 {
  int memoId;
  String memoDate;
  String memoTitle;
  String memoContent;
  String memoStartLocation;
  String memoEndLocation;

  User2({
    required this.memoId,
    required this.memoDate,
    required this.memoTitle,
    required this.memoContent,
    required this.memoStartLocation,
    required this.memoEndLocation,
  });

  factory User2.fromJson(Map<String, dynamic> json) => User2(
        memoId: json["id"],
        memoDate: json["memoDate"],
        memoTitle: json["title"],
        memoContent: json["content"],
        memoStartLocation: json["startLocation"],
        memoEndLocation: json["endLocation"],
      );

  Map<String, dynamic> toJson() => {
        "id": memoId,
        "memoDate": memoDate,
        "title": memoTitle,
        "content": memoContent,
        "startLocation": memoStartLocation,
        "endLocation": memoEndLocation,
      };
}
