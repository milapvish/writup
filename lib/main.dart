import 'package:flutter/material.dart';
//import 'package:html_editor_enhanced/html_editor.dart';
import 'homeTabView.dart';
import 'followingTabView.dart';
import 'myPostsTabView.dart';
import 'viewArticle.dart';
import 'apiCalls.dart';
import 'login.dart';
import 'myDrawer.dart';
import 'publicProfile.dart';
import 'hashTagPosts.dart';
import 'savedPosts.dart';
import 'viewFollowers.dart';
import 'viewFollowing.dart';
import 'search.dart';
import 'viewNotifications.dart';
import 'reportArticle.dart';
import 'betaFeedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'consts.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart';
//import 'package:csv_reader/csv_reader.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

//HtmlEditorController htmlcontroller = HtmlEditorController();
String jwtGlobal = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //var test = fetchArtList();

  @override
  Widget build(BuildContext context) {
    Widget firstWidget;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("already logged in");
      print(user);
      print(user.uid);
      final jwt = getJwt(user);
      print(jwt);
      firstWidget = HomePage();
    } else {
      firstWidget = AuthScreen();
    }

    return MaterialApp(
      title: 'AI Art',
      routes: {
        '/': (context) => firstWidget,
        '/login': (context) => AuthScreen(),
        '/home': (context) => HomePage(),
        '/createArticle': (context) => CreateArticle(),
        //'/createArticle': (context) => TextEditorScreen(),
        '/viewArticle': (context) => ViewArticle(),
        '/publicProfile': (context) => PublicProfile(),
        '/hashTagPosts': (context) => HashTagPosts(),
        '/savedPosts': (context) => SavedPosts(),
        '/viewFollowers': (context) => ViewFollowers(),
        '/viewFollowing': (context) => ViewFollowing(),
        '/search': (context) => SearchScreen(),
        '/notifications': (context) => ViewNotifications(),
        '/createArticleDetail': (context) => CreateArticleDetail(),
        '/reportArticle': (context) => ReportArticle(),
        '/betaFeedback': (context) => BetaFeedback(),
      },
      theme: ThemeData(
        primarySwatch: Colors.brown,
        //scaffoldBackgroundColor: Colors.grey[900],
        //fontFamily: GoogleFonts.robotoFlex().fontFamily,
      ),
      themeMode: ThemeMode.light,
    );
  }
}

class HomePage extends StatelessWidget {
  var data = new HomeTabView(7);
  final _nbrNotificationsNotifier = ValueNotifier<String>('0');
  final _showNotificationsNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    // Below timer only runs once to fetch notif count initially
    final periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        // Update user about remaining time
        //print("printing every 1 secs");
        print(_nbrNotificationsNotifier.value);
        _nbrNotificationsNotifier.value = await getNbrUnreadNotifs();
        if (_nbrNotificationsNotifier.value != '0') {
          //print("inside if");
          _showNotificationsNotifier.value = true;
        } else {
          //print("inside else");
          _showNotificationsNotifier.value = false;
        }
        timer.cancel();
      },
    );

    // Below time runs every 10 seconds to get nbr notifs
    final periodicTimer1 = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        // Update user about remaining time
        //print("printing every 10 secs");
        print(_nbrNotificationsNotifier.value);
        _nbrNotificationsNotifier.value = await getNbrUnreadNotifs();
        if (_nbrNotificationsNotifier.value != '0') {
          //print("inside if");
          _showNotificationsNotifier.value = true;
        } else {
          //print("inside else");
          _showNotificationsNotifier.value = false;
        }
      },
    );
    print(data.test);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        endDrawer: MyDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: AppBar(
            backgroundColor: Colors.black87,
            title: Padding(
              padding: EdgeInsets.only(top: 10, left: 5),
              child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset('images/writup_logo_inverted.png',
                      height: 35, width: 35),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'writup',
                      style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: 36),
                    ),
                  ),
                ],
              ),),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: IconButton(
                  onPressed: () {
                    print("search pressed");
                    Navigator.pushNamed(context, '/search');
                  },
                  icon: Icon(Icons.search_rounded),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: ValueListenableBuilder(
                  valueListenable: _nbrNotificationsNotifier,
                  builder: (context, value, _) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/notifications',
                          arguments: {
                            'nbrUnreadNotifs': _nbrNotificationsNotifier.value,
                          },
                        );
                      },
                      child: Badge(
                        showBadge: _showNotificationsNotifier.value,
                        //shape: BadgeShape.square,
                        badgeColor: Colors.orangeAccent,
                        position: BadgePosition.topEnd(top: 4, end: 2),
                        borderRadius: BorderRadius.circular(5),
                        badgeContent: Text(_nbrNotificationsNotifier.value,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              //fontStyle: FontStyle.italic,
                              //letterSpacing: 5,
                              //wordSpacing: 2,
                              //backgroundColor: Colors.yellow,
                              shadows: [
                                Shadow(
                                    color: Colors.black87,
                                    offset: Offset(.5, .25),
                                    blurRadius: 1)
                              ]),),
                        child: IconButton(
                          icon: Icon(
                            Icons.notifications,
                          ),
                          //iconSize: 50,
                          //color: Colors.green,
                          //splashColor: Colors.purple,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/notifications',
                              arguments: {
                                'nbrUnreadNotifs':
                                    _nbrNotificationsNotifier.value,
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        print("menu pressed");
                        Scaffold.of(context).openEndDrawer();
                      },
                      icon: Icon(Icons.menu),
                    );
                  },
                ),
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home_filled)),
                Tab(icon: Icon(Icons.people)),
                Tab(icon: Icon(Icons.person)),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            HomeTabView(9),
            FollowingTabView(),
            MyPostsTabView(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Add your onPressed code here!
            print('pressed');
            Navigator.pushNamed(context, '/createArticle');
          },
          //label: const Text('4K'),
          child: Icon(Icons.add),
          //child: icon: const Icon(Icons.download),
          backgroundColor: floatingButtonColor,
        ),
      ),
    );
  }
}

class CreateArticle extends StatefulWidget {
  //const CreatArticle({super.key});

  @override
  CreateArticleState createState() {
    return CreateArticleState();
  }
}

class CreateArticleState extends State<CreateArticle> {
  final _formKey1 = GlobalKey<FormState>();
  Map<String, dynamic> newArticle = {
    'heading': '',
    'subHeading': '',
    'detail': '',
    'tags': '',
  };
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'New Writup',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 220,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Heading can't be empty";
                    }
                    newArticle['heading'] = value;
                    //String? inpHtml = await controller.getText();
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "An interesting heading",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 32),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 100,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 240,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      //return "Heading can't be empty";
                    }
                    newArticle['subHeading'] = value;
                    //String? inpHtml = await controller.getText();
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Add a sub-heading (optional)",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 200,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 120,
                child: TextFormField(
                  validator: (value) {
                    if (value != null) {
                      int nbrHasTags = value.split('#').length - 1;
                      print(nbrHasTags);
                      if (nbrHasTags > 5) {
                        return "Max 5 hash tags can be used";
                      }
                    }
                    if (value == null || value.isEmpty) {
                      //return "Heading can't be empty";
                    }
                    newArticle['tags'] = value;
                    //String? inpHtml = await controller.getText();
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText:
                        "Up to 5 tags (e.g #news #hollywood #morganfreeman)",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 100,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 30)),
            Text(
              "Your Writup on next page",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black38,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
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
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Add your onPressed code here!
            print('done pressed');
            //String inpHtml = await htmlcontroller.getText();
            //newArticle['detail'] = inpHtml;
            //print(inpHtml);
            if (_formKey1.currentState!.validate()) {
              print("form valid");
              //print(newArticle['details']);
              Navigator.pushNamed(
                context,
                '/createArticleDetail',
                arguments: {
                  'newArticle': newArticle,
                },
              );
              //postArticle(newArticle);
            }
            //Navigator.pushNamed(context, '/createArticle');
          },
          //label: const Text('4K'),
          child: Icon(Icons.arrow_forward_ios_rounded),
          //child: icon: const Icon(Icons.download),
          backgroundColor: floatingButtonColor,
        ),
      ),
    );
  }
}

class CreateArticleDetail extends StatefulWidget {
  //const CreatArticle({super.key});

  @override
  CreateArticleDetailState createState() {
    return CreateArticleDetailState();
  }
}

class CreateArticleDetailState extends State<CreateArticleDetail> {
  final _formKey1 = GlobalKey<FormState>();

  final _isPostingNotifier = ValueNotifier<bool>(false);
  final _isEmptyNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    _isPostingNotifier.value = false;
    _isEmptyNotifier.value = false;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    var newArticle = arg['newArticle'];
    QuillController _controller = QuillController.basic();

    return Form(
      key: _formKey1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'New Writup',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: QuillEditor.basic(
                    controller: _controller,
                    readOnly: false, // true for view only mode
                  ),
                ),
              ),),
              QuillToolbar.basic(controller: _controller,
                iconTheme: QuillIconTheme(
                  //iconSelectedColor: Colors.orangeAccent,
                  iconSelectedFillColor: Colors.orangeAccent,
                ),
                showColorButton: false,
                showBackgroundColorButton: false,
                showCodeBlock: false,
                showFontFamily: false,
                showClearFormat: false,
                showAlignmentButtons: true,
                showHeaderStyle: false,
                showInlineCode: false,
                showQuote: false,
                showIndent: false,
              showSearchButton: false,
              showLink: false,
              showListCheck: false,),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              ValueListenableBuilder(
                valueListenable: _isPostingNotifier,
                builder: (context, value, _) {
                  if (_isEmptyNotifier.value == true) {
                    return Column(
                      children: <Widget>[
                      Text(
                      "Writup can't be empty",
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                    ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 20))
                      ],);
                  }
                  return Text("");
                },
              ),
              //Padding(padding: EdgeInsets.symmetric(vertical: 60)),
            ],
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Add your onPressed code here!
            print('done pressed');
            _isPostingNotifier.value = true;
            var deltaJson = await _controller.document.toDelta().toJson();
            String plainText = _controller.document.toPlainText();
            final converter = QuillDeltaToHtmlConverter(
              List.castFrom(deltaJson),
              ConverterOptions.forEmail(),
            );
            String _html = converter.convert();
            print(_html);
            String inpHtml = _html;
            newArticle['detail'] = inpHtml;
            print(inpHtml);
            _isEmptyNotifier.value = false;
            if (inpHtml.length < 1 || plainText.trim() == '') {
              _isEmptyNotifier.value = true;
              _isPostingNotifier.value = false;
            } else {
              if (_formKey1.currentState!.validate()) {
                print("form valid");
                //print(newArticle['details']);
                await postArticle(newArticle);
                final snackBar = SnackBar(
                  content: const Text('Your Writup has been posted !!'),
                  backgroundColor: (Colors.black87),
                  //action: SnackBarAction(
                  //  label: 'dismiss',
                  //  onPressed: () {},
                  // ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              }
            }
            //Navigator.pushNamed(context, '/createArticle');
          },
          //label: const Text('4K'),
          child: ValueListenableBuilder(
            valueListenable: _isPostingNotifier,
            builder: (context, value, _) {
              if (_isPostingNotifier.value == false) {
                return Icon(Icons.done);
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          backgroundColor: floatingButtonColor,
        ),
      ),
    );
  }
}

Future<String> getJwt(user) async {
  final jwt = await user.getIdToken();
  //print("JWT is " + jwt);
  String jwt1 = jwt;
  return jwt1;
}

