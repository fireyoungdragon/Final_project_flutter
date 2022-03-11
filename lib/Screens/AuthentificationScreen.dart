import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainScreen.dart';

OutlineInputBorder _textFieldBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(color: Colors.green, width: 2));

String hintForUser = 'Enter phone number and password';
String userPhone = '';
String userPassword = '';

void saveLogin() async {
  final pr = await SharedPreferences.getInstance();
  pr.setString('userPhone', '89017015378');
  pr.setString('userPass', '142784');
}

class Authentification extends StatefulWidget {
  const Authentification({Key? key}) : super(key: key);

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  void checkLogin(String usPh, String usPas) async {
    final pr = await SharedPreferences.getInstance();
    String _phoneData = pr.getString('userPhone') ?? '';
    String _passData = pr.getString('userPass') ?? '';
    if (usPh == _phoneData) {
      if (usPas == _passData) {
        pr.setBool('isLogin', true);
        hintForUser = 'Enter phone number and password';
        readUserPhone();
        Navigator.pushNamed(context, '/mainscreen');
      } else {
        setState(() {
          hintForUser = 'Wrong password';
        });
      }
    } else {
      setState(() {
        hintForUser = 'Wrong phone number';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Authorization',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.green),
                )),
            SizedBox(
              width: 300,
              child: TextField(
                onChanged: (val) {
                  userPhone = val;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  filled: true,
                  fillColor: Colors.green,
                  focusedBorder: _textFieldBorder,
                  enabledBorder: _textFieldBorder,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              width: 300,
              child: TextField(
                onChanged: (val) {
                  userPassword = val;
                },
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.green,
                  focusedBorder: _textFieldBorder,
                  enabledBorder: _textFieldBorder,
                ),
              ),
            ),
            Text(hintForUser),
            Container(
              width: 300,
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () {
                    if (userPhone.length < 11) {
                      setState(() {
                        hintForUser = 'Phone number at least 11 digits';
                      });
                    } else {
                      if (userPassword.isEmpty) {
                        setState(() {
                          hintForUser = 'Password cannot be empty';
                        });
                      } else {
                        checkLogin(userPhone, userPassword);
                      }
                    }
                  },
                  child: const Text('Enter')),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                'Phone: 89017015378\n'
                'Pass: 142784',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            )
          ],
        )),
      ),
    );
  }
}
