import 'package:http/http.dart' as http;
import 'package:flutter_todo/model/user2.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Services {
  static const String url = 'http://10.0.2.2/api_members/user/output.php';

  static Future<List<User2>> getInfo() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<User2> user = userFromJson(response.body);

        user.sort((a, b) {
          DateTime aDate = DateTime.parse(a.memoDate);
          DateTime bDate = DateTime.parse(b.memoDate);
          return aDate.compareTo(bDate);
        });

        return user;
      } else {
        Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        return <User2>[];
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return <User2>[];
    }
  }
}
