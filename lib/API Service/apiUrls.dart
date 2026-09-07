class ApiUrls {
  //static const String localUrl = "http://192.168.0.14:3004/";
  static const String liveUrl = "https://devincineration.contol.in";
  static const String envType = "dev";

  //Authentication
  static const String login = '/officer/login';
  static const String forgotpswrd = '/officer/send-otp';
  static const String verifyOTP = '/officer/verify-otp';
  static const String resetPswrd = '/officer/reset-password';

  static const String updatePassword = "/officer/update-password";

  //Profile
  static const String getOfficerProfile = '/officer/get-officer-profile';
  static const String uploadProfile = '/officer/upload-profile';
  static const String editOfficerProfile =
      '/officer/edit-regional-officer-profile';

  //home
  static const String getOfficerMembersByPincode =
      '/officer/get-officer-members-by-pinCode';

  static const String getOfficerMembersByCategory =
      "/officer/get-officer-members-by-category";

  //customer
  static const String getOfficerMembers = "/officer/get-officer-members";

  static const String getOfficerCategorySummary =
      "/officer/get-officer-category-summary";

  static const String getMembershipYears = "/officer/get-membership-years";

  static const String viewMemberWasteCategory =
      "/officer/view-member-waste-category";

  static const String viewWasteCategory = '/officer/view-waste-category';

  static const String generateMemberWasteReport =
      "/officer/generate-member-waste-report";

  //notification
  static const String getOfficerNotifications =
      "/officer/get-Officer-notifications";

  static const String readAllOfficerNotifications =
      '/officer/read-all-ro-notification';

  static const String deleteOfficerNotification =
      '/officer/delete-ro-notification';
}
