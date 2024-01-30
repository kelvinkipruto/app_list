package dev.kipruto.apps_list

import android.content.pm.ApplicationInfo
import android.content.pm.LauncherActivityInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Process
import java.io.ByteArrayOutputStream

class AppInfo(
    private var name: String?,
    private val packageName: String,
    private val icon: ByteArray,
    private val isSystemApp: Boolean,
    private val profile: String,
) {

    init {
        this.name = name ?: packageName.split(".").last()
    }

    fun toMap(): Map<String, Any?> =
        mapOf(
            "name" to name,
            "package_name" to packageName,
            "icon" to icon,
            "is_system_app" to isSystemApp,
            "profile" to profile
        )

    companion object {
        fun fromPackageInfo(
            appInfo: ApplicationInfo,
            packageManager: PackageManager,
            app: LauncherActivityInfo
        ): AppInfo {
            val isMainProfile = app.user == Process.myUserHandle()
            val userProfile = if (isMainProfile) "personal" else "work"
            val icon =
                packageManager.getUserBadgedIcon(
                    appInfo.loadIcon(packageManager),
                    app.user
                )
            val drawableBytes = drawableToByteArray(icon)
            val isSystemApp = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0

            return AppInfo(
                app.label?.toString(),
                appInfo.packageName,
                drawableBytes,
                isSystemApp,
                userProfile
            )
        }

        private fun drawableToByteArray(drawable: Drawable): ByteArray {
            val bitmap = drawableToBitmap(drawable)
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            return stream.toByteArray()
        }

        private fun drawableToBitmap(drawable: Drawable): Bitmap {
            val bitmap =
                Bitmap.createBitmap(
                    drawable.intrinsicWidth,
                    drawable.intrinsicHeight,
                    Bitmap.Config.ARGB_8888
                )
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            return bitmap
        }
    }
}
