import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewNotifications extends StatefulWidget {
  @override
  _ViewNotificationsState createState() => _ViewNotificationsState();
}

class _ViewNotificationsState extends State<ViewNotifications> {
  @override
  Widget build(BuildContext context) {
    print("here aaya");
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    var nbrUnreadNotifs = arg['nbrUnreadNotifs'];
    var data;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.black54,
        onRefresh: () async {
          print("refreshing");
          var temp = await fetchNotifications();
          setState(() {
            data = temp;
          });
        },
        child: FutureBuilder(
          future: fetchNotifications(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.black54,));
            } else {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else
                print('printing length');
              //print(snapshot.data[1][4]);
              print(snapshot.data.length);
              data = snapshot.data;
              //print(snapshot.data[1][2]);
              if (snapshot.data.length > 1) {
                return ListView.builder(
                  itemCount: snapshot.data.length - 1,
                  itemBuilder: (BuildContext context, int index) {
                    // bg color for unread notifs
                    var bgColor = Colors.white.withOpacity(0);
                    if (snapshot.data[index + 1][3] == 0) {
                      bgColor = Colors.black12;
                    }
                    // calc age of notif
                    var dt = DateTime.now().toUtc();
                    print(DateTime.now());
                    var dt1 = DateTime.parse(snapshot.data[index + 1][7] + 'Z'); //'Z' tells it's UTC
                    Duration diff = dt.difference(dt1);
                    String ageStr = '';
                    if (diff.inMinutes < 60) {
                      ageStr = diff.inMinutes.toString() + 'm';
                    } else {
                      if (diff.inHours < 24) {
                        ageStr = diff.inHours.toString() + 'h';
                      } else {
                        ageStr = diff.inDays.toString() + 'd';
                      }
                    }
                    if (snapshot.data[index + 1][2] == 'rating') {
                      return Container(
                        color: bgColor,
                        child: InkWell(
                          onTap: () async {
                            print(snapshot.data[index + 1][4]);
                            var articleList = await fetchArticleByPostID(snapshot.data[index + 1][4].toInt());
                            if (snapshot.data[index + 1][3] == 0) {
                              markNotifSeen(snapshot.data[index + 1][0],
                                  snapshot.data[index + 1][2]);
                            }
                            Navigator.pushNamed(
                              context,
                              '/viewArticle',
                              arguments: {
                                'articleList': articleList,
                                'thisIndex': 0,
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child:
                                      Icon(Icons.star_rate_rounded,
                                          size: 35,
                                      color: Colors.orangeAccent,),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "New Rating ",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black87,
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
                                              ]),
                                        ),
                                        Text(
                                          " ~ " + ageStr,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black26,
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
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2)),
                                    Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 4,
                                      runSpacing: 1,
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width - 65,
                                        child: Text(
                                          'Your writup "' +
                                              snapshot.data[index + 1][9] +
                                              '" has been rated ' +
                                              snapshot.data[index + 1][6]
                                                  .toString() +
                                              ' by a reader',
                                          //softWrap: false,
                                          maxLines: 10,
                                          style: TextStyle(
                                              fontSize: 14,
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
                                                    blurRadius: 10)
                                              ]),
                                        ),),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    if (snapshot.data[index + 1][2] == 'follow') {
                      return Container(
                        color: bgColor,
                        child: InkWell(
                          onTap: () {
                            if (snapshot.data[index + 1][3] == 0) {
                              markNotifSeen(snapshot.data[index + 1][0],
                                  snapshot.data[index + 1][2]);
                            }
                            Navigator.pushNamed(
                                context,
                                '/publicProfile',
                                arguments: {
                                'userId': snapshot.data[index + 1][5],
                                'userName':
                                snapshot.data[index + 1][8].toString(),
                                  'dpUrl' : snapshot.data[index + 1][12],
                                },);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    backgroundImage: CachedNetworkImageProvider(snapshot.data[index + 1][12]),
                                    radius: 20,
                                    child: Text(""),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "New Follower ",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black87,
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
                                              ]),
                                        ),
                                        Text(
                                          " ~ " + ageStr,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black26,
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
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index + 1][8],
                                          style: TextStyle(
                                              fontSize: 15,
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
                                                    blurRadius: 10)
                                              ]),
                                        ),
                                        Text(
                                          " started following you",
                                          style: TextStyle(
                                              fontSize: 14,
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
                                                    blurRadius: 10)
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Text("Notifications will appear here");
                    }
                  },
                );
              } else {
                return Center(
                  child: Text("Notifications will appear here"),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
