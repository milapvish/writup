import 'package:flutter/material.dart';
import 'apiCalls.dart';
import 'articleListViewCommon.dart';

class HashTagPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    var hashTag = arg['hashTag'];
    print(hashTag);
    final _followButtonTextNotifier = ValueNotifier<String>("Follow");
    final _followButtonColorNotifier = ValueNotifier<Color>(Colors.black87);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 40)),
          FittedBox(
            child: Text(
              hashTag,
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  //fontStyle: FontStyle.italic,
                  //letterSpacing: 3,
                  //wordSpacing: 2,
                  //backgroundColor: Colors.yellow,
                  shadows: [
                    Shadow(
                        color: Colors.black38,
                        offset: Offset(.5, .5),
                        blurRadius: 10)
                  ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: FutureBuilder(
                future: checkHashTagFollow(hashTag),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text('loading...'));
                  } else {
                    if (snapshot.hasError)
                      return Center(child: Text('Error: ${snapshot.error}'));
                    else
                      print('snapshot data kya hai');
                    //print(snapshot.data[1][4]);
                    print(snapshot.data.length);
                    print(snapshot.data);
                    _followButtonTextNotifier.value = snapshot.data;
                    if (_followButtonTextNotifier.value == "Follow") {
                      _followButtonColorNotifier.value = Colors.black87;
                    } else {
                      _followButtonColorNotifier.value = Colors.black54;
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
                            updateHashTagFollow(
                                _followButtonTextNotifier.value,
                                hashTag);
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
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          FutureBuilder(
            future: fetchArticlesByHashTag(hashTag),
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
