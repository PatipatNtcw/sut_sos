
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
class Test extends StatefulWidget {
  final VoidCallback onSignedOut;
  @override
  Test({Key key,this.onSignedOut});
  _Test createState() => new _Test();
}

class _Test extends State<Test> {
  TextEditingController _url = new TextEditingController();
  Future<void> _openURL()async{
    try{
      print('open click');
      _url.text = 'tel:0935286441';
      _url.text = 'https://www.google.com';
      var url = _url.text;
      if(await canLaunch(url)){
        launch(url);
        return launch(url);
      }else{
        print('URL CAN NOT BE LANUNCHER');
      }
    }catch (e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromARGB( 255, 165, 0, 0 ),
          title: new Text( "SUT Rescue SOS Emergency" ),
        ),
        body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(onPressed:  _openURL,child: new Text("Open Url"),),
              ],
            ),
          ),
        )
    );
  }
}


