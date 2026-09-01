package com.example.contol_officer_app

import android.app.DownloadManager
import android.content.ContentValues
import android.content.Context
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

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                // ✅ NEW: Android DownloadManager — shows native progress + complete notification
                "startDownload" -> {
                    val url         = call.argument<String>("url")
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
                            // Shows progress during download + "complete" notification when done
                            setNotificationVisibility(
                                DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED
                            )
                            // Save to public Downloads folder (visible in Files app)
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
                        result.success(downloadId)
                    } catch (e: Exception) {
                        e.printStackTrace()
                        result.error("DOWNLOAD_FAILED", e.message, null)
                    }
                }

                // ✅ EXISTING: kept as-is
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

                // ✅ EXISTING: kept as-is
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

    private fun saveFileToDownloads(fileName: String, bytes: ByteArray): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            // Android 10+ - Use MediaStore
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
            // Android 9 and below - Direct file access
            val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            if (!downloadsDir.exists()) {
                downloadsDir.mkdirs()
            }

            val file = java.io.File(downloadsDir, fileName)
            file.writeBytes(bytes)

            // Trigger media scan
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