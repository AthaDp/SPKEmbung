import 'package:flutter/material.dart';
import 'services/authentication.dart';
import 'package:spkembung2/halamanadmin/kriteria.dart';
import 'package:spkembung2/halamanadmin/peta.dart';
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
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
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
                MaterialPageRoute(builder: (context) => KriteriaAdmin()),
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
            onTap: () {},
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
            onTap: () {},
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
            onTap: () {},
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
      drawer: new Drawer(
        child: new ListView(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KriteriaAdmin()),
                  );
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
