class WasteCategoryReportModel {
  final String year;
  final String quarter;
  final List<WasteCategoryReportItem> response;

  WasteCategoryReportModel({
    required this.year,
    required this.quarter,
    required this.response,
  });

  factory WasteCategoryReportModel.fromJson(Map<String, dynamic> json) {
    return WasteCategoryReportModel(
      year: json['year']?.toString() ?? 'ALL',
      quarter: json['quarter']?.toString() ?? 'ALL',
      response: (json['response'] as List<dynamic>? ?? [])
          .map(
            (e) => WasteCategoryReportItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class WasteCategoryReportItem {
  final String categoryId;
  final String categoryTitle;
  final String categoryNumber;
  final double totalAllocated; // 👈 changed int → double
  final double totalUsed; // 👈 changed int → double
  final double remaining; // 👈 changed int → double
  final String allocatedQuantityType;
  final String usedQuantityType;
  final String remainingQuantityType;

  WasteCategoryReportItem({
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryNumber,
    required this.totalAllocated,
    required this.totalUsed,
    required this.remaining,
    required this.allocatedQuantityType,
    required this.usedQuantityType,
    required this.remainingQuantityType,
  });

  // 👇 add — safely handles int, double, or numeric string from backend
  static double _parseNum(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  factory WasteCategoryReportItem.fromJson(Map<String, dynamic> json) {
    return WasteCategoryReportItem(
      categoryId: json['categoryId']?.toString() ?? '',
      categoryTitle: json['categoryTitle']?.toString() ?? '',
      categoryNumber: json['categoryNumber']?.toString() ?? '',
      totalAllocated: _parseNum(json['totalAllocated']),
      totalUsed: _parseNum(json['totalUsed']),
      remaining: _parseNum(json['remaining']),
      allocatedQuantityType: json['allocatedQuantityType']?.toString() ?? '',
      usedQuantityType: json['usedQuantityType']?.toString() ?? '',
      remainingQuantityType: json['remainingQuantityType']?.toString() ?? '',
    );
  }
}

// lib/model/wasteReportGenerateModel.dart
class WasteReportGenerateModel {
  final String pdfFileName;
  final String pdfUrl;
  final int memberCount;
  final String year;
  final String quarter;

  WasteReportGenerateModel({
    required this.pdfFileName,
    required this.pdfUrl,
    required this.memberCount,
    required this.year,
    required this.quarter,
  });

  factory WasteReportGenerateModel.fromJson(Map<String, dynamic> json) {
    return WasteReportGenerateModel(
      pdfFileName: json['pdfFileName']?.toString() ?? '',
      pdfUrl: json['pdfUrl']?.toString() ?? '',
      memberCount: (json['memberCount'] ?? 0) is int
          ? json['memberCount'] as int
          : int.tryParse(json['memberCount'].toString()) ?? 0,
      year: json['year']?.toString() ?? 'ALL',
      quarter: json['quarter']?.toString() ?? 'ALL',
    );
  }
}
