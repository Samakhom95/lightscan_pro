import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceinfoScreen extends StatefulWidget {
  const DeviceinfoScreen({super.key});

  @override
  State<DeviceinfoScreen> createState() => _DeviceinfoScreenState();
}

class _DeviceinfoScreenState extends State<DeviceinfoScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'brand': build.brand,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'hardware': build.hardware,
      'product': build.product,
      'sdkInt': build.version.sdkInt,
      'release': build.version.release,
      'device': build.device,
      'display': build.display,
      'systemFeatures': build.systemFeatures,
      'id': build.id,
      'fingerprint': build.fingerprint,
      'securityPatch': build.version.securityPatch,
      'incremental': build.version.incremental,
      'codename': build.version.codename,
      'board': build.board,
      'bootloader': build.bootloader,
      'host': build.host,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
    };
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
        title: const Text('Device Info'),
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
        children: _deviceData.keys.map(
          (String property) {
            return Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    property,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  child: Text(
                    '${_deviceData[property]}',
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
