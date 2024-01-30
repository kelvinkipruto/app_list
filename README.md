# Apps List Plugin 

Flutter plugin to allow yo to query launchable android apps. It supports getting work profile apps

## Usage
Get launchable apps
```dart
 List<AppInfoByProfile> apps = AppsList.getInstalledApps()
```

Launch an app

```dart
await AppsList..launchApp(application.packageName, application.serialNumber);
```

