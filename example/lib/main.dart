import 'package:apps_list/app_info.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:apps_list/apps_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _appsListPlugin = AppsList();
  List<AppInfoByProfile> _apps = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    List<AppInfoByProfile> apps = [];
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _appsListPlugin.getPlatformVersion() ??
          'Unknown platform version';
      apps = await _appsListPlugin.getInstalledApps();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _apps = apps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _apps.length,
                itemBuilder: (context, index) {
                  final application = _apps[index];
                  return ListTile(
                    leading: Image.memory(application.icon),
                    title: Text(application.name),
                    subtitle: Text(
                        "${application.packageName} ${application.serialNumber} ${application.profile}"),
                    onTap: () => _appsListPlugin.launchApp(
                        application.packageName, application.serialNumber),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
