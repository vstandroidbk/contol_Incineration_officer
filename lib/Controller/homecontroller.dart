import 'package:contol_officer_app/model/categoryModel.dart';
import 'package:contol_officer_app/model/memberModel.dart';
import 'package:contol_officer_app/services/homeservice.dart';
import 'package:get/get.dart';


class MemberController extends GetxController {
  final MemberService _memberService = MemberService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // 👇 full list fetched once (source of truth)
  var allMembers = <OfficerMemberModel>[].obs;

  // 👇 what's actually shown on screen (full list OR filtered)
  var members = <OfficerMemberModel>[].obs;

  // 👇 add these inside MemberController class

var isCategoryLoading = false.obs;
var categoryErrorMessage = ''.obs;

var regionalOfficerName = ''.obs;
var categoryCount = 0.obs;

var allCategories = <CategoryItemModel>[].obs; // source of truth
var categories = <CategoryItemModel>[].obs;     // displayed (filtered)

/// 🔹 Load officer's category-wise summary
Future<void> fetchCategorySummary() async {
  try {
    isCategoryLoading.value = true;
    categoryErrorMessage.value = '';

    final res = await _memberService.getOfficerCategorySummary();

    print("🗂️ CATEGORY SUMMARY RESPONSE: $res");

    if (res["status"] == "SUCCESS" && res["data"] != null) {
      final data = CategorySummaryModel.fromJson(res["data"]);
      regionalOfficerName.value = data.regionalOfficerName;
      categoryCount.value = data.categoryCount;
      allCategories.assignAll(data.categories);
      categories.assignAll(data.categories);
    } else {
      allCategories.clear();
      categories.clear();
      categoryErrorMessage.value = res["message"] ?? "Something went wrong.";
    }
  } catch (e) {
    print("❌ CATEGORY SUMMARY ERROR: $e");
    allCategories.clear();
    categories.clear();
    categoryErrorMessage.value = "Something went wrong. Please try again.";
  } finally {
    isCategoryLoading.value = false;
  }
}

/// 🔹 Local search filter by category title or number
void searchCategories(String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) {
    categories.assignAll(allCategories);
  } else {
    categories.assignAll(
      allCategories.where((c) =>
          c.categoryTitle.toLowerCase().contains(q) ||
          c.categoryNumber.toLowerCase().contains(q)),
    );
  }
}

  /// 🔹 Load full customer list by default (empty pincode = all)
  Future<void> fetchAllMembers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await _memberService.getOfficerMembersByPincode(
        pincode: "",
      );

      print("📍 ALL MEMBERS RESPONSE: $res");

      if (res["status"] == "SUCCESS" && res["data"] != null) {
        final data = OfficerMembersResponseModel.fromJson(res["data"]);
        allMembers.assignAll(data.members);
        members.assignAll(data.members);
      } else {
        allMembers.clear();
        members.clear();
        errorMessage.value = res["message"] ?? "Something went wrong.";
      }
    } catch (e) {
      print("❌ ALL MEMBERS ERROR: $e");
      allMembers.clear();
      members.clear();
      errorMessage.value = "Something went wrong. Please try again.";
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Local filter on already-loaded list by pincode prefix
  void filterByPincode(String query) {
    final q = query.trim();
    if (q.isEmpty) {
      members.assignAll(allMembers);
    } else {
      members.assignAll(
        allMembers.where((m) => m.pinCode.startsWith(q)).toList(),
      );
    }
  }
}