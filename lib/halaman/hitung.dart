import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:spkembung2/widgets/drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:spkembung2/halaman/normalisasi.dart';
import 'package:spkembung2/halaman/preferensi.dart';

class HitungPage extends StatefulWidget {
  HitungPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HitungPageState();
}

class _HitungPageState extends State<HitungPage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var list;
  var random;

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Card dashNormalisasi(
    String title,
    AssetImage icon,
  ) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 0.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NormalisasiPage()),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 20.0),
                Center(
                    child: ImageIcon(
                  icon,
                  size: 120.0,
                  color: Color(0xFF38C0D0),
                )),
                //SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  Material _hitung(String title, AssetImage icon, String route, double radius) {
    return Material(
      color: Colors.white,
      elevation: 12.0,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(radius)),
      //borderRadius: BorderRadius.only(topLeft: Radius.circular(72)),
      child: GestureDetector(
        onTap: () async {
          Navigator.pushNamed(context, route);
        },
      child :Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ImageIcon(
                        icon,
                        color: Color(0xFF38C0D0),
                        size: 80,
                      ),
                  Text(title, style: TextStyle(color: Color(0xFF38C0D0), fontSize: 20.0, fontWeight: FontWeight.bold)),                  
                ] 
              )
            ],
          ),
          ),
      ),)
    );
  }

  Card dashPreferensi(
    String title,
    AssetImage icon,
  ) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 0.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreferensiPage()),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 20.0),
                Center(
                    child: ImageIcon(
                  icon,
                  size: 120.0,
                  color: Color(0xFF38C0D0),
                )),
                //SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      list = List.generate(random.nextInt(10), (i) => "Item $i");
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: new AppBar(elevation: 0.0, bottomOpacity: 0.0, iconTheme: new IconThemeData(color: Colors.white),),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF38C0D0),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 2.0, left: 10.0)),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Hitung',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0)),
                SizedBox(width: 10.0),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          // Expanded(child: null),
          Container(
            height: MediaQuery.of(context).size.height - 100.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: StaggeredGridView.count(
              crossAxisCount: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 25,
              padding: EdgeInsets.only(left: 25.0, right: 20.0, top: 35),
              children: <Widget>[
                //dashKriteria("Kriteria", Icons.book),
                _hitung("Normalisasi", AssetImage("assets/homeicons/Kriteria.png"), "normalisasi", 72.0),
                _hitung("Preferensi", AssetImage("assets/homeicons/Alternatif.png"), "preferensi", 0),
              ],
              staggeredTiles: [
                  StaggeredTile.extent(2, 175.0),
                  StaggeredTile.extent(2, 175.0),
                ],
            ),
          )
        ],
      ),
    );
  }
}
