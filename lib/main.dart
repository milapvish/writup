import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'homeTabView.dart';
import 'followingTabView.dart';
import 'myPostsTabView.dart';
import 'viewArticle.dart';
import 'apiCalls.dart';
import 'login.dart';
import 'myDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'consts.dart';
import 'dart:async';
import 'package:flutter/services.dart';
//import 'package:csv_reader/csv_reader.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

HtmlEditorController htmlcontroller = HtmlEditorController();
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
    }
    else {
      firstWidget = AuthScreen();
    }

    return MaterialApp(
      title: 'AI Art',
      routes: {
        '/': (context) => firstWidget,
        '/login': (context) => AuthScreen(),
        '/home': (context) => HomePage(),
        '/createArticle': (context) => CreateArticle(),
        '/viewArticle': (context) => ViewArticle(),
      },
      theme: ThemeData(
        primarySwatch: Colors.brown,
        //scaffoldBackgroundColor: Colors.grey[900],
        //fontFamily: GoogleFonts.robotoFlex().fontFamily,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  var data = new HomeTabView(7);
  @override
  Widget build(BuildContext context) {
    print(data.test);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        endDrawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'writup',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home_filled)),
              Tab(icon: Icon(Icons.people)),
              Tab(icon: Icon(Icons.person)),
            ],
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
          backgroundColor: Colors.red[900],
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
            'write article',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 150,
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
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 100,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 160,
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
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 200,
                ),
              ),
            ),
            HtmlEditor(
              controller: htmlcontroller, //required
              htmlEditorOptions: HtmlEditorOptions(
                hint: "Write as much as you want :)",
                //initalText: "text content initial, if any",
              ),
              otherOptions: OtherOptions(
                height: 380,
              ),
              htmlToolbarOptions: HtmlToolbarOptions(defaultToolbarButtons: [
                //StyleButtons(),
                FontButtons(
                    clearAll: false,
                    strikethrough: false,
                    superscript: false,
                    subscript: false),
              ]),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 80,
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
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Add your onPressed code here!
            print('done pressed');
            String inpHtml = await htmlcontroller.getText();
            newArticle['detail'] = inpHtml;
            print(inpHtml);
            if (_formKey1.currentState!.validate()) {
              print("form valid");
              //print(newArticle['details']);
              postArticle(newArticle);
            }
            //Navigator.pushNamed(context, '/createArticle');
          },
          //label: const Text('4K'),
          child: Icon(Icons.done),
          //child: icon: const Icon(Icons.download),
          backgroundColor: Colors.red[900],
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