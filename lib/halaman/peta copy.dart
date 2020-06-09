import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:spkembung2/halaman/kriteria.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spkembung2/widgets/drawer.dart';
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
  BitmapDescriptor pinLocationIcon;
  final Map<String, Marker> _markers = {};

  


  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          icon: pinLocationIcon,
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  void initState() {
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
      pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/iconEmbung.png');
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
        drawer: AppDrawer(),
        
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
