import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class CompressImageScreen extends StatefulWidget {
  const CompressImageScreen({super.key});

  @override
  State<CompressImageScreen> createState() => _CompressImageScreenState();
}

class _CompressImageScreenState extends State<CompressImageScreen> {
  final ImagePicker picker = ImagePicker();
  String fileName = '';
  String path = '';
  File? imageFile;
  String loading = '';
  String imgSize = 'None';
  String newImgSize = 'None';
  String imgName = 'None';
  File? compressImageFile;
  double _currentValue = 50;
  String loading1 = '';
  bool blur = false;
  final uuid = const Uuid();

  void selectFile() async {
    final XFile? results = await picker.pickImage(source: ImageSource.gallery);

    if (results != null) {
      path = results.path;
      fileName = results.name.replaceFirst("image_picker", "");
      final File file = File(results.path);
      final int fileSizeInBytes = await file.length();
      final double fileSizeInKB = fileSizeInBytes / 1024;
      final double fileSizeInMB = fileSizeInKB / 1024;

      imgSize = '${fileSizeInMB.toStringAsFixed(2)} MB';
      imgName = fileName;
    }
    
    setState(() {
      imageFile = File(results!.path);
    });
  }

  void share(image) async {
    await Share.shareXFiles([
      XFile(
        image.path,
      )
    ]);
  }

  void save(image) async {
    await GallerySaver.saveImage(image.path);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved!!')));
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
        title: const Text('Compress Image'),
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
          imageFile == null
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
                          child: Text("- You can select any image, No size limit\n- Compressing image shouldn't take longer than 10 seconds",style: TextStyle(color: Colors.grey),),
                        ),
                      ],
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        PinchZoomReleaseUnzoomWidget(
                          child: ImageFiltered(
                            enabled: blur,
                            imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Image.file(
                              width: 400,
                              height: 400,
                              fit: BoxFit.contain,
                              compressImageFile == null
                                  ? imageFile!
                                  : compressImageFile!,
                            ),
                          ),
                        ),
                        loading1 == 'Y'
                            ? const Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15.0),
                                    child: Text(
                                      'Compressing...',
                                      style: TextStyle(color: Colors.white),
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
                              )
                            : Container()
                      ],
                    ),
                    newImgSize=='None'
                    ?Container()
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
                                      ' 🎉🎉 Image reduced from $imgSize to $newImgSize 🎉🎉',
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
                    const Text(
                      'Details:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(newImgSize=='None'?'Size: $imgSize':'Size: $newImgSize',
                      
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Image Name: $imgName',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    loading == ''
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              Center(
                                child: ElevatedButton(
                                  onPressed: () => {
                                    setState(() {
                                      compressFile(imageFile!);
                                      loading = 'Y';
                                      loading1 = 'Y';
                                      blur = true;
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        setState(() {
                                          loading1 = '';
                                          blur = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text('Success!!')));
                                        });
                                      });
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
                              ),
                            ],
                          )
                        : Column(
                            children: [
                           
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => save(compressImageFile!),
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
                                    width: 15,
                                  ),
                                  ElevatedButton(
                                    onPressed: () => share(compressImageFile),
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
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    
                  ],
                ),
          Center(
            child: ElevatedButton(
              onPressed: () => imageFile == null
                  ? selectFile()
                  : setState(() {
                      imageFile = null;
                      compressImageFile = null;
                      loading = '';
                      fileName = '';
                      path = '';
                      imgSize = 'None';
                      newImgSize = 'None';
                      imgName = 'None';
                    }),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.white54,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(imageFile == null ? 'Pick Image' : 'Clear'),
            ),
          ),
        ],
      ),
    );
  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 100 - _currentValue.toInt(),
    );
    final File file1 = File(result!.path);
    final int fileSizeInBytes = await file1.length();
    final double fileSizeInKB = fileSizeInBytes / 1024;
    final double fileSizeInMB = fileSizeInKB / 1024;

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        newImgSize = '${fileSizeInMB.toStringAsFixed(2)} MB';

        compressImageFile = File(result.path);
        imgName = result.name;
      });
    });
    return file;
  }
}
