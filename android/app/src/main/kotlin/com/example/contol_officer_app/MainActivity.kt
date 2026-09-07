package com.contol.roapp

import android.app.DownloadManager
import android.content.BroadcastReceiver
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
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.contol.incineration/media_scanner"
    private var methodChannel: MethodChannel? = null

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

    private fun saveFileToDownloads(fileName: String, bytes: ByteArray): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
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
            file.absolutePath
        }
    }
}