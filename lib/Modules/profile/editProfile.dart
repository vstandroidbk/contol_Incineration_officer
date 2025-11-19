import 'package:contol_officer_app/ReusableWidgets/appBar.dart';
import 'package:contol_officer_app/ReusableWidgets/dropdown.dart';
import 'package:contol_officer_app/ReusableWidgets/textField.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController officerNameController = TextEditingController(
    text: "Rajesh Kumar",
  );
  final TextEditingController emailController = TextEditingController(
    text: "rajesh.kumar@controlincineration.com",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "+919876543210",
  );
  final TextEditingController joinDateController = TextEditingController();
  final TextEditingController phoneNumber2Controller = TextEditingController(
    text: "+919876543210",
  );

  String? selectedDistrict;
  List<String> districts = ["Nashik", "Pune", "Mumbai", "Nagpur", "Aurangabad"];

  bool uploadingIdCard = false;

  @override
  void dispose() {
    officerNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    joinDateController.dispose();
    phoneNumber2Controller.dispose();
    super.dispose();
  }

  void onUploadIdCard() {
    // Implement your upload logic here
    setState(() {
      uploadingIdCard = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        uploadingIdCard = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Profile Update",
        showBack: true,
        rightWidget: SizedBox(
          width: 90,
          child: ElevatedButton.icon(
            onPressed: () {
              // Save profile logic here
            },
            icon: Icon(LucideIcons.save, color: Colors.white, size: 18),
            label: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: const Size(0, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // PROFILE AVATAR WITH EDIT ICON
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/profile.jpg"),
                ),

                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.edit,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // COMPANY INFORMATION SECTION
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Officer Profile Information",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 6),
            const Divider(height: 1, color: AppColors.textfieldBorder),
            const SizedBox(height: 20),

            // Officer Name
            CustomTextField(
              label: "Officer Name",
              hintText: "Rajesh Kumar",
              controller: officerNameController,
            ),
            const SizedBox(height: 10),

            // Email
            CustomTextField(
              label: "Email",
              hintText: "rajesh.kumar@controlincineration.com",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              // enabled: false,
            ),
            const SizedBox(height: 10),

            // Phone Number
            CustomTextField(
              label: "Phone Number",
              hintText: "+919876543210",
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),

            // Join Date
            CustomTextField(
              label: "Join Date",
              hintText: "dd/mm/yyyy",
              controller: joinDateController,
              keyboardType: TextInputType.datetime,
              enabled: true,
              onToggleVisibility: null,
            ),

            const SizedBox(height: 10),

            // Upload ID Card 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Upload ID Card",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 6),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textfieldBorder),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                        //  UPLOAD BUTTON
                      SizedBox(
                        height: 47,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: uploadingIdCard
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Upload",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      // FILENAME / HINT
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            uploadingIdCard
                                ? "Uploading..."
                                : "Document (pdf, jpg, png)",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.bodytextColor.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),

                    
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Select Districts Dropdown
            CustomDropdownField2(
              label: "Select Districts",
              hintText: "Select",
              items: districts,
              value: selectedDistrict,
              onChanged: (val) {
                setState(() {
                  selectedDistrict = val;
                });
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
