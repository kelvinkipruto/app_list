import 'package:apps_list/app_info.dart';

import 'apps_list_platform_interface.dart';

class AppsList {
  Future<void> launchApp(String packageName, int serialNumber) async {
    return AppsListPlatform.instance.launchApp(packageName, serialNumber);
  }

  Future<List<AppInfoByProfile>> getInstalledApps() async {
    return AppsListPlatform.instance.getInstalledApps();
  }
}
