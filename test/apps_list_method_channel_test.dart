import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apps_list/apps_list_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAppsList platform = MethodChannelAppsList();
  const MethodChannel channel = MethodChannel('apps_list');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getAppsList', () async {
    expect(await platform.getInstalledApps(), isNotNull);
  });
}
