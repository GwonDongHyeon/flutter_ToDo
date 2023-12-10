import 'package:flutter/material.dart';
import 'package:project1/model/user2.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final User2 user;

  const DetailPage(this.user, {Key? key}) : super(key: key);

  void launchGoogleMaps() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=${Uri.encodeComponent(user.memoStartLocation)}&destination=${Uri.encodeComponent(user.memoEndLocation)}";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Unable to open Google Maps';
    }
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
            Text(
              user.memoTitle.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Date: ${user.memoDate}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              user.memoTitle,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              user.memoContent,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              user.memoStartLocation,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              user.memoEndLocation,
              style: const TextStyle(fontSize: 12),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    launchGoogleMaps();
                  },
                  child: const Text('Navigator'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
