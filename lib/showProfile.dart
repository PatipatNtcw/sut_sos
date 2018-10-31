import 'package:flutter/material.dart';
import 'package:sut_sos/style/theme.dart' as Theme;
class Showprofile extends StatefulWidget {
  final String mail;
  final String name1;
  final String name2;
  final String tel1;
  final String Sid;
  final String uidsos;
  final String bloodSOS;
  Showprofile({Key key, this.mail,this.name1,this.name2,this.tel1,this.Sid,this.uidsos,this.bloodSOS}) : super (key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyShowprofile();
  }
}

class _MyShowprofile extends State<Showprofile> {
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
                  /*child: new Container(
                    width: 250.0,
                    height: 150.0,
                  ),*/
                ),
                Expanded(
                  child: PageView(
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: build_showProfile(context),
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
  Widget build_showProfile(BuildContext context) {

    return
       new Container(

          child:
          new Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: new Icon(Icons.account_circle,color: Colors.cyan,),
                    title: new Text("ชื่อ  : "+widget.name1+" "+widget.name2),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: new Icon(Icons.mail,color: Colors.cyan,),
                    title: new Text("email : "+widget.mail),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: new Icon(Icons.call,color: Colors.cyan,),
                    title: new Text("เบอร์ติดต่อ : "+widget.tel1),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: new Icon(Icons.folder_shared,color: Colors.cyan,),
                    title: new Text("รหัสนักศึกษา : "+widget.Sid),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: new Icon(Icons.invert_colors,color: Colors.red,),
                    title: new Text("หมู่เลือด : "+widget.bloodSOS),
                  ),
                ),
              ]
        ),
    );
  }

}
