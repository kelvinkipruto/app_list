import 'package:apps_list/app_info.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apps_list_method_channel.dart';

abstract class AppsListPlatform extends PlatformInterface {
  /// Constructs a AppsListPlatform.
  AppsListPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppsListPlatform _instance = MethodChannelAppsList();

  /// The default instance of [AppsListPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppsList].
  static AppsListPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppsListPlatform] when
  /// they register themselves.
  static set instance(AppsListPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> launchApp(String packageName, int serialNumber) async {
    throw UnimplementedError('launchApp() has not been implemented.');
  }

  Future<List<AppInfo>> getInstalledApps() async {
    throw UnimplementedError(
        'getInstalledAppsByProfile() has not been implemented.');
  }
}
