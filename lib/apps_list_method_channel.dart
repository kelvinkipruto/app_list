import 'package:apps_list/app_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'apps_list_platform_interface.dart';

/// An implementation of [AppsListPlatform] that uses method channels.
///
/// This class provides methods to interact with the native platform
/// to fetch installed apps and launch a specific app.
class MethodChannelAppsList extends AppsListPlatform {
  /// The method channel used to interact with the native platform.
  ///
  /// This channel is used to send method calls to the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('apps_list');

  /// Launches an app with the given package name and serial number.
  ///
  /// This method sends a method call to the native platform to launch the app.
  /// If the app fails to launch, a message is printed in debug mode.
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

  /// Fetches a list of all installed apps.
  ///
  /// This method sends a method call to the native platform to fetch the list of apps.
  /// If the method call fails, an empty list is returned.
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
