import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:stand_by/HomePage/home.dart';

class PassLockScreen extends StatefulWidget {
  @override
  _PassLockScreenState createState() => _PassLockScreenState();
}

String storedPasscode = "123456";
String savedPassword = "k";

class _PassLockScreenState extends State<PassLockScreen> {
  bool isAuthenticated = false;

  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    print("i got here");
    return PasscodeScreen(
      title: Text(
        'Enter Passcode',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.purple, fontSize: 28),
      ),
      circleUIConfig: CircleUIConfig(
          borderColor: Colors.white, fillColor: Colors.purple, circleSize: 10),
      keyboardUIConfig: KeyboardUIConfig(
          digitTextStyle: TextStyle(color: Colors.purple, fontSize: 25),
          // digitFillColor: Colors.purple,
          digitBorderWidth: 2,
          primaryColor: Colors.purple),
      passwordEnteredCallback: _onPasscodeEntered,
      cancelButton: Text('Cancel',
          style: const TextStyle(fontSize: 16, color: Colors.white)),
      deleteButton: Text(
        'Delete',
        style: const TextStyle(fontSize: 16, color: Colors.purple),
        semanticsLabel: 'Delete',
      ),
      shouldTriggerVerification: _verificationNotifier.stream,
      backgroundColor: Colors.white.withOpacity(0.8),
      // cancelCallback: _onPasscodeCancelled,
      passwordDigits: 6,
      bottomWidget: _buildPasscodeRestoreButton(),
    );
  }

  _onPasscodeEntered(String enteredPasscode) {
    if (savedPassword == enteredPasscode) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  void initState() {
    super.initState();
    _getPass();
  }

  _getPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedPassword = prefs.getString("pass")!;
    print(savedPassword);
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  _buildPasscodeRestoreButton() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: TextButton(
            child: Text(
              "Reset passcode",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
            onPressed: _resetAppPassword,
            // ),
          ),
        ),
      );

  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
        //TODO: Clear your stored passcode here
      });
    });
  }

  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset passcode",
            style: const TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Passcode reset is a non-secure operation!\n\nConsider removing all user data if this action performed.",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            TextButton(
              child: Text(
                "I understand",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: onAccepted,
            ),
          ],
        );
      },
    );
  }
}
