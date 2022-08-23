import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:writup/main.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text('Drawer Header',
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              jwtGlobal = '';
              print('H1');
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushNamed(context, '/login');
              print('H2');
              //Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Page 2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}