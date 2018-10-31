import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sut_sos/login/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'showProfile.dart';
import 'package:sut_sos/login/login_page.dart';
import 'changeTel.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'testHome.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sut_sos/style/theme.dart' as Theme;
import 'Show.dart';
import 'showSend.dart';

class SosPage extends StatefulWidget{
  final String mail;
  final String name1;
  final String name2;
  final String tel1;
  final String Sid;
  final String uidsos;
  final String bloodSOS;
  final String pass;
  final VoidCallback onSignedOut;
  SosPage({Key key, this.mail,this.name1,this.name2,this.tel1,this.Sid,this.uidsos,this.bloodSOS,this.pass,this.onSignedOut});
  @override
  _SosPage createState() => _SosPage();
}
Map<String,double> _locationNow;
double _lo;
final _uidSOS = TextEditingController();
final _emailSOS = TextEditingController();
final _subnameSOS = TextEditingController();
final _lastnameSOS = TextEditingController();
final _telSOS = TextEditingController();
final _studentIDSOS = TextEditingController();
final _event = TextEditingController();
final _security = TextEditingController();
final _ambulance = TextEditingController();
final _fireman = TextEditingController();
final _pathImage = TextEditingController();
final _pathImage2 = TextEditingController();
final _pathImage3 = TextEditingController();
final _pathImage4 = TextEditingController();
final _pathImage5 = TextEditingController();
final _bloodSOS = TextEditingController();
final _pass = TextEditingController();
final _sendId = TextEditingController();
class _SosPage extends State<SosPage>{

  void _signOut(BuildContext context) async {
    try {
      var auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      //_permission = await _location.hasPermission();
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
  final Key keyOne = PageStorageKey('pageOne');
  final Key keyTwo = PageStorageKey('pageTwo');
  final Key keyThree = PageStorageKey('pageThree');
  int currentTab = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  PageOne one;
  PageTwo two;
  PageThree three;
  List<Widget> pages;
  List<Widget> pages2;
  Widget currentPage;
  Widget currentPage2;



  @override
  void initState() {
    super.initState();
    super.initState();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged().listen((Map<String,double> result) {
          setState(() {
            _locationNow =  result;
           // print("locationPage0 => "+_locationNow.toString());
          });
        });

    one = PageOne(
      key: keyOne,
    );
    two = PageTwo(
      key: keyTwo,
    );
    three = PageThree(
      key: keyThree,
    );
    pages = [one, two,three];
    currentPage = one;

  }
  void setDataLogOut(){
    _uidSOS.clear();
    _emailSOS.clear();
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
    _bloodSOS.clear();
    _pathImage.clear();
    _pathImage2.clear();
    _pathImage3.clear();
    _pathImage4.clear();
    _pathImage5.clear();
  }
  @override
  Widget build(BuildContext context) {
    dataSOS(widget.mail,widget.name1,widget.name2,widget.tel1,widget.Sid,widget.uidsos,widget.bloodSOS,widget.pass);
    final current = PageStorage(
    child: currentPage,
    bucket: bucket,
  );
    //pages.add(new Text("No Location"),
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 165, 0, 0),
        title: new Text("SUT Rescue SOS Emergency"),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.refresh,color: Colors.grey,),
              onPressed:  (){
                setDataLogOut();
                var rount = new MaterialPageRoute(
                    builder: (
                        BuildContext contex) => SplashScreen(
                    )
                );
                Navigator.of( context ).pushReplacement( rount );

              }
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
      body:

      new Container(
        child:current
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_in_talk),
            title: Text("PhoneSUT"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
          ),
        ],
      ),
    );
  }
}
void dataSOS(String maildata,String subnamedata,String lastnamedata,String teldata,String studentiddata,String uid,String blood,String pass){
  _emailSOS.text = maildata;
  _subnameSOS.text = subnamedata;
  _lastnameSOS.text= lastnamedata;
  _telSOS.text = teldata;
  _studentIDSOS.text=studentiddata;
  _uidSOS.text=uid;
  _bloodSOS.text = blood;
  _pass.text = pass;
}
Map<String, double> _startLocation;
Map<String, double> _currentLocation;
StreamSubscription<Map<String, double>> _locationSubscription;
Location _location = new Location();
bool _permission = false;
String error;
double la,long;
DateTime now = DateTime.now();
String formattedDate = DateFormat('kk:mm:ss'+'--'+'EEE d MMM').format(now);
class PageOne extends StatefulWidget {
  PageOne({Key key}) : super(key: key);
  @override
  PageOneState createState() => PageOneState();
}
class PageOneState extends State<PageOne> {

  bool currentWidget = true;
  Image image1;


  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      //_permission = await _location.hasPermission();
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
  void initState (){
    super.initState();
    initPlatformState();
  }
  DatabaseReference itemRef;
  DatabaseReference itemRef1;
  bool status = false;
  void handleSubmit ()  {
    _locationSubscription = _location.onLocationChanged().listen((Map<String,double> result) {
      setState(() {
        _locationNow =  result;
      });
    });
  }
  void show(){
    showDialog(
      context: (context),
      builder:(BuildContext context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children : <Widget>[
                Expanded(
                  child: //status == true ?
                  Text(
                    "โปรดรอการติดต่อกลับ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                  //: LinearProgressIndicator()
                )
              ],
            ),

            actions: <Widget>[
              FlatButton(
                  child: Text('OK'),
                onPressed: () => Navigator.pop(context),
                  )
            ],
          );

      },
    );
  }
  void showTableUpload(){
    Table(
         border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            Text("image1"),
          ]
        ),
        TableRow(
        children: [
        Text("image2"),
    ]
    )
      ],
    );
  }
  void showSending(){
    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children : <Widget>[
              Expanded(
                child: LinearProgressIndicator()
        ),

            ],
          ),
          actions: <Widget>[
             FlatButton(
                child: Text('cancle'),
                onPressed: () {
                 /* var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>SosPage(),
                  );
                  Navigator.of(context).pushReplacement(route);*/
                })
          ],
        );

      },
    );
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File image ;
  File image2;
  File image3;
  File image4;
  File image5;
  File image6;
  int num = 0;
  /*Sent sent;
  SentLocation sentLocation;*/

  Future <void> getImage() async{
    File img = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 300.0,maxWidth: 300.0);
    setState(() {
        image = img;
    });
  }
  Future <void> getImageG() async{
    File img1 = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 300.0,maxWidth: 300.0);
    setState(() {
      image = img1;
    });
  }
  Future <void> getImage2() async{
    File img2 = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 300.0,maxWidth: 300.0);
    setState(() {
      image2 = img2;
    });
  }
  Future <void> getImageG2() async{
    File img2 = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 300.0,maxWidth: 300.0);
    setState(() {
      image2 = img2;
    });
  }
  Future <void> getImage3() async{
    File img3 = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 300.0,maxWidth: 300.0);
    setState(() {
      image3 = img3;

    });
  }
  Future <void> getImageG3() async{
    File img3 = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 250.0,maxWidth: 250.0);
    setState(() {
      image3 = img3;
    });
  }
  Future <void> getImage4() async{
    File img4 = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 300.0,maxWidth: 300.0);
    setState(() {
      image4 = img4;

    });
  }
  Future <void> getImageG4() async{
    //File img = await ImagePicker.pickImage(source: ImageSource.camera);
    File img4 = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 300.0,maxWidth: 300.0);
    setState(() {
      image4 = img4;
    });
  }
  Future <void> getImage5() async{
    File img5 = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 300.0,maxWidth: 300.0);
    setState(() {
      image5 = img5;

    });
  }
  Future <void> getImageG5() async{
    File img5 = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 300.0,maxWidth: 300.0);
    setState(() {
      image5 = img5;
    });
  }
  final taxtdetail = TextField(
    keyboardType: TextInputType.text,
    controller: _event,
    maxLengthEnforced: false,
    maxLines: null,
    decoration: InputDecoration(
      labelText: 'รายละเอียดเพิ่มเติม',
      hintText: 'รายละเอียดเพิ่มเติม',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
    ),
  );
  @override
  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;

  void osecurity(bool e){
    setState(() {
      _value1 =  e;
      if(_value1 == true){
        _security.text = 'want';
      }else{
        _security.text = 'no want';
      }
      print("security  : "+_security.text);
    });
  }
  void oambulance(bool e){
    _ambulance.text = 'no want';
    setState(() {
      _value2 =  e;
      if(_value2 == true) {
        _ambulance.text = 'want';
      }else{
        _ambulance.text = 'no want';
      }
      print("ambulance : "+_ambulance.text);

    });
  }
  void fire(bool e){
    _value3 =  e;
    setState(() {
      print("e  :   "+_value3.toString());
      if(_value3 == true){
        _fireman.text = 'want';
      }else{
        _fireman.text = 'no want';
      }
      print("fireman : "+_fireman.text);

    });
  }
  //int numClick=0;
   int numClick=0;
  Future<Null> _askedToLead() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: const Text('Select photo'),
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () {
                  if(numClick==0){
                    getImage();
                    numClick++;
                  }else if(numClick==1){
                    getImage2();
                    numClick++;
                  }else if(numClick==2){
                    getImage3();
                    numClick++;
                  }else if(numClick==3){
                    getImage4();
                    numClick++;
                  }else if(numClick==4){
                    getImage5();
                    numClick=0;
                  }

                  },
                child: const Text('Camera'),
              ),
              new SimpleDialogOption(
                onPressed: () {
                  if(numClick==0){
                    getImageG();
                    numClick++;
                  }else if(numClick==1){
                    getImageG2();
                    numClick++;
                  }else if(numClick==2){
                    getImageG3();
                    numClick++;
                  }else if(numClick==3){
                    getImageG4();
                    numClick++;
                  }else if(numClick==4){
                    getImageG5();
                    numClick=0;
                  }
                  },
                child: const Text('Gallery'),
              ),
            ],
          );
        }
    )){}
  }
  Widget build(BuildContext context) {
    return new Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height ,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientStart,
                    Theme.Colors.loginGradientEnd
                  ], ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PageView(
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSOS(context),
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
  bool check = false;
  Widget _buildSOS(BuildContext context) {

    return Container(
        padding: EdgeInsets.only(top: 23.0),
        child:
        Form(
          child: Column(
            children: <Widget>[
          new Container(

            padding: const EdgeInsets.all(20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only( left: 15.0, right: 10.0, top: 5.0 ),
                  child:
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    textBaseline: TextBaseline.ideographic,
                    children: <Widget>[
                      new Container(
                        child: image5 == null
                            ? new RaisedButton(
                          highlightElevation: 10.0,
                          onPressed: _askedToLead,
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: new Icon(Icons.camera_alt),
                        )
                            :null
                      ),
                      new Container(
                        child: image != null
                            ? new Image.file(image,width: 50.0,height: 50.0,)
                            : null,
                      ),
                      new Container(
                        child: image2 != null
                            ? new Image.file(image2,width: 50.0,height: 50.0,)
                            : null,
                      ),
                      new Container(
                        child: image3 != null
                            ? new Image.file(image3,width: 50.0,height: 50.0,)
                            : null,
                      ),
                      new Container(
                        child: image4 != null
                            ? new Image.file(image4,width: 50.0,height: 50.0,)
                            : null,
                      ),
                      new Container(
                        child: image5 != null
                            ? new Image.file(image5,width: 50.0,height: 50.0,)
                            : null,
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 10.0, top: 10.0 ),
                  decoration: new BoxDecoration(
                    color: Color.fromARGB( 255, 240, 240, 240 ),
                    border: new Border.all( width: 1.0, color: Colors.black12 ),
                  ),
                  child: taxtdetail,
                ),
                new SwitchListTile(value: _value1,
                  onChanged: (bool e){osecurity(e);},
                  activeColor: Colors.grey,
                  title: new Text("ต้องการพนักงานรักษาความปลอดภัย"),
                  secondary:const Icon(Icons.security,color: Colors.white,),
                ),
                new Divider(
                  color: Colors.orange,
                  indent: 50.0,
                ),
                new SwitchListTile(
                  value: _value2,
                  activeColor: Colors.grey,
                  onChanged: (bool e){oambulance(e);},
                  title: new Text("ต้องการรถพยาบาลฉุกเฉิน"),
                  secondary: const Icon(Icons.local_hospital,color: Colors.white,),
                ),
                new Divider(
                  color: Colors.orange,
                  indent: 50.0,
                ),
                new SwitchListTile(
                  value: _value3,
                  activeColor: Colors.grey,
                  onChanged: (bool e){fire(e);},
                  title: new Text("ต้องการพนักงานดับเพลิง"),
                  secondary: const Icon(Icons.notifications_active,color: Colors.white,),
                ),
                new Divider(
                  color: Colors.orange,
                  indent: 50.0,
                ),
                new RaisedButton(
                    child: new Text("แจ้งเหตุการณ์"),
                    color: Colors.orange,
                    textColor: Colors.white70,
                    padding:EdgeInsets.all(10.0),
                    onPressed: () async{
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>ShowSentScreen(
                          ambulance: _ambulance.text,
                          event: _event.text,
                          fireman: _fireman.text,
                          security: _security.text,
                          subname: _subnameSOS.text,
                          lastname: _lastnameSOS.text,
                          studentID: _studentIDSOS.text,
                          tel: _telSOS.text,
                          fileImage1: image,
                          fileImage2: image2,
                          fileImage3: image3,
                          fileImage4: image4,
                          fileImage5: image5,
                        ),
                      );
                      Navigator.of(context).pushReplacement(route);
                    }
                ),
              ],
            ),
          ),
          ],
        ),
        ),
    );
  }
  void setDataLogOut(){
    _uidSOS.clear();
    _emailSOS.clear();
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
    _bloodSOS.clear();
    _pathImage.clear();
    _pathImage2.clear();
    _pathImage3.clear();
    _pathImage4.clear();
    _pathImage5.clear();
    check = false;
  }
  Future<Null> uploadFile() async {
    String numberImage;
    String _path;
      numberImage = "${Random().nextInt(100000)}.jpg";
      final StorageReference fireStorageRef = FirebaseStorage.instance.ref().child(numberImage);
      final StorageUploadTask task = fireStorageRef.putFile(image);
    final Uri downloadUrl = (await task.future).downloadUrl;
      _path = downloadUrl.toString();
      _pathImage.text = _path;
  }
  Future<Null> uploadFile2() async {
    String numberImage;
    String _path;
    numberImage = "${Random().nextInt(100000)}.jpg";
    final StorageReference fireStorageRef = FirebaseStorage.instance.ref().child(numberImage);
    final StorageUploadTask task = fireStorageRef.putFile(image2);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    _pathImage2.text = _path;
  }
  Future<Null> uploadFile3() async {
    String numberImage;
    String _path;
    numberImage = "${Random().nextInt(100000)}.jpg";
    final StorageReference fireStorageRef = FirebaseStorage.instance.ref().child(numberImage);
    final StorageUploadTask task = fireStorageRef.putFile(image3);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    _pathImage3.text = _path;
  }
  Future<Null> uploadFile4() async {
    String numberImage;
    String _path;
    numberImage = "${Random().nextInt(100000)}.jpg";
    final StorageReference fireStorageRef = FirebaseStorage.instance.ref().child(numberImage);
    final StorageUploadTask task = fireStorageRef.putFile(image4);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    _pathImage4.text = _path;
  }
  Future<Null> uploadFile5() async {
    String numberImage;
    String _path;
    numberImage = "${Random().nextInt(100000)}.jpg";
    final StorageReference fireStorageRef = FirebaseStorage.instance.ref().child(numberImage);
    final StorageUploadTask task = fireStorageRef.putFile(image5);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    _pathImage5.text = _path;
  }
}
class PageTwo extends StatefulWidget {
  PageTwo({Key key}) : super(key: key);

  @override
  PageTwoState createState() => PageTwoState();
}
class CustomToolTip extends StatelessWidget {

  String text;

  CustomToolTip({this.text});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Tooltip(preferBelow: false,
          message: "Copy", child: new Text(text)),
      onTap: () {
        Clipboard.setData(new ClipboardData(text: text));
      },
    );
  }
}
class CustomToolTip2 extends StatelessWidget {

  String text;

  CustomToolTip2({this.text});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Tooltip(preferBelow: false,
          message: "Copy", child: new Text(text)),
      onTap: () {
        Clipboard.setData(new ClipboardData(text: text));
      },
    );
  }
}
class PageTwoState extends State<PageTwo> {
  TextEditingController _url = new TextEditingController();
  Future<void> _openURL()async{
      print('open click');
      _url.text = 'tel:0935286441';
      var url = _url.text;
      if(await canLaunch(url)){
        launch(url);
      }else{
        print('URL CAN NOT BE LANUNCHER');
      }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height ,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  Theme.Colors.loginGradientStart,
                  Theme.Colors.loginGradientEnd
                ], ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PageView(
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: build_number(context),
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
  Widget build_number(BuildContext context) {
    return
      new Container(
        child: new Column(
          children: <Widget>[
        Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album,color: Colors.red),
              title: Text('แผนกฉุกเฉิน โรงพยาบาลมหาวิทยาลัยเทคโนโลยีสุรนารี'),
              subtitle: Text('111 ถ.มหาวิทยาลัย ต.สุรนารี อ.เมือง จ.นครราชสีมา'),
            ),
            ButtonTheme.bar( // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                      child: new CustomToolTip(text: "0827500360"),
                    onPressed: () {
                    }
                  ),
                  FlatButton(
                      child: new CustomToolTip2(text: "044376555"),
                      onPressed: () {
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.album,color: Colors.red),
                title: Text('งานรักษาความปลอดภัย มทส.'),
              ),
              ButtonTheme.bar( // make buttons use the appropriate styles for cards
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: new CustomToolTip(text: "	044223346"),
                      onPressed: () { /* ... */ },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.album,color: Colors.red),
                title: Text('สภ.โพธิ์กลาง'),
                subtitle: Text('ซอยแสนสุข 6 ตำบล ปรุใหญ่ อำเภอ เมืองนครราชสีมา จังหวัด นครราชสีมา'),
              ),
              ButtonTheme.bar( // make buttons use the appropriate styles for cards
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: new CustomToolTip(text: "044211403"),
                      onPressed: () { /* ... */ },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.album,color: Colors.red),
                title: Text('สถานีดับเพลิงนครราชสีมา'),
                subtitle: Text('สถานีดับเพลิง ถนนสุรนารายณ์ จังหวัด นครราชสีมา'),
              ),
              ButtonTheme.bar( // make buttons use the appropriate styles for cards
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: new CustomToolTip(text: "044242222"),
                      onPressed: () { /* ... */ },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
          ],
        ),
      );
  }
}
class PageThree extends StatefulWidget {
  final VoidCallback onSignedOut;
  PageThree({
    Key key,
    this.onSignedOut
  });
  @override
  PageThreeState createState() => PageThreeState();
}
class PageThreeState extends State<PageThree>  {

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
  Widget build(BuildContext context) {
    return new Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height ,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  Theme.Colors.loginGradientStart,
                  Theme.Colors.loginGradientEnd
                ], ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PageView(
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: build_set(context),
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
  Widget build_set(BuildContext context) {
    void setDataLogOut(){
      _uidSOS.clear();
      _emailSOS.clear();
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
      _bloodSOS.clear();
      _pathImage.clear();
      _pathImage2.clear();
      _pathImage3.clear();
      _pathImage4.clear();
      _pathImage5.clear();
    }
    return new Container(

      color: Colors.black12,
      child: new Column(
        children: <Widget>[

          Container(
            padding:EdgeInsets.all(0.5),
            child: RaisedButton(
              color: Colors.white,
              onPressed: (){
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>Showprofile(
                    mail:_emailSOS.text,
                    name1:_subnameSOS.text,
                    name2: _lastnameSOS.text,
                    tel1: _telSOS.text,
                    Sid: _studentIDSOS.text,
                    uidsos: _uidSOS.text,
                    bloodSOS: _bloodSOS.text,
                  ),
                );
                Navigator.of(context).push(route);
              },
              child: Container(
                child: new ListTile(
                  leading: new Icon(Icons.account_circle,color: Colors.cyan,),
                  title: new Text("ข้อมูลส่วนตัว"),
                ),
              ),
            ),
          ),
          Container(
            padding:EdgeInsets.all(0.5),
            child: RaisedButton(
              color: Colors.white,
              onPressed: (){
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>Settel(
                      uid:_uidSOS.text
                  ),
                );
                Navigator.of(context).push(route);
              },
              child: Container(
                child: new ListTile(
                  leading: new Icon(Icons.call,color: Colors.cyan,),
                  title: new Text("เปลี่ยนเบอร์ติดต่อ"),
                ),
              ),
            ),
          ),
          Container(
            padding:EdgeInsets.all(0.5),
            child: RaisedButton(
              color: Colors.white,
              onPressed: (){
                setDataLogOut();
                _signOut(context);
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>LoginPage(
                  ),
                );
                Navigator.of(context).pushReplacement(route);
              },
              child: Container(
                child: new ListTile(
                  leading: new Icon(Icons.power_settings_new,color: Colors.red,),
                  title: new Text("ออกจากระบบ",style: TextStyle(color: Colors.red),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Data {
  final int id;
  bool expanded;
  final String title;
  Data(this.id, this.expanded, this.title);
}
bool read = false;

