import 'dart:typed_data';

import 'package:flutter/material.dart';

// enum AppProfile {
//   Work,
//   Personal

//   // from string
// }

class AppInfo {
  String name;
  Uint8List icon;
  String packageName;
  bool isSystemApp;

  AppInfo(this.name, this.icon, this.packageName, this.isSystemApp);

  factory AppInfo.create(dynamic data) {
    return AppInfo(
      data["name"],
      data["icon"],
      data["package_name"],
      data["is_system_app"],
    );
  }

  int compareTo(AppInfo other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return "AppInfo{name=$name, packageName=$packageName, isSystemApp=$isSystemApp";
  }
}

class AppInfoByProfile extends AppInfo {
  // profile can only be personal or work
  String profile;
  int serialNumber;

  AppInfoByProfile(String name, Uint8List icon, String packageName,
      bool isSystemApp, this.profile, this.serialNumber)
      : super(name, icon, packageName, isSystemApp);

  factory AppInfoByProfile.create(dynamic data) {
    // AppProfile profile = AppProfile.values[data["profile"]];
    return AppInfoByProfile(
      data["name"],
      data["icon"],
      data["package_name"],
      data["is_system_app"],
      data["profile"],
      data["serial_number"],
    );
  }

  @override
  String toString() {
    return "AppInfoByProfile{name=$name, packageName=$packageName, isSystemApp=$isSystemApp, profile=$profile";
  }
}
