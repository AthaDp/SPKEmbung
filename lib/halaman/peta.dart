import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:spkembung2/halaman/kriteria.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spkembung2/widgets/drawer.dart';
import 'package:spkembung2/services/locations.dart' as locations;
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

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
  GoogleMapController _mapController;
  TextEditingController _latitudeController, _longitudeController;
  BitmapDescriptor pinLocationIcon;

  // firestore init
  Firestore _firestore = Firestore.instance;
  Geoflutterfire geo;
  Stream<List<DocumentSnapshot>> stream;
  var radius = BehaviorSubject<double>.seeded(1.0);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    //getAlternatif();
    geo = Geoflutterfire();
    var collectionReference = _firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: -7.222164, longitude: 110.492635);
    stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: 100, field: 'position');
    print("Stream");
    print("Stream" + stream.toString());
  }

  @override
  void dispose() {
    super.dispose();
    radius.close();
  }

    Future getAlternatif(String alternatif) async {
    QuerySnapshot getAlt = await _firestore
        .collection("alternatif")
        .where('nama_alternatif', isEqualTo: alternatif)
        .orderBy("timestamp", descending: false)
        .getDocuments();

    //print("getAlt " + (getAlt.documents[0]["preferensi"]).toString());
    String preferensi = getAlt.documents[0]["preferensi"].toString();
    print("preferensi: " +preferensi);
    return preferensi;
    //return getAlt.documents;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Peta Embung'),
          backgroundColor: Color(0xFF38C0D0),
          actions: <Widget>[
            IconButton(
              onPressed: _mapController == null
                  ? null
                  : () {
                      _showHome();
                    },
              icon: Icon(Icons.home),
            )
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     //_addGeoPoint();
        //     _addMarker2();
        //     _addPoint();
        //   },
        //   child: Icon(Icons.navigate_next),
        // ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(-7.222164, 110.492635),
            zoom: 11.0,
          ),
          markers: Set<Marker>.of(markers.values),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
        print("Document List: " + documentList.toString());
      });
    });
  }

  void _showHome() {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      const CameraPosition(
        target: LatLng(-7.222164, 110.492635),
        zoom: 11.0,
      ),
    ));
  }

  void _addPoint() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    GeoFirePoint geoFirePoint =
        geo.point(latitude: location.latitude, longitude: location.longitude);
    _firestore
        .collection('locations')
        .add({'name': 'random name', 'position': geoFirePoint.data}).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  void _addMarker(double lat, double lng, String name, String rank) {
    MarkerId id = MarkerId(lat.toString() + lng.toString());
    Marker _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: pinLocationIcon,
      infoWindow: InfoWindow(title: name, snippet: "Preferensi : " + rank),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/iconEmbung.png');
  }

  void _addMarker2() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    MarkerId id =
        MarkerId(location.latitude.toString() + location.longitude.toString());
    Marker _marker = Marker(
      markerId: id,
      position: LatLng(location.latitude, location.longitude),
      icon: pinLocationIcon,
      infoWindow: InfoWindow(
          title: 'tolong2', snippet: '$location.latitude,$location.longitude'),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) async {
      GeoPoint point = document.data['position']['geopoint'];
      String name = document.data['name'];
      getAlternatif(name);

      QuerySnapshot getAlt = await _firestore
        .collection("alternatif")
        .where('nama_alternatif', isEqualTo: name)
        .orderBy("timestamp", descending: false)
        .getDocuments();

    //print("getAlt " + (getAlt.documents[0]["preferensi"]).toString());
      String preferensi = getAlt.documents[0]["preferensi"].toString();
     
      _addMarker(point.latitude, point.longitude, name, preferensi);
    });
  }

  double _value = 20.0;
  String _label = '';

  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      markers.clear();
    });
    radius.add(value);
  }

  Future<DocumentReference> _addGeoPoint() async {
    //var pos = await location.getLocation();
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("adding Geopoint to lat:" +
        location.latitude.toString() +
        " lat: " +
        location.longitude.toString());
    GeoFirePoint point =
        geo.point(latitude: location.latitude, longitude: location.longitude);
    return _firestore
        .collection('locations')
        .add({'position': point.data, 'name': 'Yay I can be queried!'});
  }
}
