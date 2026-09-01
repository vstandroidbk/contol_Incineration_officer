class CategoryItemModel {
  final String categoryId;
  final String categoryTitle;
  final String categoryNumber;
  final int memberCount;

  CategoryItemModel({
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryNumber,
    required this.memberCount,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      categoryId: json['categoryId'] ?? '',
      categoryTitle: json['categoryTitle'] ?? '',
      categoryNumber: json['categoryNumber'] ?? '',
      memberCount: json['memberCount'] ?? 0,
    );
  }
}

class CategorySummaryModel {
  final String regionalOfficerId;
  final String regionalOfficerName;
  final int memberCount;
  final int categoryCount;
  final List<CategoryItemModel> categories;

  CategorySummaryModel({
    required this.regionalOfficerId,
    required this.regionalOfficerName,
    required this.memberCount,
    required this.categoryCount,
    required this.categories,
  });

  factory CategorySummaryModel.fromJson(Map<String, dynamic> json) {
    return CategorySummaryModel(
      regionalOfficerId: json['regionalOfficerId'] ?? '',
      regionalOfficerName: json['regionalOfficerName'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      categoryCount: json['categoryCount'] ?? 0,
      categories: json['categories'] != null
          ? List<CategoryItemModel>.from(
              (json['categories'] as List).map(
                (e) => CategoryItemModel.fromJson(e),
              ),
            )
          : <CategoryItemModel>[],
    );
  }
}