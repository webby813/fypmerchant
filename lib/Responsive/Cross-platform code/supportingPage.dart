import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Components/barTitle_widget.dart';

class HelpCentre extends StatelessWidget {
  const HelpCentre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool showAppBar = screenWidth < 500 || screenWidth >= 1100;

    return Scaffold(
      appBar: showAppBar ? AppBar(title: BarTitle.appBarText("Help Centre")) : null,
      body: ListView(
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "PDF GUIDELINE WILL BE EMBEDDED HERE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool showAppBar = screenWidth < 500 || screenWidth >= 1100;

    return Scaffold(
      appBar: showAppBar ? AppBar(title: BarTitle.appBarText("Feedback"),) : null,
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Center(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Your Feedback Matters!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    "Let me know where to improve your experience",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Type something...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {

                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(110, 50),
                    ),
                  ),
                  child: const Text(
                    "Send",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
