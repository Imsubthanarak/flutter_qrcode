import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'itemstatus.dart';

const _url = 'http://34.87.73.178/';

class Qrhome extends StatelessWidget {
  const Qrhome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: size.width,
              height: size.height,
              color: const Color(0xFFB6E3BC),
            ),
          ),
          Positioned(
            top: 200.0,
            width: size.width,
            child: Container(
              height: size.height - 200.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
            ),
          ),
          Positioned(
            width: (size.width - 70.0) / 2,
            height: (size.height - 300.0) / 2,
            top: 230.0,
            left: 25.0,
            child: Container(
              height: 350.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QRViewExample(),
                    ),
                  );
                },
                child: const Text('qrView'),
              ),
            ),
          ),
          Positioned(
            width: (size.width - 70.0) / 2,
            height: (size.height - 300.0) / 2,
            top: 230.0,
            right: 25.0,
            child: Container(
              height: 350.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QRViewExample(),
                    ),
                  );
                },
                child: const Text('qrView'),
              ),
            ),
          ),
          Positioned(
            width: (size.width - 70.0) / 2,
            height: (size.height - 300.0) / 2,
            top: 470.0,
            left: 25.0,
            child: Container(
              height: 350.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QRViewExample(),
                    ),
                  );
                },
                child: const Text('qrView'),
              ),
            ),
          ),
          Positioned(
            width: (size.width - 70.0) / 2,
            height: (size.height - 300.0) / 2,
            top: 470.0,
            right: 25.0,
            child: Container(
              height: 350.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                ),
                onPressed: _launchURL,
                child: const Text('Website'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrhomeState();
}

class _QrhomeState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 450 ||
            MediaQuery.of(context).size.height < 450)
        ? 300.0
        : 450.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.greenAccent,
          borderRadius: 30,
          borderLength: 150,
          borderWidth: 20,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        insertsalereportsheet();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Itemstatus(id: result!.code)),
        );
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

void insertsalereportsheet() async {
  final response = await http.get(
    Uri.parse(
        'https://insert-data-from-db-to-sheet-4fszktl3uq-an.a.run.app/bill-01-09-2021-01-1'),
    headers: {
      'key': '30lpbF04YwvZusIfkEIxuAsaKwFQ58622b0e37OoBSg=',
    },
  );
  print(response.body);
}

void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
