import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/api/api.dart';
import 'package:project1/memo/memoplus.dart';
import 'package:project1/model/user2.dart';
import 'package:project1/memo/service.dart';
import 'package:project1/memo/memodetail.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  List<User2> _user = <User2>[];
  bool loading = false;
  Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    Services.getInfo().then((value) {
      setState(() {
        _user = value;
        loading = true;
      });
    });
  }

  deletInfo() async {
    try {
      for (int id in selectedIds) {
        var res =
            await http.post(Uri.parse(API.delete), body: {'id': id.toString()});

        if (res.statusCode == 200) {
          var resSignup = jsonDecode(res.body);
          if (resSignup['success'] == true) {
            Fluttertoast.showToast(msg: 'Delete successfully');
            selectedIds = {};
          } else {
            Fluttertoast.showToast(msg: 'Error occurred. Please try again');
          }
        }
      }
      var newData = await Services.getInfo();
      setState(() {
        _user = newData;
        loading = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? 'Memo' : 'Loading...'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: selectedIds.isEmpty
                ? null
                : () {
                    deletInfo();
                  },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            itemCount: _user.length,
            itemBuilder: (context, index) {
              User2 user = _user[index];
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12.0)),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(user),
                              ),
                            );
                          },
                          leading: Checkbox(
                            value: selectedIds.contains(user.memoId),
                            onChanged: (_) {
                              setState(() {
                                if (selectedIds.contains(user.memoId)) {
                                  selectedIds.remove(user.memoId);
                                } else {
                                  selectedIds.add(user.memoId);
                                }
                              });
                            },
                          ),
                          title: Text(user.memoTitle),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(user.memoContent),
                              Text(user.memoDate),
                            ],
                          ),
                        ),
                      )));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}