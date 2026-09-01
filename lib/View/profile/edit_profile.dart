import 'dart:io';
import 'package:contol_officer_app/Controller/profileController.dart';
import 'package:contol_officer_app/utils/single_date_calendar.dart';
import 'package:contol_officer_app/utils/upload_img.dart';
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/widgets/dropdown.dart';
import 'package:contol_officer_app/widgets/text_field.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:intl/intl.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final ProfileController _profileController = Get.find<ProfileController>();

  late final TextEditingController officerNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController joinDateController;

  String? selectedDistrict;
  List<String> districts = ["Nashik", "Pune", "Mumbai", "Nagpur", "Aurangabad"];

  bool uploadingIdCard = false;
  String? profileImagePath;

  DateTime? _selectedDate;
  bool _showAllPincodes = false;

  // 👇 Snapshot of ORIGINAL values, used to detect changes
  late final String _originalName;
  late final String _originalEmail;
  late final String _originalPhone;
  late final String _originalJoinDate;

  bool _hasChanges = false; // 👈 drives Save button enabled/disabled state

  @override
  void initState() {
    super.initState();

    final profile = _profileController.officerProfile.value;

    _originalName = profile?.fullName ?? "";
    _originalEmail = profile?.email ?? "";
    _originalPhone = profile?.mobileNumber ?? "";
    _originalJoinDate = profile?.joiningDate ?? "";

    officerNameController = TextEditingController(text: _originalName);
    emailController = TextEditingController(text: _originalEmail);
    phoneController = TextEditingController(text: _originalPhone);
    joinDateController = TextEditingController(text: _originalJoinDate);

    // 👇 Parse original join date into DateTime for calendar's initialDate, if valid
    if (_originalJoinDate.isNotEmpty) {
      try {
        _selectedDate = DateFormat('dd/MM/yyyy').parse(_originalJoinDate);
      } catch (_) {
        _selectedDate = null;
      }
    }

    // 👇 Listen to every field — recompute _hasChanges on any edit
    officerNameController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
    phoneController.addListener(_checkForChanges);
    joinDateController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    officerNameController.removeListener(_checkForChanges);
    emailController.removeListener(_checkForChanges);
    phoneController.removeListener(_checkForChanges);
    joinDateController.removeListener(_checkForChanges);

    officerNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    joinDateController.dispose();
    super.dispose();
  }

  /// 👇 Compares current field values against original snapshot
  void _checkForChanges() {
    final changed = officerNameController.text.trim() != _originalName ||
        emailController.text.trim() != _originalEmail ||
        phoneController.text.trim() != _originalPhone ||
        joinDateController.text.trim() != _originalJoinDate;

    if (changed != _hasChanges) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  void onUploadIdCard() {
    setState(() {
      uploadingIdCard = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        uploadingIdCard = false;
      });
    });
  }

  void _openImagePickerDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => UploadDocumentDialogImg(
        onFilePicked: (path) async {
          setState(() {
            profileImagePath = path;
          });

          final res = await _profileController.uploadProfileImage(path);

          if (!mounted) return;

          if (res["status"] == "SUCCESS") {
            AppSnackBar.success(
              context: context,
              message: res["message"] ?? "Profile photo updated",
            );
          } else {
            AppSnackBar.error(
              context: context,
              message: res["message"] ?? "Failed to upload photo",
            );
          }
        },
      ),
    );
  }

  /// 👇 Opens the custom calendar dialog instead of the native date picker
  void _openJoinDateDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => SingleDateCalendarDialog(
        initialDate: _selectedDate,
        onSelect: (picked) {
          setState(() {
            _selectedDate = picked;
            joinDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          });
          _checkForChanges();
        },
      ),
    );
  }

  Future<void> _onSavePressed() async {
    if (!_hasChanges) return; // safety guard

    final res = await _profileController.editOfficerProfile(
      fullName: officerNameController.text.trim(),
      email: emailController.text.trim(),
      mobileNumber: phoneController.text.trim(),
      joiningDate: joinDateController.text.trim(),
    );

    if (!mounted) return;

    if (res["status"] == "SUCCESS") {
      AppSnackBar.success(
        context: context,
        message: res["message"] ?? "Profile updated successfully",
      );
      Get.back();
    } else {
      AppSnackBar.error(
        context: context,
        message: res["message"] ?? "Failed to update profile",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Profile Update",
        showBack: true,
        rightWidget: Obx(
          () {
            final isUpdating = _profileController.isUpdatingProfile.value;
            final canSave = _hasChanges && !isUpdating; // 👈 disabled until changes exist

            return SizedBox(
              width: 90,
              child: ElevatedButton.icon(
                onPressed: canSave ? _onSavePressed : null,
                icon: isUpdating
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(LucideIcons.save, color: Colors.white, size: 18),
                label: Text(
                  isUpdating ? "..." : "Save",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSave
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.4), // 👈 visually greyed out when disabled
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            );
          },
        ),
      ),
      body: Obx(() {
        final profile = _profileController.officerProfile.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                final networkImage = _profileController.officerProfile.value?.profile;
                final isUploading = _profileController.isUploadingImage.value;

                ImageProvider avatarImage;
                if (profileImagePath != null) {
                  avatarImage = FileImage(File(profileImagePath!));
                } else if (networkImage != null && networkImage.isNotEmpty) {
                  avatarImage = NetworkImage(networkImage);
                } else {
                  avatarImage = const AssetImage("assets/images/profile.jpg");
                }

                return GestureDetector(
                  onTap: isUploading ? null : _openImagePickerDialog,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(radius: 40, backgroundImage: avatarImage),
                      if (isUploading)
                        const Positioned.fill(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.black38,
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            ),
                          ),
                        ),
                      if (!isUploading)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(LucideIcons.edit, color: Colors.white, size: 18),
                        ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 8),

              if (profile?.loginId != null && profile!.loginId.isNotEmpty)
                Text(
                  profile.loginId,
                  style: TextStyle(
                    color: AppColors.bodytextColor.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Officer Profile Information",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 6),
              const Divider(height: 1, color: AppColors.textfieldBorder),
              const SizedBox(height: 20),

              CustomTextField(
                label: "Officer Name",
                hintText: "Enter full name",
                controller: officerNameController,
              ),
              const SizedBox(height: 10),

              CustomTextField(
                label: "Email",
                hintText: "Enter email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              CustomTextField(
                label: "Phone Number",
                hintText: "Enter phone number",
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),

              // 👇 Join Date — calendar icon suffix, tapping opens SingleDateCalendarDialog
              CustomTextField(
                label: "Join Date",
                hintText: "dd/mm/yyyy",
                controller: joinDateController,
                keyboardType: TextInputType.datetime,
                enabled: true,
                readOnly: true,          // user can't type manually — only via dialog
                showCalendarIcon: true,  // 👈 shows calendar icon suffix
                onUploadTap: _openJoinDateDialog, // 👈 officer app's CustomTextField reuses onUploadTap for calendar tap
                onTap: _openJoinDateDialog,       // 👈 tapping the field itself also opens dialog
              ),

            ],
          ),
        );
      }),
    );
  }
}