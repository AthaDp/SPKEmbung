import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:spkembung2/halaman/kriteria.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spkembung2/widgets/drawer.dart';
import 'package:spkembung2/services/locations.dart' as locations;

class TentangPage extends StatefulWidget {
  TentangPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _TentangPageState();
}

class _TentangPageState extends State<TentangPage> {
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
      drawer: AppDrawer(),
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
                Text('Aplikasi',
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
                  top: 15.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 25.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 120.0,
                          child: Image.asset('assets/HomeLogo.png'),
                        ),
                      ),
                      Column(children: <Widget>[

                        new Container(
                            padding: EdgeInsets.fromLTRB(18.0, 00.0, 18.0, 0.0),
                            child: Center(
                                child: Text(
                                    '   Aplikasi ini merupakan suatu aplikasi Decision Support System atau Sistem Pendukung Keputusan pada embung di kabupaten Semarang. Sistem Pendukung Keputusan digunakan membantu pengambilan keputusan dalam situasi dimana tak ada yang tahu bagaimana cara pemecahan atau pengambilan suatu keputusan.')
                            )
                        ),
                        SizedBox(height: 5.0),
                        new Container(
                            padding: EdgeInsets.fromLTRB(18.0, 00.0, 18.0, 0.0),
                            child: Center(
                                child: Text(
                                    '   Sistem pendukung keputusan sendiri memberi alternatif bagi masalah tidak terstruktur bagi kelompok maupun perseorangan dalam berbagai macam proses dan gaya pengambilan keputusan.')
                            )
                        ),
                        SizedBox(height: 5.0),
                        new Container(
                            padding: EdgeInsets.fromLTRB(18.0, 00.0, 18.0, 0.0),
                            child: Center(
                                child: Text(
                                    '   Pada aplikasi ini, digunakan metode Simple Additive Weighting dalam pemrosesan data. Konsep dasar dari metode Simple Additive Weighting ialah mencari jumlah bobot dari rating kinerja pada tiap alternatif pada semua atribut.')
                            )
                        ),
                        // Text(
                        //   '  	Aplikasi ini merupakan suatu aplikasi Decision Support System atau Sistem Pendukung Keputusan pada embung di kabupaten Semarang. Sistem Pendukung Keputusan digunakan membantu pengambilan keputusan dalam situasi dimana tak ada yang tahu bagaimana cara pemecahan atau pengambilan suatu keputusan.',
                        //   style: TextStyle(
                        //       fontSize: 17.0,
                        //       fontStyle: FontStyle.italic,
                        //       fontFamily: 'Montserrat'),
                        // ),
                        // SizedBox(height: 5.0),
                        // Text(
                        //   '  	Sistem pendukung keputusan sendiri memberi alternatif bagi masalah tidak terstruktur bagi kelompok maupun perseorangan dalam berbagai macam proses dan gaya pengambilan keputusan.',
                        //   style: TextStyle(
                        //       fontSize: 17.0,
                        //       fontStyle: FontStyle.italic,
                        //       fontFamily: 'Montserrat'),
                        // ),
                        // SizedBox(height: 5.0),
                        // Text(
                        //   '  	Pada aplikasi ini, digunakan metode Simple Additive Weighting dalam pemrosesan data. Konsep dasar dari metode Simple Additive Weighting ialah mencari jumlah bobot dari rating kinerja pada tiap alternatif pada semua atribut.',
                        //   style: TextStyle(
                        //       fontSize: 17.0,
                        //       fontStyle: FontStyle.italic,
                        //       fontFamily: 'Montserrat'),
                        // ),
                      ]),
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
