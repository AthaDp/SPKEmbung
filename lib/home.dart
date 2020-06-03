import 'package:flutter/material.dart';
import 'services/authentication.dart';
import 'widgets/drawerAdmin.dart';

//halaman
import 'package:spkembung2/halaman/kriteria.dart';
import 'package:spkembung2/halaman/peringkat.dart';
import 'package:spkembung2/halaman/Alternatif.dart';
import 'package:spkembung2/halaman/hitung.dart';
import 'package:spkembung2/halaman/peta.dart';
import 'package:spkembung2/halaman/tentang.dart';
import 'package:spkembung2/root_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var firestore = Firestore.instance;

  @override
  void initState() {
    //preferensi();
    super.initState();
  }

  preferensi() async {
    List<double> content = [];
    List<double> contentPref = [];
    List<double> bobot = [];
    List<double> hasil = [];
    QuerySnapshot getKri = await firestore
        .collection("kriteria")
        .orderBy("kode_kriteria")
        .getDocuments();
    QuerySnapshot getAlt = await firestore
        .collection("alternatif")
        .orderBy("kode_alternatif")
        .getDocuments();
    QuerySnapshot getPref =
        await firestore
        .collection("preferensi")
        .orderBy("id")
        .getDocuments();
    int panjang = getAlt.documents.length; //panjang Kriteria
    int iterate = 5;
    for (int v = 0; v < 5; v++) {
      bobot.add((getKri.documents[v].data["bobot_kriteria"]).toDouble());
    }
    print("bobot : " + bobot.toString());
    for (int a = 0; a < panjang; a++) {
        for(int b = 0; b < iterate; b++){
          content.add(getPref.documents[b]["preferensi"][a]);
        }
        for (int c = 0; c < 5; c++) {
          hasil.add(content[c] * bobot[c]);
        }
      content.clear();
      contentPref.clear();

      await firestore
          .collection("preferensi")
          .document("preferensi" + a.toString())
          .setData({
            'hitung': hasil,
          }, merge: true)
          .then((documentReference) {})
          .catchError((e) {
            print(e);
          });
      await firestore
          .collection("alternatif")
          .document("Alternatif" + (a + 1).toString())
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

  Card dashKriteria(
    String title,
    AssetImage icon,
  ) {
    return Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(15.0)
            ),
        margin: new EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KriteriaPage()),
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
                  color: Color(0xFF21BFBD),
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

  Card dashAlternatif(
    String title,
    AssetImage icon,
  ) {
    return Card(
        //shape: RoundedRectangleBorder(
        //borderRadius: BorderRadius.circular(15.0)
        //),
        elevation: 0.0,
        margin: new EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: new InkWell(
            onTap: () async {
              await Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => AlternatifPage()));
              preferensi();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => AlternatifPage()),
              // );
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
                  color: Color(0xFF21BFBD),
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

  Card dashHitung(
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
                MaterialPageRoute(builder: (context) => HitungPage()),
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
                  color: Color(0xFF21BFBD),
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

  Card dashPeringkat(
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
                MaterialPageRoute(builder: (context) => PeringkatPage()),
              );
              //print("hello :)");
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
                  color: Color(0xFF21BFBD),
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

  Card dashPeta(
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
                MaterialPageRoute(builder: (context) => PetaPage()),
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
                  color: Color(0xFF21BFBD),
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

  Card dashTentang(
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
                MaterialPageRoute(builder: (context) => TentangPage()),
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
                  color: Color(0xFF21BFBD),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(elevation: 0.0, bottomOpacity: 0.0),
      drawer: AppDrawer(),
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
                Text('Datang',
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
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.only(left: 25.0, right: 20.0, top: 35),
              children: <Widget>[
                //dashKriteria("Kriteria", Icons.book),
                dashKriteria(
                    "Kriteria", AssetImage("assets/homeicons/Kriteria.png")),
                dashAlternatif("Alternatif",
                    AssetImage("assets/homeicons/Alternatif.png")),
                dashHitung("Hitung", AssetImage("assets/homeicons/Hitung.png")),
                dashPeringkat(
                    "Peringkat", AssetImage("assets/homeicons/Peringkat.png")),
                dashPeta("Peta", AssetImage("assets/homeicons/Peta.png")),
                dashTentang(
                    "Tentang", AssetImage("assets/homeicons/Tentang.png")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
