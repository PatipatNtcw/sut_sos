
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'sos.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sut_sos/login/auth_provider.dart';
import 'registerUser.dart';
import 'package:location/location.dart';




final _uidsos = TextEditingController();
String _name1;
String _name2;

class SplashScreen extends StatefulWidget {
  final VoidCallback onSignedOut;
  final String uid;
  SplashScreen({this.onSignedOut,this.uid});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  void didChangeDependencies() async{
    super.didChangeDependencies();
    var auth = AuthProvider.of(context).auth;
     auth.currentUser().then((userId) {
      _uidsos.text = userId;
       FirebaseDatabase.instance.reference().child("registerUser").child(_uidsos.text).once().then((DataSnapshot snapshot) {
        var item = new Item.fromSnapshot(snapshot);
         new Future.delayed(new Duration(seconds: 1), (){
          var rount = new MaterialPageRoute(
              builder: (
                  BuildContext contex) => new SosPage(
                mail: item.email,
                name1: item.subname,
                name2: item.lastname,
                uidsos: userId,
                bloodSOS: item.blood,
                Sid: item.studentId,
                tel1: item.tel,
                pass: item.password,
              )
          );
          Navigator.of( context ).pushReplacement( rount );
        });
      });
        print("Uid ==> "+userId);
    });
  }
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();
  bool _permission = false;
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
    initPlatformState();

    _locationSubscription =
        _location.onLocationChanged().listen((Map<String,double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
  }
  initPlatformState() async {
    Map<String, double> location;
    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }
    setState(() {
      _startLocation = location;
    });

  }
  Widget build(BuildContext context) {
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