import 'package:flutter/material.dart';
import 'package:qr_reader_app/models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  MapController mapCtrl = new MapController();
  String tipoMapa = 'streets-v11';
  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: [
          IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                mapCtrl.move(scan.getLatLng(), 15);
              })
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context, scan, mapCtrl),
    );
  }

  Widget _crearBotonFlotante(
      BuildContext context, ScanModel scan, MapController map) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        switch (tipoMapa) {
          case 'streets-v11':
            tipoMapa = 'dark-v10';
            break;
          case 'dark-v10':
            tipoMapa = 'light-v10';
            break;
          case 'light-v10':
            tipoMapa = 'satellite-v9';
            break;
          case 'satellite-v9':
            tipoMapa = 'outdoors-v11';
            break;
          case 'outdoors-v11':
            tipoMapa = 'satellite-streets-v11';
            break;
          default:
            tipoMapa = 'streets-v11';
        }

        print(tipoMapa);

        setState(() {});

        map.move(scan.getLatLng(), 30);
        Future.delayed(Duration(milliseconds: 50), () {
          map.move(scan.getLatLng(), 15);
        });
      },
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      options: MapOptions(center: scan.getLatLng(), zoom: 15),
      layers: [_crearMapa(), _crearMarcadores(scan)],
      mapController: mapCtrl,
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiY2FybG9zbTA5MDUiLCJhIjoiY2tmc2k3ZTl5MGdiMDJ5bXRqNWpwaGhpZCJ9.kJC6kDyEWD1z4wKwYLyP6w',
          'id': 'mapbox/$tipoMapa'
        });
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(markers: [
      Marker(
        width: 100,
        height: 120,
        point: scan.getLatLng(),
        builder: (context) => Container(
          child: Icon(
            Icons.location_on,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
      )
    ]);
  }
}
