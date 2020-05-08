import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:spkembung2/halaman/kriteria.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spkembung2/services/locations.dart' as locations;

class PetaPage extends StatefulWidget {
  PetaPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _PetaPageState();
}

class _PetaPageState extends State<PetaPage> {
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

  /*GoogleMapController mapController;

  final LatLng _center = const LatLng(-7.333914, 110.503951);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }*/

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
        appBar: new AppBar(
            title: Text('Peta Embung'), elevation: 0.0, bottomOpacity: 0.0),
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
                  title: new Text("PetaPage"),
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
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: const LatLng(-7.330621, 110.508048),
            zoom: 11,
          ),
          markers: _markers.values.toSet(),
        ));
  }
}
