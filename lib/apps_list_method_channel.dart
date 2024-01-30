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
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
