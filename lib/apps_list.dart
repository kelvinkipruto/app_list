
import 'apps_list_platform_interface.dart';

class AppsList {
  Future<String?> getPlatformVersion() {
    return AppsListPlatform.instance.getPlatformVersion();
  }
}
