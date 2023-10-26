// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class QrGenerator extends StatefulWidget {
  const QrGenerator({super.key});

  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  final TextEditingController text = TextEditingController();
  String loading = '';
  late Uint8List imageFile;
  double _currentValue = 180;
  ScreenshotController screenshotController = ScreenshotController();
  final uuid = const Uuid();
  bool isChecked = false;
  bool blur = false;

  void pasteText() {
    FlutterClipboard.paste().then((value) {
      setState(() {
        text.text = value;
      });
    });
  }

  void share(image) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/${uuid.v4()}.png').create();
    await imagePath.writeAsBytes(image);
    await Share.shareXFiles([
      XFile(
        imagePath.path,
      )
    ]);
  }

  void save(image) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/${uuid.v4()}.png').create();
    await imagePath.writeAsBytes(image);
    await GallerySaver.saveImage(
      imagePath.path,
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Qr Saved!!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark),
        title: const Text('Qr code generator'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: text,
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  errorStyle: const TextStyle(color: Colors.grey),
                  hintText: 'Type anything',
                  filled: false,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  suffix: InkWell(
                    onTap: pasteText,
                    child: const Text(
                      'Paste',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.blueGrey,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              const Text('White Background'),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          loading == '' || text.text == ''
              ? Container()
              : Center(
                  child: Screenshot(
                    controller: screenshotController,
                    child: isChecked == false
                        ? Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [
                                  Colors.blueAccent,
                                  Colors.purpleAccent
                                ],
                              ),
                            ),
                            child: QrImageView(
                              data: text.text,
                              version: QrVersions.auto,
                              size: _currentValue,
                              gapless: false,
                            ),
                          )
                        : QrImageView(
                            backgroundColor: Colors.white,
                            data: text.text,
                            version: QrVersions.auto,
                            size: _currentValue,
                            gapless: false,
                          ),
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          blur == false
              ? Container()
              : const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        'Generating...',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                      ),
                    ),
                  ],
                ),
          loading == '' || text.text == ''
              ? Center(
                  child: ElevatedButton(
                    onPressed: () => {
                      text.text.isEmpty
                          ? Container()
                          : {
                              setState(() {
                                blur = true;
                              }),
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                setState(() {
                                  blur = false;
                                  loading = 'Y';
                                });
                              })
                            }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white54,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Generate'),
                  ),
                )
              : Column(
                  children: [
                    const Text(
                      'Expand:',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Slider(
                      activeColor: Colors.blueGrey,
                      inactiveColor: Colors.grey,
                      thumbColor: Colors.grey,
                      value: _currentValue,
                      min: 100,
                      max: 400,
                      onChanged: (value) {
                        setState(() {
                          _currentValue = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        setState(() {
                          loading = '';
                          text.clear();
                        })
                      },
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
                    ElevatedButton(
                      onPressed: () {
                        screenshotController.capture().then((image) {
                          setState(() {
                            imageFile = image!;
                          });
                        }).then((value) => share(imageFile));
                      },
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
                    ElevatedButton(
                      onPressed: () => {
                        screenshotController.capture().then((image) {
                          setState(() {
                            imageFile = image!;
                          });
                        }).then((value) => save(imageFile))
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.white54,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
