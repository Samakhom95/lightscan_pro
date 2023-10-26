import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightscan_pro/thirdSrc/pdfviewer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class CompressFile extends StatefulWidget {
  const CompressFile({super.key});

  @override
  State<CompressFile> createState() => _CompressFileState();
}

class _CompressFileState extends State<CompressFile> {
  PlatformFile? selectedPdfFile;
  String pdfName = '';
  int pdfSize = 0;
  int pdfSizeNew = 0;
  bool isCompress = false;
  bool finishCompress = false;
  double _currentValue = 50;
  final uuid = const Uuid();

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        selectedPdfFile = result.files.first;
        pdfName = result.files.first.name;
        pdfSize = result.files.first.size;
      });
    } else {
      // User canceled the file picker
    }
  }

  void testCompressAndGetFile() async {
    final compressedPdfPath = await PdfManipulator().pdfCompressor(
      params: PDFCompressorParams(
          pdfPath: selectedPdfFile!.path!,
          imageQuality: 100 - _currentValue.toInt(),
          imageScale: 1),
    );
    File compressedPdfFile = File(compressedPdfPath!);
    int fileSize = await compressedPdfFile.length();

    setState(() {
      selectedPdfFile =
          PlatformFile(name: pdfName, size: fileSize, path: compressedPdfPath);
      pdfSizeNew = fileSize;
      finishCompress = true;
      isCompress = false;
    });
  }

  void share() async {
    await Share.shareXFiles([
      XFile(
        selectedPdfFile!.path!,
      )
    ]);
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
        title: const Text('Compress PDF'),
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
          selectedPdfFile == null
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const Column(
                      children: [
                        Text('*Notes'),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "- You can select any PDF, No size limit\n- Compressing file shouldn't take longer than 40 seconds",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selected PDF:'),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: InkWell(
                        onTap: () => {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: PdfViewer(
                                    selectedPdfFile: selectedPdfFile!,
                                  )))
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.picture_as_pdf_outlined),
                              SizedBox(
                                  width: 250,
                                  child: Text(selectedPdfFile!.name)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    isCompress == false
                        ? Container()
                        : const Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15.0),
                                  child: Text(
                                    'Compressing...',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.grey,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.cyanAccent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    finishCompress == false
                        ? Container()
                        : Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black54, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SelectableText(
                                      ' 🎉🎉 File reduced from ${{
                                        pdfSize / (1024 * 1024)
                                      }.toString().substring(1, 5)} MB to ${{
                                        pdfSizeNew / (1024 * 1024)
                                      }.toString().substring(1, 5)} MB 🎉🎉',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Details:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'PDF Size: ${{
                        selectedPdfFile!.size / (1024 * 1024)
                      }.toString().substring(1, 5)} MB',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'PDF Name: $pdfName ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                        'Compress Level: ${_currentValue.toInt().toString()}%'),
                    Slider(
                      activeColor: Colors.blueGrey,
                      inactiveColor: Colors.grey,
                      thumbColor: Colors.grey,
                      value: _currentValue,
                      min: 0,
                      max: 100,
                      onChanged: (value) {
                        setState(() {
                          _currentValue = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
          finishCompress == false
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => share(),
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
                  ],
                ),
          selectedPdfFile == null
              ? Container()
              : finishCompress == false
                  ? Center(
                      child: ElevatedButton(
                        onPressed: () => {
                          setState(() {
                            isCompress = true;
                            testCompressAndGetFile();
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
                        child: const Text('Compress'),
                      ),
                    )
                  : Container(),
          Center(
            child: ElevatedButton(
              onPressed: () => selectedPdfFile == null
                  ? _openFilePicker()
                  : {
                      setState(() {
                        selectedPdfFile = null;
                        pdfName = '';
                        isCompress = false;
                        finishCompress = false;
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
              child: Text(selectedPdfFile == null ? 'Pick File' : 'Clear'),
            ),
          ),
        ],
      ),
    );
  }
}
