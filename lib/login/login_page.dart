import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sut_sos/login/auth_provider.dart';
import 'package:sut_sos/registerUser.dart';
import 'package:flutter/services.dart';
import 'package:sut_sos/Show.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sut_sos/style/theme.dart' as Theme;
import 'package:sut_sos/utils/bubble_indication_painter.dart';


class LoginPage extends StatefulWidget {
  LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}
enum FormType {
  login
}
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final _email = TextEditingController();
final _password = TextEditingController();
final _uid = TextEditingController();
class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  Color left = Colors.black;
  Color right = Colors.white;
  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  void validateAndSubmit() async {
    showInSnackBar("ระบบกำลังทำการตรวจสอบข้อมูลของท่าน");
    print("GO GO");
    print(_email.text +"   "+_password.text);
    if (validateAndSave()) {
      try {
        var auth = AuthProvider.of(context).auth;
        if (_formType == FormType.login) {
          String userId = await auth.signInWithEmailAndPassword(_email.text, _password.text);
          var rount = new MaterialPageRoute(
              builder: (
                  BuildContext context) => new SplashScreen()
          );
          Navigator.of( context ).pushReplacement( rount );
          print('Signed in: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
      }
    }
  }
  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromARGB( 255, 165, 0, 0 ),
        title: new Text( "SUT Rescue SOS Emergency" ),
      ),
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientStart,
                    Theme.Colors.loginGradientEnd
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 75.0),
                  child: new Container(
                    width: 250.0,
                    height: 80.0,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignIn(context),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }
  Widget _buildSignIn(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child:
              Form(
                key:formKey,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Card(
                            elevation: 2.0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: 300.0,
                              height: 170.0,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                                    child: TextField(
                                      //focusNode: myFocusNodeEmailLogin,
                                      controller: _email,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.envelope,
                                          color: Colors.black,
                                          size: 22.0,
                                        ),
                                        hintText: "Email Address",
                                        hintStyle: TextStyle(
                                            fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 200.0,
                                    height: 2.0,
                                    color: Colors.grey[400],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0, bottom: 10.0, left: 25.0, right: 25.0),
                                    child: TextField(
                                      //focusNode: myFocusNodePasswordLogin,
                                      controller: _password,
                                      obscureText: _obscureTextLogin,
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 16.0,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.lock,
                                          size: 22.0,
                                          color: Colors.black,
                                        ),
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                                        suffixIcon: GestureDetector(
                                          onTap: _toggleLogin,
                                          child: Icon(
                                            FontAwesomeIcons.eye,
                                            size: 15.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Theme.Colors.loginGradientStart,
                                  offset: Offset(1.0, 6.0),
                                  blurRadius: 20.0,
                                ),
                                BoxShadow(
                                  color: Theme.Colors.loginGradientEnd,
                                  offset: Offset(1.0, 6.0),
                                  blurRadius: 20.0,
                                ),
                              ],
                              gradient: new LinearGradient(
                                  colors: [
                                    Theme.Colors.loginGradientEnd,
                                    Theme.Colors.loginGradientStart
                                  ],
                                  begin: const FractionalOffset(0.2, 0.2),
                                  end: const FractionalOffset(1.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: MaterialButton(
                              highlightColor: Colors.transparent,
                              splashColor: Theme.Colors.loginGradientEnd,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 42.0),
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontFamily: "WorkSansBold"),
                                ),
                              ),
                              // onPressed: () => showInSnackBar("Login button pressed")
                              onPressed: () {
                                validateAndSubmit();
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                gradient: new LinearGradient(
                                    colors: [
                                      Colors.white10,
                                      Colors.white,
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 1.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              width: 100.0,
                              height: 1.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Text(
                                "Or",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontFamily: "WorkSansMedium"),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: new LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white10,
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 1.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              width: 100.0,
                              height: 1.0,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        // alignment: Alignment.topCenter,
                        //  overflow: Overflow.visible,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Theme.Colors.loginGradientStart,
                                  offset: Offset(1.0, 6.0),
                                  blurRadius: 20.0,
                                ),
                                BoxShadow(
                                  color: Theme.Colors.loginGradientEnd,
                                  offset: Offset(1.0, 6.0),
                                  blurRadius: 20.0,
                                ),
                              ],
                              gradient: new LinearGradient(
                                  colors: [
                                    Theme.Colors.loginGradientEnd,
                                    Theme.Colors.loginGradientStart
                                  ],
                                  begin: const FractionalOffset(0.2, 0.2),
                                  end: const FractionalOffset(1.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: MaterialButton(
                              highlightColor: Colors.transparent,
                              splashColor: Theme.Colors.loginGradientEnd,
                              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 42.0),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontFamily: "WorkSansBold"),
                                ),
                              ),
                              onPressed: () {
                                var rount = new MaterialPageRoute(
                                    builder: (
                                        BuildContext contex) => new RegisterUser()
                                );
                                Navigator.of( context ).push( rount );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),)
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }


}