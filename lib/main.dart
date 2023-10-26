import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightscan_pro/src/home.dart';
import 'package:torch_controller/torch_controller.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  TorchController().initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: const HomeScreen(),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
    );
  }
}
