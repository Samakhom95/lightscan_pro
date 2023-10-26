import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class CompressVideoScreen extends StatefulWidget {
  const CompressVideoScreen({super.key});

  @override
  State<CompressVideoScreen> createState() => _CompressVideoScreenState();
}

class _CompressVideoScreenState extends State<CompressVideoScreen> {
  VideoPlayerController? _videoPlayerController;
  final ImagePicker picker = ImagePicker();
  String fileName = '';
  String path = '';
  File? videoFile;
  String loading = '';
  String imgSize = 'None';
  String imgSize1 = 'None';
  String imgSize2 = 'None';
  String imgName = 'None';
  double frameratelevel = 30;
  double videoQuali = 55;
  VideoQuality hightQuali = VideoQuality.HighestQuality;
  VideoQuality mediumQuali = VideoQuality.MediumQuality;
  VideoQuality lowQuali = VideoQuality.LowQuality;
  bool blur = false;
  String compressLoading = '';
  bool isChecked = true;

  Future<void> selectVideo() async {
    final XFile? results = await picker.pickVideo(source: ImageSource.gallery);

    final File file = File(results!.path);
    final int fileSizeInBytes = await file.length();
    final double fileSizeInKB = fileSizeInBytes / 1024;
    final double fileSizeInMB = fileSizeInKB / 1024;
    final double fileSizeInGB = fileSizeInBytes / (1024 * 1024 * 1024);

    setState(() async {
      path = results.path;
      fileName = results.name.replaceFirst("image_picker", "");

      videoFile = File(results.path);
      loadVideoPlayer(videoFile);
      _videoPlayerController!.play();
      loading = 'Y';
      imgSize =
          'Size: ${fileSizeInMB.toStringAsFixed(2)} MB or ${fileSizeInGB.toStringAsFixed(3)} GB or ${fileSizeInKB.toStringAsFixed(1)} KB';
      imgSize1 = 'Size: ${fileSizeInMB.toStringAsFixed(2)} MB';
      imgName = fileName;
    });
  }

  void compressVideo(results) async {
    _videoPlayerController!.pause();

    setState(() async {
      await VideoCompress.setLogLevel(0);
      final info = await VideoCompress.compressVideo(results!.path,
          quality: videoQuali == 55
              ? mediumQuali
              : videoQuali == 10
                  ? hightQuali
                  : lowQuali,
          deleteOrigin: false,
          includeAudio: isChecked,
          frameRate: frameratelevel.toInt());
      final File file = File(info!.path!);
      final int fileSizeInBytes = await file.length();
      final double fileSizeInKB = fileSizeInBytes / 1024;
      final double fileSizeInMB = fileSizeInKB / 1024;
      final double fileSizeInGB = fileSizeInBytes / (1024 * 1024 * 1024);
      path = info.path!;

      videoFile = File(info.path!);
      loadVideoPlayer(videoFile);
      _videoPlayerController!.play();

      imgSize =
          'Size: ${fileSizeInMB.toStringAsFixed(2)} MB or ${fileSizeInGB.toStringAsFixed(3)} GB or ${fileSizeInKB.toStringAsFixed(1)} KB';
      imgSize2 = 'Size: ${fileSizeInMB.toStringAsFixed(2)} MB';
      blur = false;
    });
  }

  loadVideoPlayer(videoFile) {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }

    _videoPlayerController = VideoPlayerController.file(videoFile);
    _videoPlayerController!.initialize().then((value) {
      setState(() {});
    });
  }

  void share(video) async {
    await Share.shareXFiles([
      XFile(
        video.path,
      )
    ]);
  }

  void save(video) async {
    await GallerySaver.saveVideo(video.path);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved!!')));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        fileName == ""
            ? Navigator.pop(context)
            : setState(() {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
                _videoPlayerController!
                    .pause()
                    .then((value) => Navigator.pop(context));
              });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark),
          title: const Text('Compress Video'),
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
            loading == ''
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
                      imgName == 'None'
                          ? const Column(
                              children: [
                                Text(
                                  '*Notes',
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "- You can choose any video, No limit size or duration\n - The bigger the size the longer it takes\n- 1200 Mb or 1.2 Gb could takes up to 7 minutes with medium level\n- Or videos that has less than 1 minutes shouldn't takes more than 50 second\n- Videos that has more than 5 minutes could takes up to 6 minutes with medium level",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                          : const Text('Initializing... Please wait')
                    ],
                  )
                : Column(
                    children: [
                      if (_videoPlayerController != null) ...[
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 400,
                              child: PinchZoomReleaseUnzoomWidget(
                                child: ImageFiltered(
                                  enabled: blur,
                                  imageFilter:
                                      ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                  child: AspectRatio(
                                    aspectRatio: _videoPlayerController!
                                        .value.aspectRatio,
                                    child: VideoPlayer(_videoPlayerController!),
                                  ),
                                ),
                              ),
                            ),
                            blur == false
                                ? Container()
                                : const Column(
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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.cyanAccent),
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      ],
                      VideoProgressIndicator(_videoPlayerController!,
                          allowScrubbing: blur == false ? true : false,
                          colors: const VideoProgressColors(
                            backgroundColor: Colors.black,
                            playedColor: Colors.cyanAccent,
                            bufferedColor: Colors.black12,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _videoPlayerController!,
                            builder: (context, VideoPlayerValue value, child) {
                              return Text(
                                  "${value.position.toString().substring(0, 7)} / ",
                                  style: const TextStyle(color: Colors.grey));
                            },
                          ),
                          Text(
                              _videoPlayerController!.value.duration
                                  .toString()
                                  .substring(0, 7),
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      blur == true
                          ? Container()
                          : Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (_videoPlayerController!
                                          .value.isPlaying) {
                                        _videoPlayerController!.pause();
                                      } else {
                                        _videoPlayerController!.play();
                                      }

                                      setState(() {});
                                    },
                                    icon: Icon(
                                      _videoPlayerController!.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      _videoPlayerController!
                                          .seekTo(const Duration(seconds: 0));

                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.replay)),
                              ],
                            ),
                      imgSize2 == 'None'
                          ? Container()
                          : Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black54, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SelectableText(
                                    ' 🎉 Video reduced from $imgSize1 to $imgSize2 🎉',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
            loading == ''
                ? Center(
                    child: ElevatedButton(
                      onPressed: () => {
                        setState(() {
                          selectVideo();
                          imgName = '';
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
                      child: const Text('Pick Video'),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Details:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        imgSize,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Name: $imgName',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      imgSize2 == 'None'
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () => save(videoFile),
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
                                  width: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () => share(videoFile),
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
                      compressLoading == 'Y'
                          ? Container()
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Compress level:'),
                                    Text('${videoQuali.toInt().toString()}%'),
                                    Text(videoQuali == 10
                                        ? '(Lowest)'
                                        : videoQuali == 55
                                            ? '(Medium)'
                                            : '(Highest)')
                                  ],
                                ),
                                Slider(
                                  activeColor: Colors.blueGrey,
                                  inactiveColor: Colors.grey,
                                  thumbColor: Colors.grey,
                                  value: videoQuali,
                                  divisions: 2,
                                  min: 10,
                                  max: 100,
                                  onChanged: (value) {
                                    setState(() {
                                      videoQuali = value;
                                    });
                                  },
                                ),
                                Text(
                                    'Frame rate: ${frameratelevel.toInt().toString()}'),
                                Slider(
                                  activeColor: Colors.blueGrey,
                                  inactiveColor: Colors.grey,
                                  thumbColor: Colors.grey,
                                  value: frameratelevel,
                                  min: 30,
                                  max: 160,
                                  onChanged: (value) {
                                    setState(() {
                                      frameratelevel = value;
                                    });
                                  },
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
                                    const Text('Include Audio'),
                                  ],
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () => setState(() {
                                      compressVideo(videoFile);
                                      blur = true;
                                      compressLoading = 'Y';
                                    }),
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
                            ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => {
                            _videoPlayerController!.pause(),
                            setState(() {
                              fileName = '';
                              path = '';
                              videoFile = null;
                              loading = '';
                              blur = false;
                              compressLoading = '';
                              imgSize2 = 'None';
                              imgName = 'None';
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
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
