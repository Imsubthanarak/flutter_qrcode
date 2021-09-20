import 'package:flutter/material.dart';
import 'package:flutter_qrcode/database.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'dart:async';
import 'qr_home.dart';
import 'database.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    List<String>? digits;
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Positioned(
            width: size.width,
            height: size.height,
            child: Container(
              color: const Color(0xFFB6E3BC),
            ),
          ),
          Positioned(
            top: (size.height / 2) - ((size.height - 200.0) / 2),
            left: (size.width / 2) - ((size.width - 50.0) / 2),
            width: size.width - 50.0,
            height: size.height - 170.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
            ),
          ),
          Positioned(
            top: (size.height / 2) - ((size.height - 150.0) / 2),
            left: (size.width / 2) - ((size.width - 20.0) / 2),
            width: size.width - 20.0,
            height: size.height - 150.0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: PasscodeScreen(
                title: const Text(
                  'Enter App Passcode',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
                circleUIConfig: const CircleUIConfig(
                    borderColor: Colors.grey,
                    fillColor: Colors.greenAccent,
                    circleSize: 30),
                keyboardUIConfig: const KeyboardUIConfig(
                  digitBorderWidth: 2,
                  primaryColor: Colors.black,
                  digitTextStyle: TextStyle(fontSize: 30, color: Colors.black),
                  digitInnerMargin: EdgeInsets.all(25),
                  keyboardRowMargin:
                      EdgeInsets.only(top: 15, left: 4, right: 4),
                ),
                passwordEnteredCallback: _onPasscodeEntered,
                cancelButton: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                deleteButton: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  semanticsLabel: 'Delete',
                ),
                shouldTriggerVerification: _verificationNotifier.stream,
                backgroundColor: Colors.transparent,
                cancelCallback: _onPasscodeCancelled,
                digits: digits,
                passwordDigits: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onPasscodeEntered(String enteredPasscode) async {
    await MongoDatabase.connect();
    bool isValid = await MongoDatabase.authLogin(enteredPasscode);
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        isAuthenticated = isValid;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Qrhome()),
        );
      });
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
