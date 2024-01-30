import 'package:apps_list/app_info.dart';
import 'apps_list_platform_interface.dart';

/// A class that provides methods to interact with installed apps.
///
/// This class uses the platform interface to interact with the native platform.
/// It provides methods to launch an app and get a list of installed apps.
class AppsList {
  /// Launches an app with the given package name and serial number.
  ///
  /// This method uses the platform interface to send a request to the native platform
  /// to launch the app with the given package name and serial number.
  Future<void> launchApp(String packageName, int serialNumber) async {
    return AppsListPlatform.instance.launchApp(packageName, serialNumber);
  }

  /// Fetches a list of all installed apps.
  ///
  /// This method uses the platform interface to send a request to the native platform
  /// to get a list of all installed apps. It returns a Future that resolves to a list
  /// of [AppInfo] instances representing the installed apps.
  Future<List<AppInfo>> getInstalledApps() async {
    return AppsListPlatform.instance.getInstalledApps();
  }
}
