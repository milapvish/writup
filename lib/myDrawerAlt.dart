import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:writup/main.dart';
import 'apiCalls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class MyDrawerAlt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: FutureBuilder(
            future: fetchTrending(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text(""));
              } else {
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else
                  print('i am here');
                print(snapshot.data);
                print(snapshot.data.length);
                return Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Text("Trending Users",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          //fontStyle: FontStyle.italic,
                          //letterSpacing: 5,
                          //wordSpacing: 2,
                          //backgroundColor: Colors.yellow,
                          shadows: [
                            Shadow(
                                color: Colors.white70,
                                offset: Offset(1, .5),
                                blurRadius: 10)
                          ]),),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 4,
                      runSpacing: 1,
                      children: <Widget>[
                        for (int index = 1; index < snapshot.data.length; index++)
                          if (snapshot.data[index][0] == "user")
                          ElevatedButton(
                            onPressed: () async {
                              print("user pressed");
                              Navigator.pushNamed(
                                context,
                                '/publicProfile',
                                arguments: {
                                  'userId': snapshot.data[index][2].toInt(),
                                  'userName':
                                  snapshot.data[index][3],
                                  'dpUrl': "",
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                              shape: StadiumBorder(),
                              backgroundColor: Colors.black54,
                            ),
                            child: Text(snapshot.data[index][3]),
                          ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                    Text("Trending Tags",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          //fontStyle: FontStyle.italic,
                          //letterSpacing: 5,
                          //wordSpacing: 2,
                          //backgroundColor: Colors.yellow,
                          shadows: [
                            Shadow(
                                color: Colors.white70,
                                offset: Offset(1, .5),
                                blurRadius: 10)
                          ]),),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 4,
                      runSpacing: 1,
                      children: <Widget>[
                        for (int index = 1; index < snapshot.data.length; index++)
                          if (snapshot.data[index][0] == "tag")
                            ElevatedButton(
                              onPressed: () async {
                                print("user pressed");
                                Navigator.pushNamed(
                                  context,
                                  '/hashTagPosts',
                                  arguments: {
                                    'hashTag': snapshot.data[index][1],
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                                shape: StadiumBorder(),
                                backgroundColor: Colors.black54,
                              ),
                              child: Text(snapshot.data[index][1]),
                            ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
