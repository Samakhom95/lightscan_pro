import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightscan_pro/webApp/terms.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
                  '- Github',
                  style: TextStyle(),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'),
                )
              ]),
              onTap: () => {
                    launchUrlString(
                        'https://github.com/Samakhom95/lightscan_pro')
                  }),
          InkWell(
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  width: 30.0,
                  height: 60.0,
                ),
                Text(
                  '- Terms and Conditions',
                  style: TextStyle(),
                ),
              ]),
              onTap: () => {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const TermsSrc()))
                  }),
                  const SizedBox(height: 50,),
           Row(
    mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              const Text('Developed with love ❤️ by:',style: TextStyle(fontSize: 12),),
              const SizedBox(width: 5,),
              GestureDetector(
onTap: () => launchUrlString(
                        'https://www.instagram.com/phil_nattawoot/'),
                child: const Text('@phil_nattawoot',style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 12)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
