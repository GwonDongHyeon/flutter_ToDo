import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_flutter/api/api.dart';
import 'package:todo_flutter/model/user2.dart';

class DetailPage extends StatefulWidget {
  final User2 user;

  const DetailPage(this.user, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _contentController;
  late TextEditingController _startLocationController;
  late TextEditingController _endLocationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.user.memoTitle);
    _dateController = TextEditingController(text: widget.user.memoDate);
    _contentController = TextEditingController(text: widget.user.memoContent);
    _startLocationController =
        TextEditingController(text: widget.user.memoStartLocation);
    _endLocationController =
        TextEditingController(text: widget.user.memoEndLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null &&
                            pickedDate != DateTime.now()) {
                          setState(() {
                            _dateController.text =
                                '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[400]!,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          _dateController.text,
                          style: TextStyle(
                            fontSize: 16,
                            color: _dateController.text.isNotEmpty
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
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          controller: _contentController,
                          maxLines: 9,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Content',
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          controller: _startLocationController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'StartLocation',
                          ),
                          maxLines: null,
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
                          controller: _endLocationController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'EndLocation',
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          _updateMemoContent(
                            widget.user.memoId,
                            _titleController.text,
                            _dateController.text,
                            _contentController.text,
                            _startLocationController.text,
                            _endLocationController.text,
                          );
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMemoContent(
    int memoId,
    String newTitle,
    String newDate,
    String newContent,
    String newStartLocation,
    String newEndLocation,
  ) async {
    try {
      var response = await http.post(
        Uri.parse(API.update),
        body: {
          'id': memoId.toString(),
          'title': newTitle,
          'memoDate': newDate,
          'content': newContent,
          'startLocation': newStartLocation,
          'endLocation': newEndLocation,
        },
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Memo content updated successfully');
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Failed to update memo content');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      Fluttertoast.showToast(msg: 'Failed to update memo content');
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
