import 'dart:io';
import 'package:contol_officer_app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileDownloadHelper {
  static String _getMimeType(String url) {
    final lower = url.toLowerCase();

    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return 'image/jpeg';
    }

    return 'application/octet-stream';
  }

  static const MethodChannel _channel = MethodChannel(
    'com.contol.incineration/media_scanner',
  );

  /// Download PDF — uses Android DownloadManager (shows native notification)
  static Future<bool> downloadFile({
    required BuildContext context,
    required String fileUrl,
    String? customFileName,
    bool openAfterDownload = true,
    String? displayName,
  }) async {
    try {
      if (!await _requestStoragePermission(context)) {
        AppSnackBar.error(
          context: context,
          message: 'Storage permission denied',
        );
        return false;
      }

      final fileName = customFileName ?? _generateFileName(fileUrl);

      if (Platform.isAndroid) {
        return await _startAndroidDownloadManager(
          context: context,
          url: fileUrl,
          fileName: fileName,
          displayName: displayName,
        );
      } else if (Platform.isIOS) {
        return await _downloadIOS(
          context: context,
          fileUrl: fileUrl,
          fileName: fileName,
        );
      }

      return false;
    } catch (e) {
      AppSnackBar.error(
        context: context,
        message: 'Download failed: ${e.toString()}',
      );
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 🤖 ANDROID — DownloadManager (native notification + Files app integration)
  // ---------------------------------------------------------------------------
  static Future<bool> _startAndroidDownloadManager({
    required BuildContext context,
    required String url,
    required String fileName,
    String? displayName,
  }) async {
    try {
      await _channel.invokeMethod('startDownload', {
        'url': url,
        'fileName': fileName,
        'title': fileName,
        'description': 'Downloading...',
        'mimeType': _getMimeType(url),
      });

      AppSnackBar.success(
        context: context,
        message: '${displayName ?? 'File'} Downloading...',
      );

      return true;
    } on PlatformException catch (e) {
      AppSnackBar.error(
        context: context,
        message: 'Download failed: ${e.message}',
      );
      return false;
    }
  }

  static Future<bool> _downloadIOS({
    required BuildContext context,
    required String fileUrl,
    required String fileName,
  }) async {
    try {
      _showLoadingDialog(context);

      // ignore: deprecated_member_use
      final response = await (http.get(Uri.parse(fileUrl)));

      if (response.statusCode != 200) {
        Navigator.of(context).pop();
        AppSnackBar.error(context: context, message: 'Failed to download file');
        return false;
      }

      final filePath = await _saveFileIOS(fileName, response.bodyBytes);

      if (filePath == null) {
        Navigator.of(context).pop();
        AppSnackBar.error(context: context, message: 'Failed to save file');
        return false;
      }

      Navigator.of(context).pop();
      AppSnackBar.success(context: context, message: 'File saved to Documents');
      return true;
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      AppSnackBar.error(
        context: context,
        message: 'Download failed: ${e.toString()}',
      );
      return false;
    }
  }

  static Future<String?> _saveFileIOS(String fileName, List<int> bytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      print('✅ File saved (iOS): $filePath');
      return filePath;
    } catch (e) {
      print('❌ iOS save error: $e');
      return null;
    }
  }

  static Future<bool> _requestStoragePermission(BuildContext context) async {
    if (!Platform.isAndroid) return true;
    // Android 10+ doesn't need storage permission
    return true;
  }

  static String _generateFileName(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.last;
      }
    } catch (e) {
      print('⚠️ URL parse error: $e');
    }

    return 'file_${DateTime.now().millisecondsSinceEpoch}';
  }

  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const Dialog(
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Downloading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
