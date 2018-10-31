import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'package:sut_sos/style/theme.dart' as Theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main.dart';
class RegisterUser extends StatefulWidget {
  @override
  _RegisterUser createState() => _RegisterUser();
}

final _email = TextEditingController();
final _password = TextEditingController();
final _uid = TextEditingController();
final _tel = TextEditingController();
final _subname = TextEditingController();
final _lastname = TextEditingController();
final _studentId = TextEditingController();
final _blood = TextEditingController();
final _gender = TextEditingController();

bool regExPhonenum=false;
bool regExEmail=false;
bool regExStudentId=false;
bool regExPass=false;
class _RegisterUser extends State<RegisterUser> {
  List<Item> items = List( );
  List<DropdownMenuItem<int>> listDrop = [];
  List<DropdownMenuItem<int>> listDroG = [];
  Item item;
  DatabaseReference itemRef;
  String profession, gen;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>( );
  final FirebaseDatabase database = FirebaseDatabase.instance;
  List<DropdownMenuItem<String>> itemD = [
    new DropdownMenuItem(
      child: new Text( 'A' ),
      value: 'A',
    ),
    new DropdownMenuItem(
      child: new Text( 'B' ),
      value: 'B',
    ),
    new DropdownMenuItem(
      child: new Text( 'AB' ),
      value: 'AB',
    ),
    new DropdownMenuItem(
      child: new Text( 'O' ),
      value: 'O',
    ),
  ];

  List<DropdownMenuItem<String>> itemG = [
    new DropdownMenuItem(
      child: new Text( 'ชาย' ),
      value: 'ชาย',
    ),
    new DropdownMenuItem(
      child: new Text( 'หญิง' ),
      value: 'หญิง',
    ),
  ];


  Future<void> Singin (String a, String b) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword( email: a, password: b ).then( (data) => _uid.text = data.uid );
    print( "Uid : " + _uid.text );
  }

  void initState () {
    super.initState( );
    item = Item(
        _uid.text,
        _email.text,
        _password.text,
        _tel.text,
        _subname.text,
        _lastname.text,
        _studentId.text,
        _gender.text,
        _blood.text );
    final FirebaseDatabase database = FirebaseDatabase.instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference( ).child( 'registerUser' );
  }

  void handleSubmit () {
    itemRef.child( _uid.text ).set( item.toJson( ) );
    new Future.delayed(new Duration(seconds: 3), (){
      var rount = new MaterialPageRoute(
          builder: (
              BuildContext contex) => MyApp(
          )
      );
      Navigator.of( context ).pushReplacement( rount );
    });
  }
  void check_regExPhonenum(){
    RegExp checkPhonenum = new RegExp('\\d{10}');
    Iterable<Match> matches = checkPhonenum.allMatches(_tel.text);
    setState(() {
      if(matches.length == 0){
        regExPhonenum = false;
      }else{
        regExPhonenum = true;
      }
    });
  }
  void check_regExStudentId(){
    RegExp checkStudentId = new RegExp('^[B,M,D]\\d{7}');
    Iterable<Match> matches = checkStudentId.allMatches(_studentId.text);
    setState(() {
      if(matches.length == 0){
        regExStudentId = false;
      }else{
        regExStudentId = true;
      }
    });
  }
  void check_regExEmail(){
    RegExp checkEmail = new RegExp('[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}');
    Iterable<Match> matches = checkEmail.allMatches(_email.text);
    setState(() {
      if(matches.length == 0){
        regExEmail = false;
      }else{
        regExEmail = true;
      }
    });
  }
  void check_regExPass(){
    RegExp checkPass = new RegExp('[A-Z,a-z,0-9]{6,}');
    Iterable<Match> matches = checkPass.allMatches(_password.text);
    setState(() {
      if(matches.length == 0){
        regExPass = false;
      }else{
        regExPass = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromARGB( 255, 165, 0, 0 ),
        title: new Text( "SUT Rescue SOS Emergency" ),
      ),
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
                      child: build_regis(context),
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
  Widget build_regis (BuildContext context) {
    final emailregister = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      initialValue: null,
      onSaved: (val) => item.email = val,
      validator: (val) => val.isEmpty ? 'กรุณากรอกข้อมูลให้ครบ' : null,
      controller: _email,
      decoration: new InputDecoration(
        hintText: 'email',
        contentPadding: new EdgeInsets.all( 10.0 ),
        border: InputBorder.none,
        suffixIcon: GestureDetector(
          child:
          new Icon(regExEmail ? Icons.check_circle : Icons.cancel , size: 15.0,color: (regExEmail ? Colors.green:Colors.red),)
        ),
      ),

    );
    final passregister = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      initialValue: null,
      obscureText: true,
      onSaved: (val) => item.password = val,
      validator: (val) => val.isEmpty ? 'กรุณากรอกข้อมูลให้ครบ' : null,
      controller: _password,
      decoration: new InputDecoration(
        hintText: 'password ',
        suffixText: 'อย่างน้อย 6 ตัว',
        contentPadding: new EdgeInsets.all( 10.0 ),
        border: InputBorder.none,
        suffixIcon: GestureDetector(
            child:
            new Icon(regExPass ? Icons.check_circle : Icons.cancel , size: 15.0,color: (regExPass ? Colors.green:Colors.red),)
        ),
      ),
    );
    final telregister = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      initialValue: null,
      onSaved: (val) => item.tel = val,
      validator: (val) => val.isEmpty ? 'กรุณากรอกข้อมูลให้ครบ' : null,
      controller: _tel,
      decoration: new InputDecoration(
        hintText: 'เบอร์ที่สามารถติดต่อได้',
        contentPadding: new EdgeInsets.all( 10.0 ),
        border: InputBorder.none,
        suffixIcon: GestureDetector(
            child:
            new Icon(regExPhonenum ? Icons.check_circle : Icons.cancel , size: 15.0,color: (regExPhonenum ? Colors.green:Colors.red),)
        ),
      ),
    );
    final subname = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      initialValue: null,
      onSaved: (val) => item.subname = val,
      validator: (val) => val.isEmpty ? 'กรุณากรอกข้อมูลให้ครบ' : null,
      controller: _subname,
      decoration: new InputDecoration(
        hintText: 'ชื่อ',
        contentPadding: new EdgeInsets.all( 10.0 ),
        border: InputBorder.none,
      ),

    );
    final lastname = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      initialValue: null,
      onSaved: (val) => item.lastname = val,
      validator: (val) => val.isEmpty ? 'กรุณากรอกข้อมูลให้ครบ' : null,
      controller: _lastname,
      decoration: new InputDecoration(
        hintText: 'นามสกุล',
        contentPadding: new EdgeInsets.all( 10.0 ),
        border: InputBorder.none,
      ),

    );
    final studentId = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      initialValue: null,
      onSaved: (val) => item.studentId = val,
      validator: (val) => val.isEmpty ? 'กรุณากรอกข้อมูลให้ครบ' : null,
      controller: _studentId,
      decoration: new InputDecoration(
        hintText: 'รหัสนักศึกษา',
        suffixText: 'ขึ้นต้นด้วย  B,M,D',
        contentPadding: new EdgeInsets.all( 10.0 ),
        border: InputBorder.none,
        suffixIcon: GestureDetector(
            child:
            new Icon(regExStudentId ? Icons.check_circle : Icons.cancel , size: 15.0,color: (regExStudentId ? Colors.green:Colors.red),)
        ),
      ),
    );

    return
      new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                new Container(
                  margin: new EdgeInsets.only( left: 20.0, right: 20.0, top: 10.0 ),
                  decoration: new BoxDecoration(
                      color: Color.fromARGB( 255, 240, 240, 240 ),
                      border: new Border.all( width: 1.2, color: Colors.black12 ),
                      borderRadius:
                      new BorderRadius.all( const Radius.circular( 25.0 ) ) ),
                  child: emailregister,
                ),

                new Container(
                  margin: new EdgeInsets.only( left: 20.0, right: 20.0, top: 10.0 ),
                  decoration: new BoxDecoration(
                      color: Color.fromARGB( 255, 240, 240, 240 ),
                      border: new Border.all( width: 1.2, color: Colors.black12 ),
                      borderRadius:
                      new BorderRadius.all( const Radius.circular( 25.0 ) ) ),
                  child: passregister,
                ),
                new Container(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new SizedBox( width: 10.0 ),
                          new DropdownButtonHideUnderline(
                            child: new DropdownButton(

                              items: itemD,
                              hint: new Text( 'หมู่เลือด' ,style: new TextStyle(color: Colors.black),),
                              value: profession,
                              onChanged: (String val) {
                                setState( () {
                                  profession = val;
                                  _blood.text = val;
                                  print( "blood : " + _blood.text );
                                } );
                              },
                            ), ),
                        ],
                      ),
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new SizedBox( width: 10.0 ),
                          new DropdownButtonHideUnderline(
                            child: new DropdownButton(
                              items: itemG,
                              hint: new Text( 'เพศ' ,style: new TextStyle(color: Colors.black)),
                              value: gen,
                              onChanged: (String da) {
                                setState( () {
                                  gen = da;
                                  _gender.text = da;
                                  print( "gender : " + _gender.text );
                                } );
                              },
                            ), ),
                        ],
                      ),
                    ],
                  ),

                ),
                new Container(
                  margin: new EdgeInsets.only( left: 20.0, right: 20.0, top: 10.0 ),
                  decoration: new BoxDecoration(
                      color: Color.fromARGB( 255, 240, 240, 240 ),
                      border: new Border.all( width: 1.2, color: Colors.black12 ),
                      borderRadius:
                      new BorderRadius.all( const Radius.circular( 25.0 ) ) ),
                  child: subname,
                ),
                new Container(
                  margin: new EdgeInsets.only( left: 20.0, right: 20.0, top: 10.0 ),
                  decoration: new BoxDecoration(
                      color: Color.fromARGB( 255, 240, 240, 240 ),
                      border: new Border.all( width: 1.2, color: Colors.black12 ),
                      borderRadius:
                      new BorderRadius.all( const Radius.circular( 25.0 ) ) ),
                  child: lastname,
                ),
                Container(
                  margin: new EdgeInsets.only( left: 20.0, right: 20.0, top: 10.0 ),
                  decoration: new BoxDecoration(
                      color: Color.fromARGB( 255, 240, 240, 240 ),
                      border: new Border.all( width: 1.2, color: Colors.black12 ),
                      borderRadius:
                      new BorderRadius.all( const Radius.circular( 25.0 ) ) ),
                  child: telregister,
                ),
                new Container(
                  margin: new EdgeInsets.only( left: 20.0, right: 20.0, top: 10.0 ),
                  decoration: new BoxDecoration(
                      color: Color.fromARGB( 255, 240, 240, 240 ),
                      border: new Border.all( width: 1.2, color: Colors.black12 ),
                      borderRadius:
                      new BorderRadius.all( const Radius.circular( 25.0 ) ) ),
                  child: studentId,
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
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "สมัครสมาชิก",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () async{
                      check_regExPhonenum();
                      check_regExEmail();
                      check_regExStudentId();
                      check_regExPass();
                      if(regExPhonenum == true && regExEmail == true && regExStudentId == true && regExPass == true){
                        await Singin( _email.text, _password.text );
                        handleSubmit( );
                        print("Phone Yes");
                      }else{
                        print("Phone not RegEx");
                      }
                    },
                  ),
                ),

              ],

    );
  }
}

class Item {
  String key;
  String password;
  String email;
  String tel;
  String subname;
  String lastname;
  String studentId;
  String gen;
  String blood;

  Item(this.key,this.password, this.email,this.tel,this.subname,this.lastname,this.studentId,this.gen,this.blood);

  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        password = snapshot.value["password"],
        email = snapshot.value["email"],
        tel = snapshot.value["tel"],
        subname = snapshot.value["subname"],
        lastname = snapshot.value["lastname"],
        studentId = snapshot.value["studentId"],
        gen = snapshot.value["gen"],
        blood = snapshot.value["blood"];

  toJson() {
    return {
      "password": _password.text,
      "email": _email.text,
      "tel":_tel.text,
      "subname":_subname.text,
      "lastname":_lastname.text,
      "studentId":_studentId.text,
      "gender":_gender.text,
      "blood":_blood.text,
    };
  }
}




