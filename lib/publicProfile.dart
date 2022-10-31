import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:writup/main.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';

class PublicProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    var userId = arg['userId'];
    var userName = arg['userName'];
    print(userName);
    print(userId);
    final _followButtonTextNotifier = ValueNotifier<String>("Follow");
    final _followButtonColorNotifier = ValueNotifier<Color>(Colors.black87);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 40)),
          FutureBuilder(
              future: getAccountDetails(userId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('loading...'));
                } else {
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  else
                    print('i am here');
                  //print(snapshot.data[1][4]);
                  print(snapshot.data.length);
                  _followButtonTextNotifier.value = snapshot.data["followStr"];
                  if (_followButtonTextNotifier.value == "Follow") {
                    _followButtonColorNotifier.value = Colors.black87;
                  } else {
                    _followButtonColorNotifier.value = Colors.black54;
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 50,
                              child: Text(
                                userName[0],
                                style: TextStyle(
                                    fontSize: 48,
                                    color: Colors.white60,
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
                            Column(
                              children: <Widget>[
                                Text(
                                  userName,
                                  style: TextStyle(
                                      fontSize: 28,
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
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4)),
                                Text(
                                  snapshot.data["karma"] + ' Karma',
                                  style: TextStyle(
                                      fontSize: 16,
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
                                ValueListenableBuilder(
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.star),
                              Text(' ' + snapshot.data["avg_rating"],
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
                                    ]),),
                              Text(' by ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                    //letterSpacing: 5,
                                    //wordSpacing: 2,
                                    //backgroundColor: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                          color: Colors.white70,
                                          offset: Offset(1, .5),
                                          blurRadius: 10)
                                    ]),),
                              Text(snapshot.data["nbr_ratings"],
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
                                    ]),),
                              Text(' readers on ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                    //letterSpacing: 5,
                                    //wordSpacing: 2,
                                    //backgroundColor: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                          color: Colors.white70,
                                          offset: Offset(1, .5),
                                          blurRadius: 10)
                                    ]),),
                              Text(snapshot.data["nbr_articles"],
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
                                    ]),),
                              Text(' writups',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                    //letterSpacing: 5,
                                    //wordSpacing: 2,
                                    //backgroundColor: Colors.yellow,
                                    shadows: [
                                      Shadow(
                                          color: Colors.white70,
                                          offset: Offset(1, .5),
                                          blurRadius: 10)
                                    ]),),
                            ]),
                      ),
                    ]),
                  );
                }
              }),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          FutureBuilder(
            future: fetchArticlesByUserID(userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('loading...'));
              } else {
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else
                  print('i am here');
                //print(snapshot.data[1][4]);
                print(snapshot.data.length);
                return Flexible(
                  child: ArticleListViewCommon(snapshot.data),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<Map<dynamic, dynamic>> getAccountDetails(int userId) async {
  var acctMap = Map();
  String followStr = await checkUserFollow(userId);
  acctMap['followStr'] = followStr;

  List<List<dynamic>> rowsAsListOfValues = [];
  rowsAsListOfValues = await fetchAccountDetails(userId);
  print(rowsAsListOfValues[1]);

  acctMap['karma'] = rowsAsListOfValues[1][6].toString();
  acctMap['avg_rating'] = rowsAsListOfValues[1][8].toString();
  acctMap['nbr_ratings'] = rowsAsListOfValues[1][7].toString();
  acctMap['nbr_articles'] = rowsAsListOfValues[1][13].toString();
  acctMap['nbr_followers'] = rowsAsListOfValues[1][12].toString();

  print(acctMap);

  return acctMap;
}
