import 'package:apps_list/app_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'apps_list_platform_interface.dart';

/// An implementation of [AppsListPlatform] that uses method channels.
class MethodChannelAppsList extends AppsListPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('apps_list');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // launch app
  Future<void> launchApp(String packageName, int serialNumber) async {
    try {
      await methodChannel.invokeMethod('launchApp', {
        'packageName': packageName,
        'serialNumber': serialNumber,
      });
    } on PlatformException {
      print('Failed to launch app.');
    }
  }

  Future<List<AppInfoByProfile>> getInstalledApps() async {
    // Call relevant Kotlin method
    try {
      List<Object?> apps = await methodChannel.invokeMethod('getInstalledApps');
      List<AppInfoByProfile> appInfoList =
          apps.map((app) => AppInfoByProfile.create(app)).toList();
      return Future.value(appInfoList);
    } on PlatformException {
      debugPrint("APPS ERROR");
      return Future.value([]);
    }
  }
}
