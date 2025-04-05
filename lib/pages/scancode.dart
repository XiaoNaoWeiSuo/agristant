import 'dart:developer';
import 'dart:io';
import 'package:agristant/common/adapter.dart';
import 'package:agristant/pages/browser.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scancode extends StatefulWidget {
  const Scancode({super.key});

  @override
  State<StatefulWidget> createState() => _ScancodeState();
}

class _ScancodeState extends State<Scancode> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool islight = false;
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
    Adapt.initialize(context);
    return Scaffold(
        body: Stack(children: [
      _buildQrView(context),
      Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
              onTap: () async {
                await controller?.toggleFlash();
                setState(() {
                  islight = !islight;
                });
              },
              child: Container(
                  margin: const EdgeInsets.only(bottom: 100),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: islight ? Colors.white : Colors.white10,
                      borderRadius: BorderRadius.circular(60)),
                  child: Center(
                      child: Icon(Icons.lightbulb_outline,
                          color: islight ? Colors.black : Colors.white)))))
    ]));
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      if (result != null) {
        controller.pauseCamera();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Browser(value: result!.code.toString()),
          ),
        ).then((v) {
          controller.resumeCamera();
        });
      }
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
