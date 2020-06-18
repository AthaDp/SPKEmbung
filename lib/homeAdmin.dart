import 'package:flutter/material.dart';
import 'services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:spkembung2/halaman/kriteria.dart';
import 'package:spkembung2/halamanAdmin/alternatifAdmin.dart';
import 'package:spkembung2/halaman/peringkat.dart';
import 'package:spkembung2/halaman/hitung.dart';
import 'package:spkembung2/halaman/Alternatif.dart';
import 'package:spkembung2/halaman/peta.dart';
import 'package:spkembung2/halaman/tentang.dart';

class HomePageAdmin extends StatefulWidget {
  HomePageAdmin({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  var firestore = Firestore.instance;
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

   preferensi() async {
    List<double> content = [];
    List<double> contentPref = [];
    List<double> bobot = [];
    List<double> hasil = [];
    QuerySnapshot getKri = await firestore
        .collection("kriteria")
        .orderBy("id")
        .getDocuments();
    QuerySnapshot getAlt = await firestore
        .collection("alternatif")
        .orderBy("timestamp", descending: false)
        .getDocuments();
    QuerySnapshot getPref =
        await firestore
        .collection("preferensi")
        .orderBy("id")
        .getDocuments();
    int panjang = getAlt.documents.length; //panjang Kriteria
    int iterate = getKri.documents.length;
    for (int v = 0; v < iterate; v++) {
      bobot.add((getKri.documents[v].data["bobot_kriteria"]).toDouble());
    }
    print("bobot : " + bobot.toString());
    for (int a = 0; a < panjang; a++) {
        for(int b = 0; b < iterate; b++){
          content.add(getPref.documents[b]["preferensi"][a]);
        }
        print("content =" + content.toString());
        for (int c = 0; c < iterate; c++) {
          hasil.add(content[c] * bobot[c]);
        }
      content.clear();
      contentPref.clear();
      Timestamp timestamp;
      timestamp = getAlt.documents[a]["timestamp"];

      await firestore
          .collection("preferensi")
          .document(a < 10? "preferensi00" + a.toString() : "preferensi0" + a.toString())
          .setData({
            'hitung': hasil,
             'id' : a < 10? "00" + a.toString() : "0" + a.toString(),
             //'preferensi' : []
          }, merge: true)
          .then((documentReference) {})
          .catchError((e) {
            print(e);
          });
      await firestore
          .collection("alternatif")
          .document(getAlt.documents[a].documentID)
          .setData({
            'preferensi': hasil.fold(0, (i, j) => i + j).toStringAsFixed(2),
          }, merge: true)
          .then((documentReference) {})
          .catchError((e) {
            print(e);
          });
      hasil.clear();
    }
  }

  Material kriteria(String title, AssetImage icon, String route) {
    return Material(
      color: Colors.white,
      elevation: 12.0,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(72)),
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
                        color: Color(0xFF21BFBD),
                        size: 80,
                      ),
                  Text(title, style: TextStyle(color: Color(0xFF21BFBD), fontSize: 20.0, fontWeight: FontWeight.bold)),                  
                ] 
              )
            ],
          ),
          ),
      ),)
    );
  }

  Material _home(String title, AssetImage icon, String route) {
    return Material(
      color: Colors.white,
      elevation: 12.0,
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
                        color: Color(0xFF21BFBD),
                        size: 80,
                      ),
                  Text(title, style: TextStyle(color: Color(0xFF21BFBD), fontSize: 20.0, fontWeight: FontWeight.bold)),                  
                ] 
              )
            ],
          ),
          ),
      ),)
    );
  }

  Material alternatif(String title, AssetImage icon, String route) {
    return Material(
      color: Colors.white,
      elevation: 12.0,
      //borderRadius: BorderRadius.only(topLeft: Radius.circular(72)),
      child: GestureDetector(
        onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AlternatifAdminPage()));
              await preferensi();
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
                        color: Color(0xFF21BFBD),
                        size: 80,
                      ),
                  Text(title, style: TextStyle(color: Color(0xFF21BFBD), fontSize: 20.0, fontWeight: FontWeight.bold)),                  
                ] 
              )
            ],
          ),
          ),
      ),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(elevation: 0.0, bottomOpacity: 0.0),
      drawer: 
      new Drawer(
        child: 
        new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage('assets/headerimage.png'),
                      fit: BoxFit.fill)),
            ),
            new ListTile(
                title: new Text("Kriteria"),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => KriteriaAdmin()),
                  // );
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("First Page")));
                }),
            new ListTile(
                title: new Text("Alternatif"),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }),
            new ListTile(
                title: new Text("Hitung"),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }),
            new ListTile(
                title: new Text("Peringkat"),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }),
            new ListTile(
                title: new Text("Peta"),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PetaPage()),
                  );
                }),
            new Divider(),
            new ListTile(
              title: new Text("Tentang"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () => signOut(),
            ),
            new ListTile(
              title: new Text("Logout"),
              //trailing: new Icon(Icons.cancel),
              onTap: () => signOut(),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 2.0, left: 10.0),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Selamat',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0)),
                SizedBox(width: 10.0),
                Text('Datang, Admin',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 30.0))
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: MediaQuery.of(context).size.height - 100.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
              // padding: EdgeInsets.only(left: 25.0, right: 20.0, top: 35),
              children: <Widget>[
                //dashKriteria("Kriteria", Icons.book),
                kriteria("Kriteria", AssetImage("assets/homeicons/Kriteria.png"), "kriteriaAdmin"),
                  alternatif("Alternatif", AssetImage("assets/homeicons/Alternatif.png"), "alternatifAdmin"),
                  _home("Hitung", AssetImage("assets/homeicons/Hitung.png"), "hitung"),
                  _home("Peringkat", AssetImage("assets/homeicons/Peringkat.png"), "peringkat"),  
                  _home("Peta", AssetImage("assets/homeicons/Peta.png"), "peta"),
                  _home("Tentang", AssetImage("assets/homeicons/Tentang.png"), "tentang"),    
              ],
              staggeredTiles: [
                  StaggeredTile.extent(1, 175.0),
                  StaggeredTile.extent(1, 175.0),
                  StaggeredTile.extent(1, 175.0),
                  StaggeredTile.extent(1, 175.0),
                  StaggeredTile.extent(1, 175.0),
                  StaggeredTile.extent(1, 175.0),
                  StaggeredTile.extent(2, 175.0)
                ],
            ),
          )
        ],
      ),
    );
  }
}
