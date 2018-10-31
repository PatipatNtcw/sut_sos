
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'sos.dart';
import 'package:flutter/services.dart';
import 'package:sut_sos/login/auth_provider.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sut_sos/style/theme.dart' as Theme;



final _uidsos = TextEditingController();
String _name1;
String _name2;
bool read = false;
Map<String,double> _locationNow;
final _telSOS = TextEditingController();
final _subnameSOS = TextEditingController();
final _lastnameSOS = TextEditingController();
final _studentIDSOS = TextEditingController();
final _pathImage = TextEditingController();
final _pathImage2 = TextEditingController();
final _pathImage3 = TextEditingController();
final _pathImage4 = TextEditingController();
final _pathImage5 = TextEditingController();
final _event = TextEditingController();
final _security = TextEditingController();
final _ambulance = TextEditingController();
final _fireman = TextEditingController();
final _sendId = TextEditingController();
DateTime now = DateTime.now();
double la,long;
Location _location = new Location();
bool _permission = false;
String error;
bool currentWidget = true;
Map<String, double> _startLocation;
Map<String, double> _currentLocation;

StreamSubscription<Map<String, double>> _locationSubscription;

class ShowSentScreen extends StatefulWidget {
  final VoidCallback onSignedOut;
  final String tel;
  final String subname;
  final String lastname;
  final String studentID;
  final String event;
  final String security;
  final String ambulance;
  final String fireman;
  File fileImage1;
  File fileImage2;
  File fileImage3;
  File fileImage4;
  File fileImage5;

  ShowSentScreen({this.onSignedOut,this.tel,this.subname,this.lastname,this.studentID,this.event,this.security,this.ambulance,this.fireman,this.fileImage1,this.fileImage2,this.fileImage3,this.fileImage4,this.fileImage5});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<ShowSentScreen> {
 void next(){
   new Future.delayed(new Duration(seconds: 1), (){
     var rount = new MaterialPageRoute(
         builder: (
             BuildContext contex) => new SosPage(
         )
     );
     Navigator.of( context ).pushReplacement( rount );
   }
   );
 }
  /*void didChangeDependencies() async{
    super.didChangeDependencies();
    new Future.delayed(new Duration(seconds: 1), (){
      var rount = new MaterialPageRoute(
          builder: (
              BuildContext contex) => new SosPage(
          )
      );
      Navigator.of( context ).pushReplacement( rount );
    }
    );
  }*/
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
  void setValue(){
      _telSOS.text = widget.tel ;
      _subnameSOS.text = widget.subname ;
      _lastnameSOS.text = widget.lastname ;
      _studentIDSOS.text = widget.studentID ;
      _event.text = widget.event ;
      _security.text = widget.security ;
      _ambulance.text = widget.ambulance ;
      _fireman.text = widget.fireman ;

  }
  Future<Null> uploadFile() async {
    String numberImage;
    String _path;
    numberImage = "${Random().nextInt(100000)}.jpg";
    final StorageReference fireStorageRef = FirebaseStorage.instance.ref().child(numberImage);
    final StorageUploadTask task = fireStorageRef.putFile(widget.fileImage1);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    _pathImage.text = _path;
  }
  Future<Null> uploadFile2() async {
    String numberImage;
    String _path;
    numberImage = "${Random().nextInt(100000)}.jpg";
    final StorageReference fireStorageRef = FirebaseStorage.instance.ref().child(numberImage);
    final StorageUploadTask task = fireStorageRef.putFile(widget.fileImage2);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    _pathImage2.text = _path;
  }
  Future<Null> uploadFile3() async {
    String numberImage;
    String _path;
    numberImage = "${Random().nextInt(100000)}.jpg";
    final StorageReference fireStorageRef = FirebaseStorage.instance.ref().child(numberImage);
    final StorageUploadTask task = fireStorageRef.putFile(widget.fileImage3);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    _pathImage3.text = _path;
  }
  Future<Null> uploadFile4() async {
    String numberImage;
    String _path;
    numberImage = "${Random().nextInt(100000)}.jpg";
    final StorageReference fireStorageRef = FirebaseStorage.instance.ref().child(numberImage);
    final StorageUploadTask task = fireStorageRef.putFile(widget.fileImage4);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    _pathImage4.text = _path;
  }
  Future<Null> uploadFile5() async {
    String numberImage;
    String _path;
    numberImage = "${Random().nextInt(100000)}.jpg";
    final StorageReference fireStorageRef = FirebaseStorage.instance.ref().child(numberImage);
    final StorageUploadTask task = fireStorageRef.putFile(widget.fileImage5);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    _pathImage5.text = _path;
  }
  @override
  DatabaseReference itemRef;
  DatabaseReference itemRef1;
  Sent sent;
  SentLocation sentLocation;
  void initState (){
    super.initState();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged().listen((Map<String,double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
    setValue();
    sentValue();

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
      _locationNow = location;
    });

  }
  void handleSubmit ()  {
    sent = Sent(
        _telSOS.text,
        _subnameSOS.text,
        _lastnameSOS.text,
        _studentIDSOS.text,
        _pathImage.text,
        _pathImage2.text,
        _pathImage3.text,
        _pathImage4.text,
        _pathImage5.text,
        _event.text,
        _security.text,
        _ambulance.text,
        _fireman.text,
        read,
        now.millisecondsSinceEpoch
    );
    sentLocation = SentLocation(
      la,//lati
      long,//longti
    );
    final FirebaseDatabase database = FirebaseDatabase.instance; //Rather then just writing FirebaseDatabase(), get the instance.
    String mGroupId = database.reference().push().key;
    _sendId.text = mGroupId;
    itemRef = database.reference( ).child( 'SOS_Case' );
    itemRef1= database.reference( ).child( 'SOS_Case' ).child(mGroupId)/*.child(formattedDate+"-- Uid => "+_uidSOS.text)*/;
    itemRef.child(mGroupId)/*.child(formattedDate+"-- Uid => "+_uidSOS.text)*/.set( sent.toJson( ));
    itemRef1.child( 'location' ).set( sentLocation.toJson( ) );
    next();
  }
  void setDataLogOut(){
    _subnameSOS.clear();
    _lastnameSOS.clear();
    _telSOS.clear();
    _studentIDSOS.clear();
    _event.clear();
    _security.clear();
    _ambulance.clear();
    _fireman.clear();
    _pathImage.clear();
    _pathImage2.clear();
    _pathImage.clear();
    _pathImage2.clear();
    _pathImage3.clear();
    _pathImage4.clear();
    _pathImage5.clear();
  }
  Future<void> sentValue()async{

    if(widget.fileImage1 != null &&widget.fileImage2 == null&&widget.fileImage3 == null&&widget.fileImage4 == null&&widget.fileImage5== null){
     await uploadFile();
      handleSubmit();
      setDataLogOut();
    }else if(widget.fileImage1 != null &&widget.fileImage2 != null&&widget.fileImage3 == null&&widget.fileImage4 == null&&widget.fileImage5== null){
      await uploadFile();
      await uploadFile2();
       handleSubmit();
       setDataLogOut();
    }else if(widget.fileImage1 != null &&widget.fileImage2 != null&&widget.fileImage3 != null&&widget.fileImage4 == null&&widget.fileImage5== null){
      await uploadFile();
      await uploadFile2();
      await uploadFile3();
       handleSubmit();
      setDataLogOut();
    }else if(widget.fileImage1 != null &&widget.fileImage2 != null&&widget.fileImage3 != null&&widget.fileImage4 != null&&widget.fileImage5== null){
      await uploadFile();
      await uploadFile2();
      await uploadFile3();
      await uploadFile4();
      handleSubmit();
      setDataLogOut();
    }else if(widget.fileImage1 != null &&widget.fileImage2 != null &&widget.fileImage3 != null&&widget.fileImage4 != null&&widget.fileImage5!= null){
      await uploadFile();
      await uploadFile2();
      await uploadFile3();
      await uploadFile4();
      await uploadFile5();
      handleSubmit();
      setDataLogOut();
    }
    else{
      handleSubmit();
       setDataLogOut();
    }
    didChangeDependencies();
  }
  Widget build(BuildContext context){
    //didChangeDependencies();
    //uploadFile();
    print(_subnameSOS.text);
    print(_lastnameSOS.text);
    print(_studentIDSOS.text);
    //handleSubmit ();
    return Scaffold(
      body:Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
            child: Center(
                child: new Column(
                  children: <Widget>[
                    new Image.asset("assets/pics/logo_sut.png",width: 250.0,height: 500.0,),
                    new Container(
                      padding: new EdgeInsets.all(32.0),
                      child:
                       Column(
                         children: <Widget>[
                           new Text("กำลังดำเนินการแจ้งเหตุฉุกเฉิน"),
                           SizedBox(height: 8.0),
                           LinearProgressIndicator(),
                         ],
                       )
                      //LinearProgressIndicator(),
                    ),
                  ],
                )

            ),
          ),

        ],
      ),
    );
  }
}
class Sent {
  String tel;
  String subname;
  String lastname;
  String studentId;
  String pathimage;
  String pathimage2;
  String pathimage3;
  String pathimage4;
  String pathimage5;
  String event;
  String security;
  String ambulance;
  String fireman;
  bool read;
  int date;


  Sent( this.tel,this.subname,this.lastname,this.studentId,this.pathimage,this.pathimage2,this.pathimage3,this.pathimage4,this.pathimage5,this.event,this.security,this.ambulance,this.fireman,this.read,this.date);

  Sent.fromSnapshot(DataSnapshot snapshot)
      :
        tel = snapshot.value["tel"],
        subname = snapshot.value["subname"],
        lastname = snapshot.value["lastname"],
        studentId = snapshot.value["studentId"],
        pathimage = snapshot.value["pathImage"],
        pathimage2 = snapshot.value["pathImage2"],
        pathimage3 = snapshot.value["pathImage3"],
        pathimage4 = snapshot.value["pathImage4"],
        pathimage5 = snapshot.value["pathImage5"],
        event =  snapshot.value["event"],
        security = snapshot.value["security"],
        ambulance =  snapshot.value["ambulance"],
        fireman  =  snapshot.value["fireman"],
        read =  snapshot.value["read"],
        date = snapshot.value["date"];

  toJson() {
    return {
      "tel" : _telSOS.text,
      "subname":_subnameSOS.text,
      "lastname":_lastnameSOS.text,
      "studentID":_studentIDSOS.text,
      "pathImage" : _pathImage.text,
      "pathImage2" : _pathImage2.text,
      "pathImage3" : _pathImage3.text,
      "pathImage4" : _pathImage4.text,
      "pathImage5" : _pathImage5.text,
      "event" : _event.text,
      "security" : _security.text,
      "ambulance" : _ambulance.text,
      "fireman" : _fireman.text,
      "read" : read,
      "date" : DateTime.now().millisecondsSinceEpoch,
    };
  }
}
class SentLocation {
  double lat;
  double lng;
  SentLocation(this.lat,this.lng);

  SentLocation.fromSnapshot(DataSnapshot snapshot)
      :
        lat = snapshot.value["lat"],
        lng = snapshot.value["lng"];

  toJson() {
    return {
      "lat" : _locationNow["latitude"],
      "lng" : _locationNow["longitude"],
    };
  }
}
