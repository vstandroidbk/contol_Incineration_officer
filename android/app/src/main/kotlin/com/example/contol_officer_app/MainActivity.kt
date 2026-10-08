package com.contol.roapp

import android.content.BroadcastReceiver
import android.app.DownloadManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.database.Cursor
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.contol.incineration/media_scanner"
    private var methodChannel: MethodChannel? = null

    // 🆕 Notification setup
    private val DOWNLOAD_CHANNEL_ID = "contol_downloads"
    private val DOWNLOAD_NOTIF_ID = 1001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        methodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {

                "startDownload" -> {

                    val url         = call.argument<String>("url")
                     println("🔗 DOWNLOAD URL (kotlin): \"$url\"")
                    val fileName    = call.argument<String>("fileName") ?: "certificate.pdf"
                    val title       = call.argument<String>("title") ?: fileName
                    val description = call.argument<String>("description") ?: "Downloading..."
                    val mimeType    = call.argument<String>("mimeType") ?: "application/pdf"

                    if (url == null) {
                        result.error("INVALID_ARGS", "url is null", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val request = DownloadManager.Request(Uri.parse(url)).apply {
                            setTitle(title)
                            setDescription(description)
                            setMimeType(mimeType)
                            setNotificationVisibility(
                                DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED
                            )
                            setDestinationInExternalPublicDir(
                                Environment.DIRECTORY_DOWNLOADS,
                                fileName
                            )
                            setAllowedOverMetered(true)
                            setAllowedOverRoaming(false)
                        }

                        val dm = getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
                        val downloadId = dm.enqueue(request)

                        println("✅ DownloadManager enqueued. ID: $downloadId")
                        registerDownloadCompleteReceiver(downloadId)

                        result.success(downloadId)
                    } catch (e: Exception) {
                        e.printStackTrace()
                        result.error("DOWNLOAD_FAILED", e.message, null)
                    }
                }

                "saveToDownloads" -> {
                    val fileName = call.argument<String>("fileName")
                    val bytes = call.argument<ByteArray>("bytes")

                    if (fileName != null && bytes != null) {
                        try {
                            val filePath = saveFileToDownloads(fileName, bytes)
                            result.success(filePath)
                        } catch (e: Exception) {
                            e.printStackTrace()
                            result.error("SAVE_ERROR", e.message, null)
                        }
                    } else {
                        result.error("INVALID_ARGS", "Missing fileName or bytes", null)
                    }
                }

                "scanFile" -> {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        MediaScannerConnection.scanFile(
                            applicationContext,
                            arrayOf(path),
                            arrayOf("application/pdf")
                        ) { scannedPath, uri ->
                            println("✅ Media scan complete: $scannedPath → $uri")
                            result.success(scannedPath)
                        }
                    } else {
                        result.error("INVALID_PATH", "File path is null", null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    // 🆕 Reports the real success/fail reason back to Flutter after DownloadManager finishes
    private fun registerDownloadCompleteReceiver(downloadId: Long) {
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val id = intent.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1)
                if (id != downloadId) return

                val dm = getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
                val query = DownloadManager.Query().setFilterById(downloadId)
                val cursor: Cursor = dm.query(query)

                if (cursor.moveToFirst()) {
                    val statusIndex = cursor.getColumnIndex(DownloadManager.COLUMN_STATUS)
                    val reasonIndex = cursor.getColumnIndex(DownloadManager.COLUMN_REASON)
                    val status = cursor.getInt(statusIndex)
                    val reason = cursor.getInt(reasonIndex)

                    when (status) {
                        DownloadManager.STATUS_SUCCESSFUL -> {
                            println("✅ Download $downloadId completed successfully")
                            methodChannel?.invokeMethod(
                                "onDownloadComplete",
                                mapOf("success" to true, "downloadId" to downloadId)
                            )
                        }
                        DownloadManager.STATUS_FAILED -> {
                            println("❌ Download $downloadId FAILED — reason code: $reason")
                            methodChannel?.invokeMethod(
                                "onDownloadComplete",
                                mapOf(
                                    "success" to false,
                                    "downloadId" to downloadId,
                                    "reason" to reason
                                )
                            )
                        }
                    }
                }
                cursor.close()

                try {
                    unregisterReceiver(this)
                } catch (_: Exception) {
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(
                receiver,
                IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE),
                Context.RECEIVER_EXPORTED
            )
        } else {
            registerReceiver(receiver, IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE))
        }
    }

    // 🆕 Creates the notification channel (required on Android 8.0 / API 26+).
    // IMPORTANCE_LOW = no sound/heads-up popup, just sits quietly in the shade —
    // matches typical "file download" notification behavior.
    private fun ensureDownloadNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                DOWNLOAD_CHANNEL_ID,
                "Downloads",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Shows file download progress and completion"
            }
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.createNotificationChannel(channel)
        }
    }

    // 🆕 Ongoing "Downloading..." notification with an indeterminate progress bar.
    // Posted right before we start writing bytes in saveFileToDownloads().
    private fun showDownloadingNotification(fileName: String) {
        ensureDownloadNotificationChannel()

        val builder = NotificationCompat.Builder(applicationContext, DOWNLOAD_CHANNEL_ID)
            .setSmallIcon(android.R.drawable.stat_sys_download)
            .setContentTitle("Downloading")
            .setContentText(fileName)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setProgress(0, 0, true) // indeterminate spinner-style bar
            .setPriority(NotificationCompat.PRIORITY_LOW)

        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(DOWNLOAD_NOTIF_ID, builder.build())
    }

    // 🆕 Replaces the ongoing notification with a tappable "Download complete" one.
    // Tapping it opens the saved PDF via the MediaStore content Uri.
    private fun showDownloadCompleteNotification(fileName: String, fileUri: Uri) {
        val openIntent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(fileUri, "application/pdf")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        val pendingIntent = PendingIntent.getActivity(
            applicationContext,
            0,
            openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = NotificationCompat.Builder(applicationContext, DOWNLOAD_CHANNEL_ID)
            .setSmallIcon(android.R.drawable.stat_sys_download_done)
            .setContentTitle("Download complete")
            .setContentText(fileName)
            .setOngoing(false)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_LOW)

        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(DOWNLOAD_NOTIF_ID, builder.build())
    }

    // 🆕 Cancels/clears the notification if the save fails, instead of leaving
    // a stuck "Downloading..." notification in the shade forever.
    private fun showDownloadFailedNotification(fileName: String) {
        val builder = NotificationCompat.Builder(applicationContext, DOWNLOAD_CHANNEL_ID)
            .setSmallIcon(android.R.drawable.stat_sys_warning)
            .setContentTitle("Download failed")
            .setContentText(fileName)
            .setOngoing(false)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)

        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(DOWNLOAD_NOTIF_ID, builder.build())
    }

    private fun saveFileToDownloads(fileName: String, bytes: ByteArray): String {
        // 🆕 Show "Downloading..." notification before writing anything
        showDownloadingNotification(fileName)

        try {
            val result = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val contentValues = ContentValues().apply {
                    put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                    put(MediaStore.MediaColumns.MIME_TYPE, "application/pdf")
                    put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                }

                val resolver = applicationContext.contentResolver
                val uri: Uri? = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)

                uri?.let {
                    val outputStream: OutputStream? = resolver.openOutputStream(it)
                    outputStream?.use { stream ->
                        stream.write(bytes)
                        stream.flush()
                    }
                    println("✅ File saved via MediaStore: $it")

                    // 🆕 Success notification, tappable, opens the PDF
                    showDownloadCompleteNotification(fileName, it)

                    it.toString()
                } ?: throw Exception("Failed to create MediaStore entry")
            } else {
                val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                if (!downloadsDir.exists()) {
                    downloadsDir.mkdirs()
                }

                val file = java.io.File(downloadsDir, fileName)
                file.writeBytes(bytes)

                MediaScannerConnection.scanFile(
                    applicationContext,
                    arrayOf(file.absolutePath),
                    arrayOf("application/pdf"),
                    null
                )

                println("✅ File saved (legacy): ${file.absolutePath}")

                // 🆕 Success notification (legacy path uses a file:// Uri)
                showDownloadCompleteNotification(fileName, Uri.fromFile(file))

                file.absolutePath
            }

            return result
        } catch (e: Exception) {
            // 🆕 Replace "Downloading..." with a failure notification instead of
            // leaving it stuck, then rethrow so the Dart side still sees the error.
            showDownloadFailedNotification(fileName)
            throw e
        }
    }
}