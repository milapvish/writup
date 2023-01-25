import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewFollowing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Following',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: FutureBuilder(
        future: fetchFollowingUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('loading...'));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              print('i am here in view following');
            //print(snapshot.data[1][4]);
            print(snapshot.data.length);
            //print(snapshot.data[1][0]);
            if (snapshot.data.length > 1) {
            return ListView.builder(
                itemCount: snapshot.data.length - 1,
                itemBuilder: (BuildContext context, int itemIndex) {
                  int userId = snapshot.data[itemIndex + 1][0];
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              backgroundImage: CachedNetworkImageProvider(snapshot.data[itemIndex + 1][14]),
                              child: Text('',
                              ),),
                            TextButton(
                              onPressed: () async {
                                print("pressing writer name ");
                                Navigator.pushNamed(
                                  context,
                                  '/publicProfile',
                                  arguments: {
                                    'userId': userId,
                                    'userName': snapshot.data[itemIndex + 1][2]
                                        .toString(),
                                    'dpUrl' : snapshot.data[itemIndex + 1][14].toString()
                                  },
                                );
                              },
                              child: Text(
                                snapshot.data[itemIndex + 1][2].toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    //fontStyle: FontStyle.italic,
                                    //letterSpacing: 5,
                                    //wordSpacing: 2,
                                    //backgroundColor: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                          color: Colors.white70,
                                          offset: Offset(1, .5),
                                          blurRadius: 10)
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                            future: checkUserFollow(
                                userId),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: Text('loading...'));
                              } else {
                                if (snapshot.hasError)
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                else
                                  print('i am here');
                                //print(snapshot.data[1][4]);
                                print(snapshot.data.length);
                                final _followButtonTextNotifier = ValueNotifier<String>("Follow");
                                final _followButtonColorNotifier = ValueNotifier<Color>(Colors.black87);

                                _followButtonTextNotifier.value = snapshot.data;

                                if (_followButtonTextNotifier.value ==
                                    "Follow") {
                                  _followButtonColorNotifier.value =
                                      Colors.black87;
                                } else {
                                  _followButtonColorNotifier.value =
                                      Colors.black54;
                                }
                                return ValueListenableBuilder(
                                  valueListenable: _followButtonTextNotifier,
                                  builder: (context, value, _) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        print("follow pressed");
                                        if (_followButtonTextNotifier.value ==
                                            "Follow") {
                                          _followButtonTextNotifier.value =
                                          "Following";
                                          _followButtonColorNotifier.value =
                                              Colors.black54;
                                        } else {
                                          _followButtonTextNotifier.value =
                                          "Follow";
                                          _followButtonColorNotifier.value =
                                              Colors.black87;
                                        }
                                        updateUserFollow(
                                            _followButtonTextNotifier.value,
                                            userId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        //padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                                        shape: StadiumBorder(),
                                        primary:
                                        _followButtonColorNotifier.value,
                                      ),
                                      child:
                                      Text(_followButtonTextNotifier.value),
                                    );
                                  },
                                );
                              }
                            }),
                      ],
                    ),
                  );
                });}
            else {
              return Center(
                child: Text("People you follow appear here"),);
            }
          }
        },
      ),
    );
  }
}
