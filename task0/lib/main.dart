import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Launch URL with error handling
    Future<void> _launchURL(String url) async {
      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } catch (e) {
        // Optional: Show error dialog or SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("HNG Links for Task 0"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () =>
                    _launchURL("https://github.com/aderemi-alo/HNG12"),
                child: Text("My HNG 12 Github Repository"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _launchURL(
                    "https://www.notion.so/Stage-0-Blog-Post-with-Strategic-Backlinks-for-HNG-Hire-Delve-and-Telex-80a6ed3d3c3d49489769d78b6a23ecda?pvs=21"),
                child: Text("Hiring Flutter Developers!!!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
