import 'package:flutter_test/flutter_test.dart';
import 'package:apps_list/apps_list.dart';
import 'package:apps_list/apps_list_platform_interface.dart';
import 'package:apps_list/apps_list_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppsListPlatform
    with MockPlatformInterfaceMixin
    implements AppsListPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AppsListPlatform initialPlatform = AppsListPlatform.instance;

  test('$MethodChannelAppsList is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppsList>());
  });

  test('getPlatformVersion', () async {
    AppsList appsListPlugin = AppsList();
    MockAppsListPlatform fakePlatform = MockAppsListPlatform();
    AppsListPlatform.instance = fakePlatform;

    expect(await appsListPlugin.getPlatformVersion(), '42');
  });
}
