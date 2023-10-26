import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:torch_controller/torch_controller.dart';

class FlashLightScreen extends StatefulWidget {
  const FlashLightScreen({super.key});

  @override
  State<FlashLightScreen> createState() => _FlashLightScreenState();
}

class _FlashLightScreenState extends State<FlashLightScreen> {
  String flashOn = '';
  String screenLight = '';
  QRViewController? controller;
  final torchController = TorchController();

  void srcBrightness() {
    setState(() {
      ScreenBrightness().setScreenBrightness(1.0);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScreenBrightness().resetScreenBrightness();
        Navigator.pop(context);

        return false;
      },
      child: GestureDetector(
        onTap: () => {
          setState(() {
            screenLight = '';
            ScreenBrightness().resetScreenBrightness();
          })
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness:
                  screenLight == '' ? Brightness.dark : Brightness.light,
              statusBarBrightness:
                  screenLight == '' ? Brightness.dark : Brightness.light,
            ),
            title: Text(screenLight == '' ? 'Flash Light' : ''),
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
              const SizedBox(height: 100,),
              screenLight == ''
                  ? Column(
                      children: [
                        IconButton(
                          iconSize: 150,
                            onPressed: () => torchController.toggle(),
                            icon: const Icon(Icons.flashlight_on_outlined,)),
                             const SizedBox(height: 100,),
                      IconButton(
                          iconSize: 150,
                            onPressed: () => setState(() {
                              screenLight = 'Y';
                              srcBrightness();
                            }),
                            icon: const Icon(Icons.stay_current_portrait_outlined,)),
                   
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
