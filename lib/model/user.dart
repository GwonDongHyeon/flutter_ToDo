// ignore_for_file: non_constant_identifier_names

class User {
  int memo_id;
  String memo_date;
  String memo_title;
  String memo_content;
  String memo_startLocation;
  String memo_endLocation;

  User(
    this.memo_id,
    this.memo_date,
    this.memo_title,
    this.memo_content,
    this.memo_startLocation,
    this.memo_endLocation,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
        int.parse(json['id']),
        json['memoDate'],
        json['title'],
        json['content'],
        json['startLocation'],
        json['endLocation'],
      );

  Map<String, dynamic> toJson() => {
        'id': memo_id.toString(),
        'memoDate': memo_date,
        'title': memo_title,
        'content': memo_content,
        'startLocation': memo_startLocation,
        'endLocation': memo_endLocation,
      };
}
