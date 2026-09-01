class AllOfficerMemberModel {
  final String industryName;
  final String pinCode;
  final String membershipUserId; // display id, e.g. "CONTEP0697"
  final String membershipId;     // UUID (memberId) used for other APIs
  final String? plantAddress;    // 👈 NEW
  final String? validFrom;
  final String? validTill;
  final String? profile;
  final bool isActive;
  final String? updatedAt;

  AllOfficerMemberModel({
    required this.industryName,
    required this.pinCode,
    required this.membershipUserId,
    required this.membershipId,
    this.plantAddress,
    this.validFrom,
    this.validTill,
    this.profile,
    required this.isActive,
    this.updatedAt,
  });

  factory AllOfficerMemberModel.fromJson(Map<String, dynamic> json) {
    return AllOfficerMemberModel(
      industryName: json['industryName'] ?? '',
      pinCode: json['pinCode'] ?? '',
      membershipUserId: json['membershipUserId'] ?? '',
      membershipId: json['membershipId'] ?? '',
      plantAddress: json['plantAddress'],
      validFrom: json['validFrom'],
      validTill: json['validTill'],
      profile: json['profile'],
      isActive: json['isActive'] ?? false,
      updatedAt: json['updatedAt'],
    );
  }
}

class AllOfficerMembersResponseModel {
  final int memberCount;
  final int pincodeCount;
  final List<AllOfficerMemberModel> members;

  AllOfficerMembersResponseModel({
    required this.memberCount,
    required this.pincodeCount,
    required this.members,
  });

  factory AllOfficerMembersResponseModel.fromJson(Map<String, dynamic> json) {
    return AllOfficerMembersResponseModel(
      memberCount: json['memberCount'] ?? 0,
      pincodeCount: json['pincodeCount'] ?? 0,
      members: json['members'] != null
          ? List<AllOfficerMemberModel>.from(
              (json['members'] as List).map(
                (e) => AllOfficerMemberModel.fromJson(e),
              ),
            )
          : <AllOfficerMemberModel>[],
    );
  }
}

// 👇 NEW — add these classes for view-member-waste-category
class MemberWasteCategoryItemModel {
  final String categoryId;
  final String categoryTitle;
  final String categoryNumber;
  final int totalAllocated;
  final int totalUsed;
  final int remaining;
  final String allocatedQuantityType;
  final String usedQuantityType;
  final String remainingQuantityType;

  MemberWasteCategoryItemModel({
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

  factory MemberWasteCategoryItemModel.fromJson(Map<String, dynamic> json) {
    return MemberWasteCategoryItemModel(
      categoryId: json['categoryId'] ?? '',
      categoryTitle: json['categoryTitle'] ?? '',
      categoryNumber: json['categoryNumber'] ?? '',
      totalAllocated: json['totalAllocated'] ?? 0,
      totalUsed: json['totalUsed'] ?? 0,
      remaining: json['remaining'] ?? 0,
      allocatedQuantityType: json['allocatedQuantityType'] ?? '',
      usedQuantityType: json['usedQuantityType'] ?? '',
      remainingQuantityType: json['remainingQuantityType'] ?? '',
    );
  }
}

class MemberWasteCategoryDetailModel {
  final String memberId;
  final String regionalOfficerId;
  final String memberUserId;
  final String industryName;
  final String plantAddress;
  final String? memberValidFrom;
  final String? memberTillDate;
  final int memberActiveStatus;
  final String? profile;
  final int year;
  final String? yearStart;
  final String? yearEnd;
  final String? quarter;
  final List<MemberWasteCategoryItemModel> response;

  MemberWasteCategoryDetailModel({
    required this.memberId,
    required this.regionalOfficerId,
    required this.memberUserId,
    required this.industryName,
    required this.plantAddress,
    this.memberValidFrom,
    this.memberTillDate,
    required this.memberActiveStatus,
    this.profile,
    required this.year,
    this.yearStart,
    this.yearEnd,
    this.quarter,
    required this.response,
  });

  factory MemberWasteCategoryDetailModel.fromJson(Map<String, dynamic> json) {
    return MemberWasteCategoryDetailModel(
      memberId: json['memberId'] ?? '',
      regionalOfficerId: json['regionalOfficerId'] ?? '',
      memberUserId: json['memberUserId'] ?? '',
      industryName: json['industryName'] ?? '',
      plantAddress: json['plantAddress'] ?? '',
      memberValidFrom: json['memberValidFrom'],
      memberTillDate: json['memberTillDate'],
      memberActiveStatus: json['memberActiveStatus'] ?? 0,
      profile: json['profile'],
      year: json['year'] ?? 0,
      yearStart: json['yearStart'],
      yearEnd: json['yearEnd'],
      quarter: json['quarter'],
      response: json['response'] != null
          ? List<MemberWasteCategoryItemModel>.from(
              (json['response'] as List).map(
                (e) => MemberWasteCategoryItemModel.fromJson(e),
              ),
            )
          : <MemberWasteCategoryItemModel>[],
    );
  }
}