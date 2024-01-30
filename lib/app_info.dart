/// Dart package for handling app information.
import 'dart:typed_data';

/// An enumeration of profile types.
///
/// This enum is used to distinguish between different types of profiles
/// on a device. Currently, it supports two types: `personal` and `work`.
enum ProfileType {
  /// Represents a personal profile on a device.
  personal,

  /// Represents a work profile on a device.
  work
}

/// Class representing information about an app.
class AppInfo {
  /// The name of the app.
  String name;

  /// The icon of the app as a list of unsigned 8-bit integers.
  Uint8List icon;

  /// The package name of the app.
  String packageName;

  /// A boolean value indicating whether the app is a system app.
  bool isSystemApp;

  /// The profile associated with the app.
  ProfileType profile;

  /// The serial number of the app.
  int serialNumber;

  /// Constructor for the AppInfo class.
  AppInfo(this.name, this.icon, this.packageName, this.isSystemApp,
      this.profile, this.serialNumber);

  /// Factory constructor for creating an instance of AppInfo from dynamic data.
  factory AppInfo.create(dynamic data) {
    return AppInfo(
      data["name"],
      data["icon"],
      data["package_name"],
      data["is_system_app"],
      _getProfileTypeFromString(data["profile"]),
      data["serial_number"],
    );
  }

  /// Method for comparing this AppInfo instance with another based on name.
  int compareTo(AppInfo other) {
    return name.compareTo(other.name);
  }

  /// Method for converting this AppInfo instance to a string.
  @override
  String toString() {
    return "AppInfo{name=$name, packageName=$packageName, isSystemApp=$isSystemApp, profile=$profile, serialNumber=$serialNumber";
  }

  static ProfileType _getProfileTypeFromString(String profileType) {
    switch (profileType) {
      case 'PERSONAL':
        return ProfileType.personal;
      case 'WORK':
        return ProfileType.work;
      default:
        throw ArgumentError('Unsupported ProfileType value: $profileType');
    }
  }
}
