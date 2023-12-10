import 'package:flutter/material.dart';
import 'package:qr_reader_app/bloc/scans_bloc.dart';
import 'package:qr_reader_app/models/scan_model.dart';
import 'package:qr_reader_app/utils/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    return StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scansStreamHttp,
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final scans = snapshot.data;

          if (scans.length == 0) {
            return Center(
              child: Text('No hay información'),
            );
          }

          return ListView.builder(
              itemCount: scans.length,
              itemBuilder: (BuildContext context, int i) => Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (DismissDirection direction) =>
                      scansBloc.deleteScan(scans[i].id),
                  child: ListTile(
                    leading: Icon(Icons.cloud_queue,
                        color: Theme.of(context).primaryColor),
                    title: Text(scans[i].valor),
                    subtitle: Text('ID: ${scans[i].id}'),
                    trailing:
                        Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                    onTap: () {
                      utils.openScan(context, scans[i]);
                    },
                  )));
        });
  }
}

// return TileLayerOptions(
//         urlTemplate: 'https://api.tiles.mapbox.com/v4/'
//             '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
//         additionalOptions: {
//         'accessToken':'pk.eyJ1Ijoiam9yZ2VncmVnb3J5IiwiYSI6ImNrODk5aXE5cjA0c2wzZ3BjcTA0NGs3YjcifQ.H9LcQyP_-G9sxhaT5YbVow',
//         'id': 'mapbox.streets'
//         }
// );
