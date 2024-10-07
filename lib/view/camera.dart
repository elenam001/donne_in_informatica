import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScannerPage extends StatefulWidget {
  final Function(String) onScanned;

  QRCodeScannerPage({required this.onScanned});

  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                if (state == TorchState.on) {
                  return const Icon(Icons.flash_on);
                } else {
                  return const Icon(Icons.flash_off);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (barcode, args) async {
          if (barcode.rawValue != null) {
            final String code = barcode.rawValue!;
            widget.onScanned(code);
            await Future.delayed(Duration(milliseconds: 500)); 
            if (mounted) { 
              Navigator.pop(context);
            }
          }
        }
      ),
    );
  }
}
