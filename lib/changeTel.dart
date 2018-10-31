import 'dart:async';
import 'sos.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sut_sos/style/theme.dart' as Theme;
class Settel extends StatefulWidget {
  final String uid;
  Settel({Key key, this.uid}) : super (key: key);
  @override
  State<StatefulWidget> createState() {
    return _Settel();
  }

}
bool _ok=false;
final _mail = TextEditingController();
final _pass = TextEditingController();
//final _uid = TextEditingController();
final _oldtel = TextEditingController();
final _newtel = TextEditingController();
final _tel = TextEditingController();
final _confirmpass = TextEditingController();
class _Settel extends State<Settel> {
  Item item;
  DatabaseReference itemRef;

  void initState () {
    super.initState( );
    item = Item(
        _tel.text,
    );
    final FirebaseDatabase database = FirebaseDatabase.instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference( ).child( 'registerUser' );
  }
  void show(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children : <Widget>[
              Expanded(
                child: Text(
                  "ทำการเปลี่ยนเบอร์โทรศัพท์เรียบร้อยแล้ว",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('OK'),
                onPressed: () {
                 new Future.delayed(new Duration(seconds: 2), (){
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>SosPage(),
                  );
                  Navigator.of(context).pushReplacement(route);
                 });
                }),

          ],
        );
      },
    );
  }
  void handleSubmit () {
    RegExp checkTel = new RegExp('\\d{10}');
    Iterable<Match> matches = checkTel.allMatches(_newtel.text);
    setState(() {
      if(matches.length == 0){
        _ok = false;
      }else{
        _ok = true;
      }
    });
    if(_ok == true){
      itemRef.child( widget.uid ).update( item.toJson( ) );
      show();
    }

    //print(_email.text);
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
                Padding(
                  padding: EdgeInsets.only(top: 75.0),
                  child: new Container(
                    width: 250.0,
                    height: 150.0,
                  ),
                ),
                Expanded(
                  child: PageView(
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: build_changeTel(context),
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
  final newtal = TextFormField(
    keyboardType: TextInputType.phone,
    autofocus: false,
    controller: _newtel,
    decoration: new InputDecoration(
      hintText: 'tel ใหม่',
      contentPadding: new EdgeInsets.all( 10.0 ),
      border: InputBorder.none,
    ),
  );
  Widget build_changeTel(BuildContext context) {
    return
      new Container(
        child: new Column(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    //color: Colors.grey,
                    child: Center(
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Container(
                            margin: new EdgeInsets.only( left: 20.0, right: 20.0, top: 10.0 ),
                            decoration: new BoxDecoration(
                                color: Color.fromARGB( 255, 240, 240, 240 ),
                                border: new Border.all( width: 1.2, color: Colors.orange ),
                                borderRadius:
                                new BorderRadius.all( const Radius.circular( 25.0 ) ) ),
                            child: newtal,
                          ),
                          new Container(
                            margin: EdgeInsets.only( left: 20.0, right: 20.0, top: 10.0 ),
                            child: new Row(
                              children: <Widget>[
                                new Expanded(
                                    child: new RaisedButton(
                                        child: new Text( "เปลี่ยนเบอร์โทรศัพท์" ),
                                        textColor: Colors.white,
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          handleSubmit ();
                                        }
                                    ) ),
                                new Expanded(
                                  child: new Icon(_ok ? Icons.check : Icons.close),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      );
  }
}
class Item {

  String tel;


  Item(this.tel);

  Item.fromSnapshot(DataSnapshot snapshot)
      :
        tel = snapshot.value["tel"]
        ;

  toJson() {
    return {
      "tel":_newtel.text,
    };
  }
}

