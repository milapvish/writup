import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'apiCalls.dart';

class AuthScreen extends StatefulWidget {
  //const AuthScreen({Key key}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance;
  //CheckLoggedIn(user);

  var _isLoading = false;

  onGoBack(dynamic value) {
    jwtGlobal = '';
    print("coming back to login page");
    setState(() {
      jwtGlobal = '';
      _isLoading = false;
      //_formKey.currentState.reset();
    });
  }

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
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print("logged in succesfully");
        Navigator.pushNamed(context, '/home').then(onGoBack);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await createAccount(email, name);
        print("now pushing home page");
        Navigator.pushNamed(context, '/home').then(onGoBack);
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


  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 0.0),
                    child: const Text('Hi',
                        style: TextStyle(
                            color: Color.fromRGBO(253, 111, 150, 1),
                            fontSize: 80.0,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 125.0, 0.0, 0.0),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(111, 105, 172, 1),
                      ),
                      child: Text("there again"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(235.0, 125.0, 0.0, 0.0),
                    child: const Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(111, 105, 172, 1))),
                  )
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
                                  labelText: 'Full Name',
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
                              if (value == null || value.isEmpty || value.length < 7) {
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
                                color: const Color.fromRGBO(111, 105, 172, 1),
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
                                          color:
                                          Color.fromRGBO(253, 111, 150, 1),
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
