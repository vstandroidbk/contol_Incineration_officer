class OfficerMemberModel {
  final String industryName;
  final String pinCode;
  final String membershipId;
  final String? validFrom;
  final String? validTill;
  final bool isActive;
  final String? profile;

  OfficerMemberModel({
    required this.industryName,
    required this.pinCode,
    required this.membershipId,
    this.validFrom,
    this.validTill,
    required this.isActive,
    this.profile,
  });

  factory OfficerMemberModel.fromJson(Map<String, dynamic> json) {
    return OfficerMemberModel(
      industryName: json['industryName'] ?? '',
      pinCode: json['pinCode'] ?? '',
      membershipId: json['membershipId'] ?? '',
      validFrom: json['validFrom'],
      validTill: json['validTill'],
      isActive: json['isActive'] ?? false,
      profile: json['profile'],
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