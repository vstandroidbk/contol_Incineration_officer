import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/file_download.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;
  final bool showDownload;

  const PdfViewScreen({
    super.key,
    required this.pdfUrl,
    this.title = "View Document",
    this.showDownload = true,
  });

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  PdfController? _pdfController; // single-page (high-res)
  PdfControllerPinch? _pdfControllerPinch; // multi-page

  final TransformationController _transformationController =
      TransformationController();

  double _currentScale = 1.0;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = true;
  bool _loadFailed = false;

  /// null = still detecting, true = 1 page, false = multi-page
  bool? _isSinglePage;

  @override
  void initState() {
    super.initState();
    _initPdfController();
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    _pdfControllerPinch?.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  // ============ INIT PDF CONTROLLER ============
  void _initPdfController() {
    if (widget.pdfUrl.isEmpty) {
      setState(() {
        _isLoading = false;
        _loadFailed = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _loadFailed = false;
      _isSinglePage = null;
      _currentPage = 1;
      _totalPages = 0;
      _currentScale = 1.0;
      _transformationController.value = Matrix4.identity();
    });

    _pdfController?.dispose();
    _pdfController = null;
    _pdfControllerPinch?.dispose();
    _pdfControllerPinch = null;

    _loadNetworkPdf(widget.pdfUrl);
  }

  /// Fetches bytes → checks page count → creates the right controller
  Future<void> _loadNetworkPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final bytes = response.bodyBytes;

      final tempDoc = await PdfDocument.openData(bytes);
      final pageCount = tempDoc.pagesCount;
      await tempDoc.close();

      if (!mounted) return;

      if (pageCount == 1) {
        _pdfController = PdfController(document: PdfDocument.openData(bytes));
        setState(() => _isSinglePage = true);
      } else {
        _pdfControllerPinch = PdfControllerPinch(
          document: PdfDocument.openData(bytes),
        );
        setState(() => _isSinglePage = false);
      }
    } catch (e) {
      debugPrint("❌ PDF load error: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadFailed = true;
        });
      }
    }
  }

  // ============ ZOOM ============
  void _zoomIn() {
    setState(() {
      _currentScale = (_currentScale + 0.25).clamp(1.0, 4.0);
      _transformationController.value = Matrix4.identity()
        ..scale(_currentScale);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentScale = (_currentScale - 0.25).clamp(1.0, 4.0);
      _transformationController.value = Matrix4.identity()
        ..scale(_currentScale);
    });
  }

  // ============ BUILD ============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Positioned.fill(child: _buildPdfViewer()),
          if (_isLoading) _buildLoadingOverlay(),
          if (!_isLoading && _totalPages > 1) _buildPageIndicator(),
        ],
      ),
    );
  }

  // ============ APP BAR ============
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (!_isLoading && _totalPages > 1)
            Text(
              '$_totalPages pages',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
      actions: [
        if (widget.showDownload)
          IconButton(
            icon: const Icon(LucideIcons.download, color: Colors.white),
            tooltip: 'Download',
            onPressed: () async {
              await FileDownloadHelper.downloadFile(
                context: context,
                fileUrl: widget.pdfUrl,
                openAfterDownload: false,
                displayName: widget.title,
              );
            },
          ),
        IconButton(
          icon: const Icon(LucideIcons.zoomIn, color: Colors.white),
          onPressed: _zoomIn,
          tooltip: 'Zoom In',
        ),
        IconButton(
          icon: const Icon(LucideIcons.zoomOut, color: Colors.white),
          onPressed: _zoomOut,
          tooltip: 'Zoom Out',
        ),
      ],
    );
  }

  // ============ PDF VIEWER ============
  Widget _buildPdfViewer() {
    if (_loadFailed) return _buildErrorWidget();
    if (_isSinglePage == null) return const SizedBox.shrink();

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 1.0,
      maxScale: 4.0,
      child: _isSinglePage! ? _buildSinglePageView() : _buildMultiPageView(),
    );
  }

  Widget _buildSinglePageView() {
    if (_pdfController == null) return _buildErrorWidget();

    return PdfView(
      controller: _pdfController!,
      scrollDirection: Axis.vertical,
      renderer: (PdfPage page) => page.render(
        width: page.width * 3,
        height: page.height * 3,
        format: PdfPageImageFormat.png,
        backgroundColor: '#ffffff',
      ),
      onDocumentLoaded: (doc) {
        if (mounted) {
          setState(() => _totalPages = doc.pagesCount);
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) setState(() => _isLoading = false);
          });
        }
      },
      onPageChanged: (page) {
        if (mounted) setState(() => _currentPage = page);
      },
      onDocumentError: (error) {
        debugPrint("❌ PDF Load Failed: $error");
        if (mounted) {
          setState(() {
            _isLoading = false;
            _loadFailed = true;
          });
        }
      },
    );
  }

  Widget _buildMultiPageView() {
    if (_pdfControllerPinch == null) return _buildErrorWidget();

    return PdfViewPinch(
      controller: _pdfControllerPinch!,
      scrollDirection: Axis.vertical,
      padding: 0,
      onDocumentLoaded: (doc) {
        if (mounted) {
          setState(() => _totalPages = doc.pagesCount);
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) setState(() => _isLoading = false);
          });
        }
      },
      onPageChanged: (page) {
        if (mounted) setState(() => _currentPage = page);
      },
      onDocumentError: (error) {
        debugPrint("❌ PDF Load Failed: $error");
        if (mounted) {
          setState(() {
            _isLoading = false;
            _loadFailed = true;
          });
        }
      },
    );
  }

  // ============ LOADING OVERLAY ============
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white.withOpacity(0.95),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading Document...',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ ERROR WIDGET ============
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.fileX, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'Failed to load PDF',
            style: TextStyle(color: Colors.grey[600], fontSize: 15),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _initPdfController,
            icon: const Icon(LucideIcons.refreshCw, size: 16),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ============ PAGE INDICATOR ============
  Widget _buildPageIndicator() {
    return Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Page $_currentPage of $_totalPages',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}