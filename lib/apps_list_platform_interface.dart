import 'package:apps_list/app_info.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apps_list_method_channel.dart';

/// An abstract class that defines the interface for the AppsList platform.
///
/// This class serves as a contract for all implementations of the AppsList platform.
/// It provides two methods: one for launching an app and another for getting installed apps.
abstract class AppsListPlatform extends PlatformInterface {
  /// Constructs a AppsListPlatform.
  ///
  /// This constructor initializes the superclass with a unique token.
  AppsListPlatform() : super(token: _token);

  /// A unique token used to verify the platform implementation.
  static final Object _token = Object();

  /// The instance of the platform implementation.
  ///
  /// This is initially set to an instance of [MethodChannelAppsList].
  static AppsListPlatform _instance = MethodChannelAppsList();

  /// The default instance of [AppsListPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppsList].
  static AppsListPlatform get instance => _instance;

  /// Sets the instance of the platform implementation.
  ///
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppsListPlatform] when
  /// they register themselves.
  static set instance(AppsListPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Launches an app with the given package name and serial number.
  ///
  /// This method should be overridden by platform-specific implementations.
  Future<void> launchApp(String packageName, int serialNumber) async {
    throw UnimplementedError('launchApp() has not been implemented.');
  }

  /// Fetches a list of all installed apps.
  ///
  /// This method should be overridden by platform-specific implementations.
  Future<List<AppInfo>> getInstalledApps() async {
    throw UnimplementedError(
        'getInstalledAppsByProfile() has not been implemented.');
  }
}
