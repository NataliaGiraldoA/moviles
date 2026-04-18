import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/qr_scanner_page.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/utils/utils.dart';

import 'package:geolocator/geolocator.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: Icon(Icons.filter_center_focus),

      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QRScannerPage()),
        );

        if (result != null) {

          try {
            Position position = await getCurrentLocation();
            /*
            print(
              'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
            );
            */

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Scanned value: $result Latitude: ${position.latitude}, Longitude: ${position.longitude}')));


          } catch (e) {
            //print('Error getting location: $e');
            ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Scanned value: $result e: ${e.toString()}')));

          }

        }

        String barcodeScanRes = result;

        /*
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) =>  const QRViewExample()),
        );
        

        if (result != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Scanned value: $result')));
        }
        */

        //String barcodeScanRes =
        /*
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const QRViewExample()));
        */

        //print(barcodeScanRes);

        /*
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#3D8BEF',
          'Cancelar',
          false,
          ScanMode.QR,
        );
        */

        //final barcodeScanRes = 'https://fernando-herrera.com';
        //final barcodeScanRes = 'geo:45.287135,-75.920226';

        if (barcodeScanRes == '-1') {
          return;
        }

        final scanListProvider = Provider.of<ScanListProvider>(
          context,
          listen: false,
        );

        final nuevoScan = await scanListProvider.nuevoScan(barcodeScanRes);

        launchURL(context, nuevoScan);
      },
    );
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle accordingly
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle accordingly
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle accordingly
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
