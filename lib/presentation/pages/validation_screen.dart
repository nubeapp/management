import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/validation_data.dart';
import 'package:validator/domain/services/validation_service_interface.dart';
import 'package:validator/presentation/styles/logger.dart';
import 'package:validator/presentation/widgets/button.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key, required this.event});

  final Event event;

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  final _validationService = GetIt.instance<IValidationService>();
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) {
      setState(() => result = scanData);
      readQR();
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void readQR() async {
    if (result != null) {
      controller!.pauseCamera();
      ValidationData validationData = ValidationData(eventId: widget.event.id!, reference: result!.code.toString());
      _validationService.validateTicket(validationData, _onSuccessHandler, _onErrorHandler);
      // controller!.dispose();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onSuccessHandler(bool isValidated) {
    if (isValidated) {
      Logger.info('Ticket validated!');
      _showDialog(color: Colors.green, icon: CupertinoIcons.check_mark);
    }
  }

  void _onErrorHandler(String errorMessage) {
    if (errorMessage.contains('404')) {
      _showDialog(color: Colors.red, icon: CupertinoIcons.clear);
      Logger.debug('Ticket does not exist');
    } else if (errorMessage.contains('409')) {
      _showDialog(color: Colors.orange, icon: CupertinoIcons.clear);
      Logger.debug('Ticket already validated');
    }
  }

  void _showDialog({required color, required icon}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Apply the blur effect here
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: color,
                  width: 3.0,
                ),
                color: color.withOpacity(0.75),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 4.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Button.white(
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller!.resumeCamera();
                    },
                    text: 'Close',
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 13, 13, 13),
        body: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                overlayColor: Colors.black.withOpacity(0.8),
                borderColor: Colors.orange,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(CupertinoIcons.back),
                color: Colors.white,
                iconSize: 40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
