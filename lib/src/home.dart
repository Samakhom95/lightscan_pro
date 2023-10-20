import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightscan_pro/secSrc/deviceinfo.dart';
import 'package:lightscan_pro/secSrc/filecompress.dart';
import 'package:lightscan_pro/secSrc/imagecompress.dart';
import 'package:lightscan_pro/secSrc/qrgenerator.dart';
import 'package:lightscan_pro/secSrc/scanner.dart';
import 'package:lightscan_pro/secSrc/timer.dart';
import 'package:lightscan_pro/secSrc/videocompress.dart';
import 'package:lightscan_pro/src/setting.dart';
import 'package:lightscan_pro/thirdSrc/openpdf.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
bool showOn = false;

@override
void initState() {
  super.initState();
  getSwitchValues();
}

void navigateToQrScanner() {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.rightToLeft,
      child: const QrScanner(),
    ),
  );
}

getSwitchValues() async {
  showOn = await loadbool();
  if (showOn) {
    navigateToQrScanner();
  }
}

Future<bool> loadbool() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? showOnValue = prefs.getBool("onStart");
  if (showOnValue != null) {
    setState(() {
      showOn = showOnValue;
    });
    return showOnValue;
  }
  return false;
}

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.material),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark),
          title: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    "assets/images/1.png",
                    width: 40,
                    height: 40,
                  )),
              const SizedBox(
                width: 15,
              ),
              const Text(
                'LightScan Pro',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          titleTextStyle: const TextStyle(
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              color: Colors.black,
              iconSize: 25,
              onPressed: () => Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const SettingScreen())),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Proudly present:',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            InkWell(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 60.0,
                  ),
                  Icon(Icons.qr_code_scanner),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Qr code scanner'),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const QrScanner()));
              },
            ),
            InkWell(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 60.0,
                  ),
                  Icon(Icons.qr_code_2_rounded),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Qr code generator'),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const QrGenerator()));
              },
            ),
            InkWell(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 60.0,
                  ),
                  Icon(Icons.image),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Compress Image'),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const CompressImageScreen()));
              },
            ),
            InkWell(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 60.0,
                  ),
                  Icon(Icons.video_settings_outlined),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Compress Video'),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const CompressVideoScreen()));
              },
            ),
            InkWell(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 60.0,
                  ),
                  Icon(Icons.picture_as_pdf_rounded),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Compress PDF'),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const CompressFile()));
              },
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'More features:',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            InkWell(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 60.0,
                  ),
                  Icon(Icons.picture_as_pdf_outlined),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('PDF Viewer'),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const PdfViewerScreen()));
              },
            ),
            InkWell(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 60.0,
                  ),
                  Icon(Icons.radio_button_checked_outlined),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('F1 Reaction Test'),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const TimerScreen()));
              },
            ),
            InkWell(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 60.0,
                  ),
                  Icon(Icons.device_unknown_rounded),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Device Info'),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const DeviceinfoScreen()));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () => SystemNavigator.pop(),
                child: const Center(
                    child: Text(
                  'Quit',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                )))
          ],
        ),
      ),
    );
  }
}
