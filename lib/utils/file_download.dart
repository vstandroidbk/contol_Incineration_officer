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

  // Prevents duplicate downloads if the user taps the button multiple times
  // while a download is already in progress.
  static bool _isDownloading = false;

  /// NOTE: No longer needed since we don't use native DownloadManager on
  /// Android anymore, but left here (harmless no-op) in case anything
  /// else still calls it at app startup.
  static void initDownloadListener() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDownloadComplete') {
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final success = args['success'] as bool;
        if (success) {
          print('✅ Native DownloadManager: download completed successfully');
        } else {
          final reason = args['reason'];
          print('❌ Native DownloadManager: FAILED — reason code: $reason');
        }
      }
    });
  }

  /// Download a file (PDF/image) and save it to the device.
  /// Android: fetched via Dart http + saved through MediaStore (fast, reliable).
  /// iOS: fetched via Dart http + saved to app Documents directory.
  static Future<bool> downloadFile({
    required BuildContext context,
    required String fileUrl,
    String? customFileName,
    bool openAfterDownload = true,
    String? displayName,
  }) async {
    if (_isDownloading) {
      // A download is already in progress — ignore duplicate taps.
      return false;
    }

    _isDownloading = true;
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
        return await _downloadAndroidViaDart(
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
    } finally {
      _isDownloading = false;
    }
  }

  // ---------------------------------------------------------------------------
  // 🤖 ANDROID — Dart http fetch + MediaStore save (bypasses native
  // DownloadManager, which was unreliable / very slow on some devices due to
  // OEM battery optimization / Doze throttling of the system download service).
  // ---------------------------------------------------------------------------
  static Future<bool> _downloadAndroidViaDart({
    required BuildContext context,
    required String url,
    required String fileName,
    String? displayName,
  }) async {
    bool dialogShown = false;
    try {
      _showLoadingDialog(context);
      dialogShown = true;

      print('🔗 DOWNLOAD URL (dart, android via http): "$url"');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        if (dialogShown && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        AppSnackBar.error(
          context: context,
          message: 'Failed to download file (${response.statusCode})',
        );
        return false;
      }

      final filePath = await _channel.invokeMethod<String>('saveToDownloads', {
        'fileName': fileName,
        'bytes': response.bodyBytes,
      });

      if (dialogShown && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (filePath == null) {
        AppSnackBar.error(context: context, message: 'Failed to save file');
        return false;
      }

      print('✅ File saved to Downloads: $filePath');
      AppSnackBar.success(
        context: context,
        message: '${displayName ?? 'File'} saved to Downloads',
      );
      return true;
    } catch (e) {
      if (dialogShown && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      AppSnackBar.error(
        context: context,
        message: 'Download failed: ${e.toString()}',
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

      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode != 200) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        AppSnackBar.error(context: context, message: 'Failed to download file');
        return false;
      }

      final filePath = await _saveFileIOS(fileName, response.bodyBytes);

      if (filePath == null) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        AppSnackBar.error(context: context, message: 'Failed to save file');
        return false;
      }

      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
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
