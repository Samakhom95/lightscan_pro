import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark),
        title: const Text('Setting'),
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
      InkWell(
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  width: 30.0,
                  height: 60.0,
                ),
                Text(
                  '- Source code',
                  style: TextStyle(),
                ),
              ]),
              onTap: () => {}),
              InkWell(
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  width: 30.0,
                  height: 60.0,
                ),
                Text(
                  '- Request features',
                  style: TextStyle(),
                ),
              ]),
              onTap: () => {}),
            
    ],),
    );
  }
}