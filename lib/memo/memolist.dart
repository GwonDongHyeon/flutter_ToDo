import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/api/api.dart';
import 'package:project1/memo/memoplus.dart';
import 'package:project1/model/user2.dart';
import 'package:project1/memo/service.dart';
import 'package:project1/memo/memodetail.dart';
import 'package:http/http.dart' as http;

class MemoList extends StatefulWidget {
  const MemoList({super.key});

  @override
  State<MemoList> createState() => _MemoList();
}

class _MemoList extends State<MemoList> {
  List<User2> _user = <User2>[];
  bool loading = false;
  Set<int> selectedIds = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final newData = await Services.getInfo();
    setState(() {
      _user = newData;
      loading = true;
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
      _fetchData();
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content:
                              const Text('Are you sure you want to delete?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                deletInfo();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
          ),
        ],
      ),
      body: loading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: _user.length,
                itemBuilder: (context, index) {
                  User2 user = _user[index];

                  if (index == 0 ||
                      _user[index - 1].memoDate != user.memoDate) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  user.memoDate,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        buildMemoTile(user),
                      ],
                    );
                  } else {
                    return buildMemoTile(user);
                  }
                },
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MemoPlus(),
            ),
          );
          _fetchData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildMemoTile(User2 user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(user),
                ),
              );
              _fetchData();
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
        ),
      ),
    );
  }
}
