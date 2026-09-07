class OfficerMemberModel {
  final String industryName;
  final String pinCode;
  final String membershipId;
  final String membershipUserId;
  final String? validFrom;
  final String? validTill;
  final bool isActive;
  final String? profile;
  final String? plantAddress; // ✅ added

  OfficerMemberModel({
    required this.industryName,
    required this.pinCode,
    required this.membershipId,
    this.validFrom,
    this.validTill,
    required this.isActive,
    this.profile,
    this.plantAddress, // ✅ added
    this.membershipUserId = '',
  });

  factory OfficerMemberModel.fromJson(Map<String, dynamic> json) {
    return OfficerMemberModel(
      industryName: json['industryName'] ?? '',
      pinCode: json['pinCode'] ?? '',
      membershipId: json['membershipId'] ?? '',
      membershipUserId: json['membershipUserId'] ?? '',
      validFrom: json['validFrom'],
      validTill: json['validTill'],
      isActive: json['isActive'] ?? false,
      profile: json['profile'],
      plantAddress: json['plantAddress'], // ✅ added
      
    );
  }
}

class OfficerMembersResponseModel {
  final int memberCount;
  final List<OfficerMemberModel> members;

  OfficerMembersResponseModel({
    required this.memberCount,
    required this.members,
  });

  factory OfficerMembersResponseModel.fromJson(Map<String, dynamic> json) {
    return OfficerMembersResponseModel(
      memberCount: json['memberCount'] ?? 0,
      members: json['members'] != null
          ? List<OfficerMemberModel>.from(
              (json['members'] as List).map(
                (e) => OfficerMemberModel.fromJson(e),
              ),
            )
          : <OfficerMemberModel>[],
    );
  }
}

class MembershipYearsModel {
  final String memberId;
  final String? validFrom;
  final String? validTill;
  final List<String> years;
  final List<int> quarters;

  MembershipYearsModel({
    required this.memberId,
    this.validFrom,
    this.validTill,
    required this.years,
    required this.quarters,
  });

  factory MembershipYearsModel.fromJson(Map<String, dynamic> json) {
    return MembershipYearsModel(
      memberId: json['memberId'] ?? '',
      validFrom: json['validFrom'],
      validTill: json['validTill'],
      years: json['years'] != null
          ? List<String>.from(json['years'])
          : <String>[],
      quarters: json['quarters'] != null
          ? List<int>.from(json['quarters'])
          : <int>[],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 🔹 Category Members (get-officer-members-by-category response)
// ══════════════════════════════════════════════════════════════
class CategoryMemberModel {
  final String memberProfileId;
  final String membershipId;
  final String membershipUserId;
  final String industryName;
  final String pinCode;
  final String plantAddress;
  final String validFrom;
  final String validTill;
  final String? profile;
  final bool isActive;
  final String updatedAt;

  CategoryMemberModel({
    required this.memberProfileId,
    required this.membershipId,
    required this.membershipUserId,
    required this.industryName,
    required this.pinCode,
    required this.plantAddress,
    required this.validFrom,
    required this.validTill,
    this.profile,
    required this.isActive,
    required this.updatedAt,
  });

  factory CategoryMemberModel.fromJson(Map<String, dynamic> json) {
    return CategoryMemberModel(
      memberProfileId: json['memberProfileId'] ?? '',
      membershipId: json['membershipId'] ?? '',
      membershipUserId: json['membershipUserId'] ?? '',
      industryName: json['industryName'] ?? '',
      pinCode: json['pinCode'] ?? '',
      plantAddress: json['plantAddress'] ?? '',
      validFrom: json['validFrom'] ?? '',
      validTill: json['validTill'] ?? '',
      profile: json['profile'],
      isActive: json['isActive'] ?? false,
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class CategoryMembersResponseModel {
  final String categoryId;
  final int memberCount;
  final int pincodeCount;
  final List<CategoryMemberModel> members;

  CategoryMembersResponseModel({
    required this.categoryId,
    required this.memberCount,
    required this.pincodeCount,
    required this.members,
  });

  factory CategoryMembersResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryMembersResponseModel(
      categoryId: json['categoryId'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      pincodeCount: json['pincodeCount'] ?? 0,
      members: (json['members'] as List<dynamic>? ?? [])
          .map((m) => CategoryMemberModel.fromJson(m))
          .toList(),
    );
  }
}
