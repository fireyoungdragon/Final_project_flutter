import 'package:flutter/material.dart';
import 'package:itog_app/Screens/SettingsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:itog_app/Screens/MainScreen.dart';
import 'AuthentificationScreen.dart';

String _nextScreen = '/authscreen';

class CheckAuthorization extends StatefulWidget {
  const CheckAuthorization({Key? key}) : super(key: key);

  @override
  State<CheckAuthorization> createState() => _CheckAuthorizationState();
}

class _CheckAuthorizationState extends State<CheckAuthorization> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const RootScreen(),
        '/authscreen': (context) => const Authentification(),
        '/mainscreen': (context) => const MainScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
    saveLogin();
  }

  void _checkLogin() async {
    final pr = await SharedPreferences.getInstance();
    bool _isLogin = pr.getBool('isLogin') ?? false;
    setState(() {
      if (_isLogin) {
        _nextScreen = '/mainscreen';
        globalUser = pr.getString('userPhone') ?? 'smth went wrong';
      } else {
        _nextScreen = '/authscreen';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            width: 280,
            height: 150,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.green,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Final task',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const Text('Antonov Dmitry'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, _nextScreen);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Вход',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.green,
                            ))
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
