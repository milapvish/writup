import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:writup/main.dart';
import 'apiCalls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'consts.dart';

class EditProfile extends StatefulWidget {
  //const CreatArticle({super.key});

  @override
  EditProfileState createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfile> {
  final _formKey1 = GlobalKey<FormState>();

  final _isPostingNotifier = ValueNotifier<bool>(false);
  final _isEmptyNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    print("I am here bidu");
    _isPostingNotifier.value = false;
    _isEmptyNotifier.value = false;
    //final arg = ModalRoute.of(context)!.settings.arguments as Map;

    final _dpUrlNotifier = ValueNotifier<String>("");
    ImagePicker picker = ImagePicker();
    XFile? image;

    var profileMap = new Map();

    return Form(
      key: _formKey1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: FutureBuilder(
          future: fetchAccountDetails(0),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black54,
                ),
              );
            } else {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else
                print('i am here in following');
              //print(snapshot.data[1][4]);
              print(snapshot.data.length);
              _dpUrlNotifier.value = snapshot.data[1][14];
              return Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 320,
                    color: Colors.black87,
                    child: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        ValueListenableBuilder(
                          valueListenable: _dpUrlNotifier,
                          builder: (context, value, _) {
                            imageCache.clear();
                            PaintingBinding.instance.imageCache.clear();
                            imageCache.clearLiveImages();
                            print("DP URL " + _dpUrlNotifier.value);
                            return CircleAvatar(
                              backgroundColor: Colors.white,
                              //backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/writup-hermit-owl.appspot.com/o/profilepics%2Ftest.jpg?alt=media&token=77cfbd62-2b35-4592-bdf4-1c2f9a048ce0"),
                              backgroundImage:
                                  NetworkImage(_dpUrlNotifier.value),
                              radius: 70,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  child: Transform.rotate(
                                    angle: 4.7,
                                    child:
                                        Icon(Icons.mode_edit_outline_outlined),
                                  ),
                                  onPressed: () async {
                                    print("pic edit pressed");
                                    image = await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 70,
                                        maxHeight: 512,
                                        maxWidth: 512);
                                    final storageRef =
                                        FirebaseStorage.instance.ref();
                                    final testImagesRef = storageRef.child(
                                        "profilepics/" +
                                            snapshot.data[1][0].toString() +
                                            ".jpeg");
                                    testImagesRef.putFile(File(image!.path));
                                    var testurl =
                                        await testImagesRef.getDownloadURL();
                                    snapshot.data[1][14] = testurl;
                                    _dpUrlNotifier.value = testurl;
                                    var profileMap = Map();
                                    profileMap['dp_url'] = testurl;
                                    updateProfile(profileMap);
                                    print(testurl);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    backgroundColor: Colors.orange,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        FittedBox(
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                    'images/writup_logo_inverted.png',
                                    height: 25,
                                    width: 25),
                                Text(
                                  ' ' + snapshot.data[1][6].toString(),
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      //fontStyle: FontStyle.italic,
                                      //letterSpacing: 5,
                                      //wordSpacing: 2,
                                      //backgroundColor: Colors.yellow,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black54,
                                            offset: Offset(1, .5),
                                            blurRadius: 10)
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 3)),
                        FittedBox(
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.star, color: Colors.white),
                                  Text(
                                    ' ' + snapshot.data[1][8].toString(),
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
                                        ]),
                                  ),
                                  Text(
                                    ' by ',
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
                                        ]),
                                  ),
                                  Text(
                                    snapshot.data[1][7].toString(),
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
                                        ]),
                                  ),
                                  Text(
                                    ' readers on ',
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
                                        ]),
                                  ),
                                  Text(
                                    snapshot.data[1][13].toString(),
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
                                        ]),
                                  ),
                                  Text(
                                    ' writups',
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
                                        ]),
                                  ),
                                ]),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 15)),
                        Text(
                          snapshot.data[1][12].toString() + ' Followers',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              //letterSpacing: 5,
                              //wordSpacing: 2,
                              //backgroundColor: Colors.yellow,
                              shadows: [
                                Shadow(
                                    color: Colors.black54,
                                    offset: Offset(1, .5),
                                    blurRadius: 10)
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                  child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            " Display Name",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                        TextFormField(
                          readOnly: false,
                          cursorColor: Colors.black26,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name is required ";
                            }
                            profileMap['name'] = value.trim();
                            return null;
                          },
                          initialValue: snapshot.data[1][2].toString(),
                          decoration: InputDecoration(
                            hintText: "Your Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  (BorderSide(width: 3, color: Colors.black54)),
                            ),
                            fillColor: Colors.black12,
                            filled: true,
                          ),
                          style: const TextStyle(fontSize: 16),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 100,
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            " Email",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                        TextFormField(
                          readOnly: true,
                          cursorColor: Colors.black26,
                          validator: (value) {
                            if (value != null) {
                              int nbrHasTags = value.split('#').length - 1;
                              print(nbrHasTags);
                              if (nbrHasTags > 5) {
                                return "Max 5 hash tags can be used";
                              }
                            }
                            if (value == null || value.isEmpty) {
                              return "Email is required ";
                            }
                            //newArticle['tags'] = value;
                            //String? inpHtml = await controller.getText();
                            return null;
                          },
                          initialValue: snapshot.data[1][1].toString(),
                          decoration: InputDecoration(
                            hintText: "Your Email Address",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  (BorderSide(width: 3, color: Colors.black54)),
                            ),
                            fillColor: Colors.black12,
                            filled: true,
                          ),
                          style: const TextStyle(fontSize: 16),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 100,
                        ),
                      ],
                    ),
                  ),),),
                ],
              );
            }
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: FloatingActionButton(
            onPressed: () async {
              // Add your onPressed code here!
              print('done pressed');
              _isPostingNotifier.value = true;
              if (_formKey1.currentState!.validate()) {
                print("form valid");
                //print(newArticle['details']);
                await updateProfile(profileMap);
                final snackBar = SnackBar(
                  content: const Text('Profile Updated !!'),
                  backgroundColor: (Colors.black87),
                  //action: SnackBarAction(
                  //  label: 'dismiss',
                  //  onPressed: () {},
                  // ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                _isPostingNotifier.value = false;
                //int count = 0;
                //Navigator.of(context).popUntil((_) => count++ >= 2);
              }
            },
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
      ),
    );
  }
}
