class OfficerProfileModel {
  final String fullName;
  final String email;
  final String loginId;
  final String? profile;
  final String? joiningDate;
  final String mobileNumber;
  final String districtName;
  final List<String> pinCodes;
  final int memberCount;

  OfficerProfileModel({
    required this.fullName,
    required this.email,
    required this.loginId,
    this.profile,
    this.joiningDate,
    required this.mobileNumber,
    required this.districtName,
    required this.pinCodes,
    required this.memberCount,
  });

  factory OfficerProfileModel.fromJson(Map<String, dynamic> json) {
    return OfficerProfileModel(
      fullName: json['FullName'] ?? '',
      email: json['Email'] ?? '',
      loginId: json['loginId'] ?? '',
      profile: json['profile'],
      joiningDate: json['joiningDate'],
      mobileNumber: json['mobileNumber'] ?? '',
      districtName: json['districtName'] ?? '',
      pinCodes: json['pinCodes'] != null
          ? List<String>.from(json['pinCodes'])
          : <String>[],
      memberCount: json['memberCount'] ?? 0,
    );
  }

  // 👇 Add this
  OfficerProfileModel copyWith({
    String? fullName,
    String? email,
    String? loginId,
    String? profile,
    String? joiningDate,
    String? mobileNumber,
    String? districtName,
    List<String>? pinCodes,
    int? memberCount,
  }) {
    return OfficerProfileModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      loginId: loginId ?? this.loginId,
      profile: profile ?? this.profile,
      joiningDate: joiningDate ?? this.joiningDate,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      districtName: districtName ?? this.districtName,
      pinCodes: pinCodes ?? this.pinCodes,
      memberCount: memberCount ?? this.memberCount,
    );
  }
}