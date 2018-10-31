
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'sos.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sut_sos/login/auth_provider.dart';





final _uidsos = TextEditingController();
String _name1;
String _name2;

class ShowSentScreen extends StatefulWidget {
  final VoidCallback onSignedOut;
  final String sendId;

  ShowSentScreen({this.onSignedOut,this.sendId});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<ShowSentScreen> {
  void didChangeDependencies() async{
    super.didChangeDependencies();
      FirebaseDatabase.instance.reference().child("SOS_Case").child(widget.sendId).once().then((DataSnapshot snapshot) {
        var item = new Sent.fromSnapshot(snapshot);

      });
  }
  String error;

  bool currentWidget = true;
  void _signOut(BuildContext context) async {
    try {
      var auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState (){
    super.initState();


  }
  Widget build(BuildContext context) {
    //didChangeDependencies();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body:Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
            child: Center(

                child: new Column(
                  children: <Widget>[
                    new Image.asset("assets/pics/logo_sut.png",width: 250.0,height: 500.0,),
                    CircularProgressIndicator(),
                  ],
                )

            ),
          ),

        ],
      ),
    );
  }
}