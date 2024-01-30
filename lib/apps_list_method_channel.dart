import 'package:apps_list/app_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'apps_list_platform_interface.dart';

/// An implementation of [AppsListPlatform] that uses method channels.
class MethodChannelAppsList extends AppsListPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('apps_list');

  // launch app
  @override
  Future<void> launchApp(String packageName, int serialNumber) async {
    try {
      await methodChannel.invokeMethod('launchApp', {
        'packageName': packageName,
        'serialNumber': serialNumber,
      });
    } on PlatformException {
      if (kDebugMode) {
        print('Failed to launch app.');
      }
    }
  }

  // get installed apps
  @override
  Future<List<AppInfo>> getInstalledApps() async {
    try {
      List<Object?> apps = await methodChannel.invokeMethod('getInstalledApps');
      List<AppInfo> appInfoList =
          apps.map((app) => AppInfo.create(app)).toList();
      return Future.value(appInfoList);
    } on PlatformException {
      debugPrint("APPS ERROR");
      return Future.value([]);
    }
  }
}
