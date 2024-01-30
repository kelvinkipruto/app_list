import 'package:apps_list/app_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apps_list/apps_list.dart';
import 'package:apps_list/apps_list_platform_interface.dart';
import 'package:apps_list/apps_list_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppsListPlatform
    with MockPlatformInterfaceMixin
    implements AppsListPlatform {
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<List<AppInfoByProfile>> getInstalledApps() {
    return Future.value([]);
  }

  @override
  Future<void> launchApp(String packageName, int serialNumber) {
    return Future.value();
  }
}

void main() {
  final AppsListPlatform initialPlatform = AppsListPlatform.instance;

  test('$MethodChannelAppsList is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppsList>());
  });

  test('getAppsList', () async {
    AppsList appsListPlugin = AppsList();
    MockAppsListPlatform fakePlatform = MockAppsListPlatform();
    AppsListPlatform.instance = fakePlatform;

    List<AppInfoByProfile> apps = await appsListPlugin.getInstalledApps();
    expect(apps, isNotNull);
  });
}
