package dev.kipruto.apps_list


import android.content.Context
import android.content.Intent
import android.content.pm.LauncherActivityInfo
import android.content.pm.LauncherApps
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Process
import android.os.UserHandle
import android.os.UserManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** AppsListPlugin */
class AppsListPlugin: FlutterPlugin, MethodCallHandler {
//  private val CHANNEL = "dev.kipruto.apps_list/apps_list"
  private lateinit var launcherApps: LauncherApps
  private lateinit var userManager: UserManager
  private lateinit var packageManager: PackageManager
    private lateinit var context: Context
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "apps_list")
    channel.setMethodCallHandler(this)
    launcherApps = flutterPluginBinding.applicationContext.getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps
    userManager = flutterPluginBinding.applicationContext.getSystemService(Context.USER_SERVICE) as UserManager
    packageManager = flutterPluginBinding.applicationContext.packageManager
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "launchApp" -> {
        val packageName = call.argument<String>("packageName")
        val serialNumber = call.argument<Int>("serialNumber")

        launchApp(packageName!!, serialNumber?.toLong())
        result.success(null)
      }
      "getInstalledApps" -> result.success(getInstalledApps())
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      else -> result.notImplemented()
    }
  }

  private fun getInstalledApps(): List<Map<String,Any?>>{
    val packageNames = mutableSetOf<String>()

    return launcherApps
      .profiles
      .flatMap { profile ->
        launcherApps.getActivityList(null, profile).mapNotNull { app ->
          if (packageNames.add(app.applicationInfo.packageName)) {
            getApplications(app.applicationInfo.packageName)
          } else {
            null
          }
        }
      }
      .flatten()
      .sortedBy { it["name"] as? String }
  }

  private fun launchApp(packageName: String, serialNumber: Long? = null) {
    val userHandle = serialNumber?.let { userManager.getUserForSerialNumber(it) }
    val intent = packageManager.getLaunchIntentForPackage(packageName)
    intent?.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
    val bundle = Bundle().apply { putParcelable(Intent.EXTRA_USER, userHandle) }
    launcherApps.startMainActivity(intent?.component, userHandle, null, bundle)
  }


  private fun getApplications(packageName: String): List<Map<String, Any?>> {
    if (packageName == context.packageName) return emptyList()
    return launcherApps.profiles.flatMap { profile ->
      println("Getting apps for profile: $profile for package: $packageName")
      try {
        if (launcherApps.getApplicationInfo(packageName, 0, profile) != null) {
          launcherApps.getActivityList(packageName, profile)?.mapNotNull {
              launcherActivityInfo ->
            try {
              getApplication(launcherActivityInfo, profile)
            } catch (e: PackageManager.NameNotFoundException) {
              println("Package ERROR:: $e")
              println("Package not found: $packageName for profile: $profile")
              null // Skip the application if not found in the current profile
            }
          }
            ?: emptyList()
        } else {
          println("Package not installed: $packageName for profile: $profile")
          emptyList()
        }
      } catch (e: Exception) {
        println("Exception ERROR:: $e")
        emptyList()
      }
    }
  }

  private fun getApplication(
    launcherActivityInfo: LauncherActivityInfo,
    profile: UserHandle
  ): Map<String, Any?>? {
    println("Getting application ${launcherActivityInfo.label} for profile: $profile")
    if (launcherActivityInfo.applicationInfo.packageName == context.packageName &&
      !context.packageName.endsWith(".debug")
    )
      return null

    val info =
      launcherApps.getApplicationInfo(
        launcherActivityInfo.applicationInfo.packageName,
        PackageManager.GET_META_DATA,
        profile
      )
    println("Application info: $info")

    val appDetails = AppInfo.fromPackageInfo(info, packageManager, launcherActivityInfo).toMap()

    println("Application details: $appDetails")
    return appDetails
      .toMutableMap()
      .apply { this["serial_number"] = profile.getSerialNumber(context) }
      .toMap()
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

fun UserHandle.getSerialNumber(context: Context): Long {
  if (this == Process.myUserHandle()) return 0L
  val userManager = context.getSystemService(Context.USER_SERVICE) as UserManager
  return userManager.getSerialNumberForUser(this)
}
