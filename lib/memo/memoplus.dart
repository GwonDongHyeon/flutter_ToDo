import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/model/user.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var formKey = GlobalKey<FormState>();

  var memoDateController = TextEditingController();
  var titleController = TextEditingController();
  var contentController = TextEditingController();
  var startLocaionController = TextEditingController();
  var endLocationController = TextEditingController();

  saveInfo() async {
    User userModel = User(
      1,
      memoDateController.text.trim(),
      titleController.text.trim(),
      contentController.text.trim(),
      startLocaionController.text.trim(),
      endLocationController.text.trim(),
    );

    try {
      var res =
          await http.post(Uri.parse(API.signup), body: userModel.toJson());

      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['success'] == true) {
          Fluttertoast.showToast(msg: 'Signup successfully');
          setState(() {
            memoDateController.clear();
            titleController.clear();
            contentController.clear();
            startLocaionController.clear();
            endLocationController.clear();
          });
        } else {
          Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        }
      }
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
        title: const Text('Create New Memo'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null &&
                                    pickedDate != DateTime.now()) {
                                  setState(() {
                                    memoDateController.text =
                                        '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                                  });
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[400]!,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  memoDateController.text.isNotEmpty
                                      ? memoDateController.text
                                      : 'Select date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: memoDateController.text.isNotEmpty
                                        ? Colors.black
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: titleController,
                            validator: (val) =>
                                val == "" ? "Please enter title" : null,
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: 'Title'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: contentController,
                            validator: (val) =>
                                val == "" ? "Please enter content" : null,
                            maxLines: 9,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Content',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: startLocaionController,
                            validator: (val) => val == ""
                                ? "Please enter start location"
                                : null,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Start Locaion'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: endLocationController,
                            validator: (val) =>
                                val == "" ? "Please enter end location" : null,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'End Location'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    saveInfo();
                  }
                },
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text(
                          'Plus',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
