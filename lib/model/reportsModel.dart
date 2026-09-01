class WasteCategoryReportModel {
  final String year; // API may send int(2026) or "ALL" — normalized to String
  final String quarter; // API may send "Q1" or "ALL"
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
          .map((e) => WasteCategoryReportItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WasteCategoryReportItem {
  final String categoryId;
  final String categoryTitle;
  final String categoryNumber;
  final int totalAllocated;
  final int totalUsed;
  final int remaining;
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

  factory WasteCategoryReportItem.fromJson(Map<String, dynamic> json) {
    return WasteCategoryReportItem(
      categoryId: json['categoryId'] ?? '',
      categoryTitle: json['categoryTitle'] ?? '',
      categoryNumber: json['categoryNumber'] ?? '',
      totalAllocated: (json['totalAllocated'] ?? 0) as int,
      totalUsed: (json['totalUsed'] ?? 0) as int,
      remaining: (json['remaining'] ?? 0) as int,
      allocatedQuantityType: json['allocatedQuantityType'] ?? '',
      usedQuantityType: json['usedQuantityType'] ?? '',
      remainingQuantityType: json['remainingQuantityType'] ?? '',
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