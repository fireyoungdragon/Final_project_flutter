import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String currentScreen = 'MainScreen';

void clearUserData(context) async {
  final pr = await SharedPreferences.getInstance();
  pr.setBool('isLogin', false);
  Navigator.pop(context);
  Navigator.pushNamed(context, '/authscreen');
}

Widget drawerSettings(context) => Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Container(
                alignment: Alignment.centerLeft,
                height: 200,
                child: const Text(
                  'Final app',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              )),
          ListTile(
            title: const Text('Main page'),
            leading: const Icon(
              Icons.domain,
              color: Colors.green,
            ),
            onTap: () {
              Navigator.pop(context);
              if (currentScreen == 'Settings') {
                currentScreen = 'MainScreen';
                Navigator.pushNamed(context, '/mainscreen');
              }
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(
              Icons.settings,
              color: Colors.green,
            ),
            onTap: () {
              Navigator.pop(context);
              if (currentScreen == 'MainScreen') {
                currentScreen = 'Settings';
                Navigator.pushNamed(context, '/settings');
              }
            },
          ),
          const Divider(
            endIndent: 20,
            indent: 20,
            color: Colors.green,
          ),
          ListTile(
            title: const Text('LogOut'),
            leading: const Icon(
              Icons.logout,
              color: Colors.green,
            ),
            onTap: () {
              clearUserData(context);
            },
          ),
        ],
      ),
    );
