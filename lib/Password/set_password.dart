import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPassWord extends StatefulWidget {
  @override
  _SetPassWordState createState() => _SetPassWordState();
}

class _SetPassWordState extends State<SetPassWord> {
  final passWordController = TextEditingController();

  final confirmPassWordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        title: Text("Set PassWord"),
        backgroundColor: Colors.purple[800],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 50, left: 30, right: 30),
          child: ListView(
            children: [
              TextFormField(
                controller: passWordController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Enter new password',
                    labelStyle: TextStyle(color: Colors.purple[900])),
                autofocus: false,
                obscureText: true,
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.trim() != passWordController.text) {
                      return 'match error, try again !';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Confirm your password',
                      labelStyle: TextStyle(color: Colors.purple[900])),
                  autofocus: false,
                  obscureText: true,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  bool state = _saveForm();
                  if (state) {
                    _savePassword(passWordController.text);
                    _setGotPass();
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple[600],
                ),
                child: Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _saveForm() {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      return true;
    }
    return false;
  }

  _savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("pass", password);
  }

  _setGotPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("hasPass", true);
  }

  bool state = false;

  _getGotPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getBool("hasPass")!;
  }
}
