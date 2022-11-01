import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:writup/main.dart';
import 'apiCalls.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder(
            future: fetchAccountDetails(0), // '0' depicts self
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('loading...'));
              } else {
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else
                  print('i am here');
                //print(snapshot.data[1][4]);
                print(snapshot.data);
                print(snapshot.data.length);
                return SizedBox(
                  height: 450,
                  child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 70,
                            child: Text(
                              snapshot.data[1][2][0],
                              style: TextStyle(
                                  fontSize: 48,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  //fontStyle: FontStyle.italic,
                                  //letterSpacing: 5,
                                  //wordSpacing: 2,
                                  //backgroundColor: Colors.yellow,
                                  shadows: [
                                    Shadow(
                                        color: Colors.white70,
                                        offset: Offset(1, .5),
                                        blurRadius: .1)
                                  ]),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          Text(snapshot.data[1][2],
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                //fontStyle: FontStyle.italic,
                                //letterSpacing: 5,
                                //wordSpacing: 2,
                                //backgroundColor: Colors.yellow,
                                shadows: [
                                  Shadow(
                                      color: Colors.black54,
                                      offset: Offset(1, .5),
                                      blurRadius: 10)
                                ]),),
                          Padding(padding: EdgeInsets.symmetric(vertical: 1)),
                          Text(snapshot.data[1][6].toString() + ' Karma' ,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                //fontStyle: FontStyle.italic,
                                //letterSpacing: 5,
                                //wordSpacing: 2,
                                //backgroundColor: Colors.yellow,
                                shadows: [
                                  Shadow(
                                      color: Colors.black54,
                                      offset: Offset(1, .5),
                                      blurRadius: 10)
                                ]),),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          FittedBox(
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.star,
                                    color: Colors.white),
                                    Text(' ' + snapshot.data[1][8].toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          //letterSpacing: 5,
                                          //wordSpacing: 2,
                                          //backgroundColor: Colors.yellow,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black54,
                                                offset: Offset(1, .5),
                                                blurRadius: 10)
                                          ]),),
                                    Text(' by ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
                                          //letterSpacing: 5,
                                          //wordSpacing: 2,
                                          //backgroundColor: Colors.yellow,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black54,
                                                offset: Offset(1, .5),
                                                blurRadius: 10)
                                          ]),),
                                    Text(snapshot.data[1][7].toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          //letterSpacing: 5,
                                          //wordSpacing: 2,
                                          //backgroundColor: Colors.yellow,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black54,
                                                offset: Offset(1, .5),
                                                blurRadius: 10)
                                          ]),),
                                    Text(' readers on ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
                                          //letterSpacing: 5,
                                          //wordSpacing: 2,
                                          //backgroundColor: Colors.yellow,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black54,
                                                offset: Offset(1, .5),
                                                blurRadius: 10)
                                          ]),),
                                    Text(snapshot.data[1][13].toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          //letterSpacing: 5,
                                          //wordSpacing: 2,
                                          //backgroundColor: Colors.yellow,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black54,
                                                offset: Offset(1, .5),
                                                blurRadius: 10)
                                          ]),),
                                    Text(' writups',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
                                          //letterSpacing: 5,
                                          //wordSpacing: 2,
                                          //backgroundColor: Colors.yellow,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black54,
                                                offset: Offset(1, .5),
                                                blurRadius: 10)
                                          ]),),
                                  ]),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                          Text(snapshot.data[1][12].toString() + ' Followers' ,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                //letterSpacing: 5,
                                //wordSpacing: 2,
                                //backgroundColor: Colors.yellow,
                                shadows: [
                                  Shadow(
                                      color: Colors.black54,
                                      offset: Offset(1, .5),
                                      blurRadius: 10)
                                ]),),
                        ],
                      ),
                    ),
                  ),
                ),);
              }
            },
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ListTile(
            leading: Icon(
              Icons.person,
            ),
            title: const Text('Edit Profile',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  //fontStyle: FontStyle.italic,
                  //letterSpacing: 3,
                  //wordSpacing: 2,
                  //backgroundColor: Colors.yellow,
                  shadows: [
                    Shadow(
                        color: Colors.white,
                        offset: Offset(.5, .5),
                        blurRadius: 10)
                  ]),),
            onTap: () {
              print("edit profile");
              //Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bookmark,
            ),
            title: const Text('Saved Writups',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  //fontStyle: FontStyle.italic,
                  //letterSpacing: 3,
                  //wordSpacing: 2,
                  //backgroundColor: Colors.yellow,
                  shadows: [
                    Shadow(
                        color: Colors.white,
                        offset: Offset(.5, .5),
                        blurRadius: 10)
                  ]),),
            onTap: () {
              print("saved writups");
              Navigator.pushNamed(context, '/savedPosts');
              //Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people_alt,
            ),
            title: const Text('My Followers',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  //fontStyle: FontStyle.italic,
                  //letterSpacing: 3,
                  //wordSpacing: 2,
                  //backgroundColor: Colors.yellow,
                  shadows: [
                    Shadow(
                        color: Colors.white,
                        offset: Offset(.5, .5),
                        blurRadius: 10)
                  ]),),
            onTap: () {
              print("my followers");
              Navigator.pushNamed(context, '/viewFollowers');
              //Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.people_alt,
            ),
            title: const Text('Following',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  //fontStyle: FontStyle.italic,
                  //letterSpacing: 3,
                  //wordSpacing: 2,
                  //backgroundColor: Colors.yellow,
                  shadows: [
                    Shadow(
                        color: Colors.white,
                        offset: Offset(.5, .5),
                        blurRadius: 10)
                  ]),),
            onTap: () {
              print("following");
              Navigator.pushNamed(context, '/viewFollowing');
              //Navigator.pushNamed(context, '/login');
            },
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 30)),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: const Text('Logout',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  //fontStyle: FontStyle.italic,
                  //letterSpacing: 3,
                  //wordSpacing: 2,
                  //backgroundColor: Colors.yellow,
                  shadows: [
                    Shadow(
                        color: Colors.white,
                        offset: Offset(.5, .5),
                        blurRadius: 10)
                  ]),),
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
        ],
      ),
    );
  }
}
