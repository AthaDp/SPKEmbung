import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:spkembung2/halaman/kriteria.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spkembung2/services/locations.dart' as locations;

class TentangPage extends StatefulWidget {
  TentangPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _PetaPageState();
}

class _PetaPageState extends State<TentangPage> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
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
                    MaterialPageRoute(builder: (context) => KriteriaPage()),
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
                title: new Text("TentangPage"),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
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
            padding: EdgeInsets.only(
              left: 40.0,
            ),
            child: Row(
              children: <Widget>[
                Text('Tentang',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0)),
                SizedBox(width: 10.0),
                Text('Saya',
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
            child: new Stack(
              children: <Widget>[
                Positioned(
                  width: 410.0,
                  //top: MediaQuery.of(context).size.height / 5,
                  top: 75.0,
                  child: Column(
                    children: [
                      // Container(
                      //     width: 200.0,
                      //     height: 200.0,
                      //     decoration: BoxDecoration(
                      //         color: Colors.red,
                      //         image: DecorationImage(
                      //             image: new AssetImage('assets/Rena.png'),

                      //             /*
                      //       NetworkImage(
                      //           'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),*/
                      //             fit: BoxFit.cover),
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(75.0)),
                      //         boxShadow: [
                      //           BoxShadow(blurRadius: 7.0, color: Colors.grey)
                      //         ])),
                      // SizedBox(height: 50.0),
                      // Text(
                      //   'Rena Visi Nuraini',
                      //   style: TextStyle(
                      //       fontSize: 30.0,
                      //       fontWeight: FontWeight.bold,
                      //       fontFamily: 'Montserrat'),
                      // ),
                      SizedBox(height: 20.0),
                      Column(
                        
                        children: <Widget>[
                           Text(
                        'ABOUT',
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                      SizedBox(height: 50.0),
                      Text(
                        '  	Aplikasi ini merupakan suatu aplikasi Decision Support System atau Sistem Pendukung Keputusan pada embung di kabupaten Semarang. Sistem Pendukung Keputusan digunakan membantu pengambilan keputusan dalam situasi dimana tak ada yang tahu bagaimana cara pemecahan atau pengambilan suatu keputusan.',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Montserrat'),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '  	Sistem pendukung keputusan sendiri memberi alternatif bagi masalah tidak terstruktur bagi kelompok maupun perseorangan dalam berbagai macam proses dan gaya pengambilan keputusan.',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Montserrat'),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '  	Pada aplikasi ini, digunakan metode Simple Additive Weighting dalam pemrosesan data. Konsep dasar dari metode Simple Additive Weighting ialah mencari jumlah bobot dari rating kinerja pada tiap alternatif pada semua atribut.',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Montserrat'),
                      ),
                        ]
                      ),
                     
                    ],
                  ),
                )
              ],
            ),

            /*child: 
            GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.only(left: 25.0, right: 20.0, top: 35),
              children: <Widget>[
                
              ],
            ),*/
          )
        ],
      ),
    );
  }
}
