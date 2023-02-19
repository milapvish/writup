import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'apiCalls.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  //const AuthScreen({Key key}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance;

  //CheckLoggedIn(user);

  var _isLoading = false;
  late var fcmtoken;

  onGoBack(dynamic value) {
    jwtGlobal = '';
    print("coming back to login page");
    setState(() {
      jwtGlobal = '';
      _isLoading = false;
      //_formKey.currentState.reset();
    });
  }

  var errorMessage = ' ';

  void _submitAuthForm(
      String email,
      String password,
      String name,
      bool isLogin,
      BuildContext ctx,
      ) async {
    // ignore: unused_local_variable
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        print("attempting login");
        print("printing password");
        print(password);
        try {
          userCredential = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          // Call to create FCM Token
          await CreateFCMToken(fcmtoken);
          print("logged in succesfully");
          print(userCredential);
          Navigator.pushNamed(context, '/home').then(onGoBack);
          //return "Success";
        } on FirebaseAuthException catch  (e) {
          print('Failed with error code: ${e.code}');
          print(e.message);
          String errMessage = '';
          if (e.message != null) {
            errMessage = e.message ?? '';
          }
          if (e.message != null)
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(errMessage),
            backgroundColor: Theme.of(ctx).errorColor,
          ));
          setState(() {
            _isLoading = false;
          });
          //return e.code;
        }
      } else {
        try {
          print("printing password");
          print(password);
          userCredential = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          await createAccount(email, name, fcmtoken);
          // Update Shared Pref
          // Obtain shared preferences.
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          await prefs.setString('name', name);
          print("now pushing home page");
          Navigator.pushNamed(context, '/home').then(onGoBack);
        } on FirebaseAuthException catch  (e) {
          print('Failed with error code: ${e.code}');
          print(e.message);
          String errMessage = '';
          if (e.message != null) {
            errMessage = e.message ?? '';
          }
          if (e.message != null)
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(errMessage),
              backgroundColor: Theme
                  .of(ctx)
                  .errorColor,
            ));
          setState(() {
            _isLoading = false;
          });
        }
      }
    } on PlatformException catch (err) {
      var message = "An error occured please check your credentails";

      /*if (err.message != null) {
        message = err.message;
      }*/

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      // ignore: avoid_print
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  late FirebaseMessaging messaging;

  @override
  Widget build(BuildContext context) {
    // Register for FCM
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print("printing FCM token value");
      print(value);
      fcmtoken = value;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
      //RemoteNotification notification = message.notification;
      print(message.messageType);
      print(message.data);
      print(message.category);
      print(message.notification!.body);
      print(message.notification!.title);
      print(message.notification!.hashCode);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {Key ?key}) : super(key: key);

  final bool isLoading;
  final void Function(
      String email,
      String password,
      String name,
      bool isLogin,
      BuildContext ctx,
      ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _name = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      print("auth form valid");
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _name.trim(),
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.only(
        top: 35,
        left: 25,
      ),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 92.0, 0.0, 0.0),
                    child: Image.asset(
                        'images/writup_logo.png',
                        height: 70,
                        width: 70),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(100.0, 90.0, 25.0, 0.0),
                    child: FittedBox(
                        child: Text('writup',
                        style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontSize: 80.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87)),
                  ),),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 250.0, 0.0, 0.0),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                      child: Text("Welcome"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 300.0, 0.0, 0.0),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                      child: Text("Again"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(265.0, 240.0, 30.0, 0.0),
                    child: FittedBox(
                      child: Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),),
                  ),),
                ],
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(
                          top: 54.0, left: 20.0, right: 30.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            key: const ValueKey('email'),
                            decoration: const InputDecoration(
                                labelText: 'EMAIL',
                                labelStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                )),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null || value.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _userEmail = value;
                              };
                            },
                          ),
                          if (!_isLogin) const SizedBox(height: 20.0),
                          if (!_isLogin)
                            TextFormField(
                              key: const ValueKey('name'),
                              decoration: const InputDecoration(
                                  labelText: 'NAME',
                                  labelStyle: TextStyle(
                                      fontFamily: 'RobotoCondensed',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.green))),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.words,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  _name = value;
                                };
                              },
                              // ignore: missing_return
                            ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            key: const ValueKey('password'),
                            decoration: const InputDecoration(
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                            ),
                            obscureText: true,

                            // ignore: missing_return
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 7 && _isLogin == false) {
                                return 'Please enter a long password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _userPassword = value;
                              };
                            },
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          if (widget.isLoading)
                            const CircularProgressIndicator(),
                          if (!widget.isLoading)
                            Container(
                              height: 57.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.black,
                                //color: const Color.fromRGBO(111, 105, 172, 1),
                                color: Colors.black87,
                                elevation: 10.0,
                                child: TextButton(
                                  onPressed: _trySubmit,
                                  child: Center(
                                    child: Text(
                                      _isLogin ? "Login" : "Sign up",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Raleway'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 25,
                          ),
                          if (!widget.isLoading)
                            Container(
                              height: 57.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(40.0),
                                color: Colors.white,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      _isLogin
                                          ? "Create new account"
                                          : "I already have an account",
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Raleway'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom)),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
