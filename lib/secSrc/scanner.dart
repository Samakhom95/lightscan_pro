import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String loading = '';
  final ImagePicker picker = ImagePicker();
  String path = '';
  File? imageFile;
  bool blur = false;
  String scanImageString = '';

//Scan success
  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      launchUrlString(result!.code!);
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void selectFile() async {
    final XFile? results = await picker.pickImage(source: ImageSource.gallery);

    if (results != null) {
      path = results.path;
    }
    setState(() {
      imageFile = File(results!.path);
    });
  }

  void scanImage() async {
    String? results = await Scan.parse(imageFile!.path);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        scanImageString = results!;
      });
      launchUrlString(scanImageString);
    });
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 350.0;
    const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          imageFile == null
              ? Expanded(
                  flex: 1,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                        borderColor: Colors.white,
                        borderRadius: 10,
                        borderLength: 15,
                        borderWidth: 5,
                        cutOutSize: scanArea),
                  ),
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: ImageFiltered(
                        enabled: blur,
                        imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Image.file(
                            width: 400,
                            height: 400,
                            fit: BoxFit.contain,
                            imageFile!),
                      ),
                    ),
                    blur == true
                        ? const Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 15.0),
                                child: Text(
                                  'Scanning...',
                                  style: TextStyle(color: Colors.limeAccent),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.cyanAccent),
                                ),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
          imageFile == null
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 21,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.flash_on,
                          size: 21,
                        ),
                        onPressed: () async {
                          await controller!.toggleFlash();
                        }),
                    IconButton(
                        icon: const Icon(
                          Icons.flip_camera_ios_rounded,
                          size: 21,
                        ),
                        onPressed: () async {
                          await controller!.flipCamera();
                        }),
                  ],
                )
              : Container(),
          Expanded(
            child: Center(
              child: (result != null)
                  ? Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Output:'),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SelectableText(
                              result!.code!,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => Clipboard.setData(
                                      ClipboardData(text: result!.code!))
                                  .then((value) {
                                Fluttertoast.showToast(
                                  msg: 'copied!!!',
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.grey[400],
                                  textColor: Colors.black,
                                );
                              }),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white54,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Copy'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () => Share.share(
                                (result!.code!),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white54,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Share'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await launchUrlString(result!.code!);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white54,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Open in browser'),
                            ),
                          ],
                        )
                      ],
                    )
                  : imageFile == null
                      ? Column(
                          children: [
                            const Text(
                              'Scan any qr code',
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () => selectFile(),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  backgroundColor: Colors.white54,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Upload'),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Output:'),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black54, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SelectableText(
                                  scanImageString,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            scanImageString == ''
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => Clipboard.setData(
                                                ClipboardData(
                                                    text: scanImageString))
                                            .then((value) {
                                          Fluttertoast.showToast(
                                            msg: 'copied!!!',
                                            gravity: ToastGravity.TOP,
                                            backgroundColor: Colors.grey[400],
                                            textColor: Colors.black,
                                          );
                                        }),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black87,
                                          backgroundColor: Colors.white54,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text('Copy'),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Share.share(
                                          (scanImageString),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black87,
                                          backgroundColor: Colors.white54,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text('Share'),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await launchUrlString(
                                              scanImageString);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black87,
                                          backgroundColor: Colors.white54,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text('Open in browser'),
                                      ),
                                    ],
                                  ),
                            ElevatedButton(
                              onPressed: () => setState(() {
                                blur = true;
                                scanImage();
                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    blur = false;
                                  });
                                });
                              }),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white54,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Scan'),
                            ),
                            ElevatedButton(
                              onPressed: () => setState(() {
                                path = '';
                                imageFile = null;
                                scanImageString = '';
                              }),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white54,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
            ),
          )
        ],
      ),
    );
  }
}
