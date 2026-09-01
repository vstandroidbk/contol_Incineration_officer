import 'package:contol_officer_app/model/customermodel.dart';
import 'package:contol_officer_app/model/memberModel.dart';
import 'package:contol_officer_app/services/customerService.dart';
import 'package:get/get.dart';

class AllCustomersController extends GetxController {
  final AllMembersService _allMembersService = AllMembersService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var allMembers = <AllOfficerMemberModel>[].obs; // source of truth
  var members = <AllOfficerMemberModel>[].obs; // displayed (filtered)
  var pincodeCount = 0.obs;

  var isMembershipYearsLoading = false.obs;
  var membershipYearsError = ''.obs;

  var membershipYears = <String>[].obs;
  var membershipQuarters = <int>[].obs; // [1,2,3,4]

  var isCategoryDetailLoading = false.obs;
  var categoryDetailError = ''.obs;
  var memberCategoryDetail = Rxn<MemberWasteCategoryDetailModel>();
  var memberWasteCategories = <MemberWasteCategoryItemModel>[].obs;

 // customerController.dart — sirf search() method change

/// 🔹 Local search filter by Member Id or Company name
void search(String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) {
    members.assignAll(allMembers);
  } else {
    members.assignAll(
      allMembers.where(
        (m) =>
            m.membershipUserId.toLowerCase().contains(q) || // 👈 changed
            m.industryName.toLowerCase().contains(q),
      ),
    );
  }
}

  /// 🔹 Load years/quarters for a specific member — call before opening the filter sheet
  Future<void> fetchMembershipYears(String memberId) async {
    try {
      isMembershipYearsLoading.value = true;
      membershipYearsError.value = '';

      final res = await _allMembersService.getMembershipYears(
        memberId: memberId,
      );

      print("📅 MEMBERSHIP YEARS RESPONSE: $res");

      if (res["status"] == "SUCCESS" && res["data"] != null) {
        final data = MembershipYearsModel.fromJson(res["data"]);
        membershipYears.assignAll(data.years);
        membershipQuarters.assignAll(data.quarters);
      } else {
        membershipYears.clear();
        membershipQuarters.clear();
        membershipYearsError.value = res["message"] ?? "Something went wrong.";
      }
    } catch (e) {
      print("❌ MEMBERSHIP YEARS ERROR: $e");
      membershipYears.clear();
      membershipQuarters.clear();
      membershipYearsError.value = "Something went wrong. Please try again.";
    } finally {
      isMembershipYearsLoading.value = false;
    }
  }

  // 👇 add this getter inside AllCustomersController
  List<AllOfficerMemberModel> get recentMembers {
    final sorted = [...allMembers];
    sorted.sort((a, b) {
      final aDate = DateTime.tryParse(a.updatedAt ?? '') ?? DateTime(2000);
      final bDate = DateTime.tryParse(b.updatedAt ?? '') ?? DateTime(2000);
      return bDate.compareTo(aDate); // latest first
    });
    return sorted.take(5).toList();
  }

  Future<void> fetchAllMembers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await _allMembersService.getOfficerMembers();

      print("👥 ALL CUSTOMERS RESPONSE: $res");

      if (res["status"] == "SUCCESS" && res["data"] != null) {
        final data = AllOfficerMembersResponseModel.fromJson(res["data"]);
        allMembers.assignAll(data.members);
        members.assignAll(data.members);
        pincodeCount.value = data.pincodeCount;
      } else {
        allMembers.clear();
        members.clear();
        pincodeCount.value = 0;
        errorMessage.value = res["message"] ?? "Something went wrong.";
      }
    } catch (e) {
      print("❌ ALL CUSTOMERS ERROR: $e");
      allMembers.clear();
      members.clear();
      errorMessage.value = "Something went wrong. Please try again.";
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Load a member's category-wise waste summary — optional year/quarter filter
  Future<void> fetchMemberWasteCategory(
    String memberId, {
    int? year,
    int? quarter,
  }) async {
    try {
      isCategoryDetailLoading.value = true;
      categoryDetailError.value = '';

      final res = await _allMembersService.getMemberWasteCategory(
        memberId: memberId,
        year: year,
        quarter: quarter,
      );

      print("🗑️ MEMBER WASTE CATEGORY RESPONSE: $res");

      if (res["status"] == "SUCCESS" && res["data"] != null) {
        final data = MemberWasteCategoryDetailModel.fromJson(res["data"]);
        memberCategoryDetail.value = data;
        memberWasteCategories.assignAll(data.response);
      } else {
        memberCategoryDetail.value = null;
        memberWasteCategories.clear();
        categoryDetailError.value = res["message"] ?? "Something went wrong.";
      }
    } catch (e) {
      print("❌ MEMBER WASTE CATEGORY ERROR: $e");
      memberCategoryDetail.value = null;
      memberWasteCategories.clear();
      categoryDetailError.value = "Something went wrong. Please try again.";
    } finally {
      isCategoryDetailLoading.value = false;
    }
  }
}
