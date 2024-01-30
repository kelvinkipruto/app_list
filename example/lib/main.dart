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
  final _appsListPlugin = AppsList();
  List<AppInfoByProfile> _apps = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    List<AppInfoByProfile> apps = [];
    try {
      apps = await _appsListPlugin.getInstalledApps();
    } on PlatformException {
      throw Exception("Failed to get apps");
    }

    if (!mounted) return;

    setState(() {
      _apps = apps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App List Example'),
        ),
        body: ListView.builder(
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
      ),
    );
  }
}
