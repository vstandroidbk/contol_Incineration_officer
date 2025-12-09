import 'package:contol_officer_app/ReusableWidgets/mainNav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../ReusableWidgets/textField.dart';
import '../utils/colors.dart';
import '../ReusableWidgets/loader.dart';
import '../ReusableWidgets/appBar.dart';
import 'package:file_picker/file_picker.dart';

// ---------------- MAIN PAGE -------------------

class MembershipForm extends StatefulWidget {
  const MembershipForm({super.key});

  @override
  State<MembershipForm> createState() => _MembershipFormState();
}

class _MembershipFormState extends State<MembershipForm> {
  bool isLoading = true;
  int _currentStep = 0;
  PageController? _pageController;

  // Controllers for Basic Details (Step 1)
  final TextEditingController industryNameCtrl = TextEditingController();
  final TextEditingController plantAddressCtrl = TextEditingController();
  final TextEditingController officeAddressCtrl = TextEditingController();
  final TextEditingController contactPersonCtrl = TextEditingController();
  final TextEditingController designationCtrl = TextEditingController();
  final TextEditingController telephoneCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController websiteCtrl = TextEditingController();
  final TextEditingController gstCtrl = TextEditingController();

  // Controllers for Industry Details (Step 2)
  String? natureOfIndustry;
  List<String> selectedIndustryTypes = [];
  final TextEditingController rawMaterialCtrl = TextEditingController();
  final TextEditingController processDetailsCtrl = TextEditingController();
  final TextEditingController finishedProductCtrl = TextEditingController();
  final TextEditingController otherIndustryTypeCtrl = TextEditingController();

  // Hazardous Waste NEW MODEL
  List<Map<String, dynamic>> hazardousWasteEntries = [];

  // Waste list
  final Map<String, String> wasteCategoryMap = {
    "Tarry residues": "1.2",
    "Oily sludge": "1.3",
    "Organic residues": "1.4",
    "Oil from wastewater": "1.7",
    "Sludge containing oil": "2.2",
  };

  final TextEditingController index4Ctrl = TextEditingController();

  // Controllers for Declaration (Step 4)
  final TextEditingController placeCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  String? uploadedFileName;




  // Form keys
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    4,
    (_) => GlobalKey<FormState>(),
  );

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _addHazardousWasteCard();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    industryNameCtrl.dispose();
    plantAddressCtrl.dispose();
    officeAddressCtrl.dispose();
    contactPersonCtrl.dispose();
    designationCtrl.dispose();
    telephoneCtrl.dispose();
    mobileCtrl.dispose();
    emailCtrl.dispose();
    websiteCtrl.dispose();
    gstCtrl.dispose();
    rawMaterialCtrl.dispose();
    processDetailsCtrl.dispose();
    finishedProductCtrl.dispose();
    otherIndustryTypeCtrl.dispose();

    for (var e in hazardousWasteEntries) {
      e['category'].dispose();
      e['quantity'].dispose();
      e['storage'].dispose();
      e['characteristics'].dispose();
      e['physicalState'].dispose();
      e['crit'].dispose();
    }

    index4Ctrl.dispose();
    placeCtrl.dispose();
    dateCtrl.dispose();
    super.dispose();
  }

  void _addHazardousWasteCard() {
    setState(() {
      hazardousWasteEntries.add({
        'wasteName': null,
        'category': TextEditingController(),
        'quantity': TextEditingController(),
        'storage': TextEditingController(),
        'characteristics': TextEditingController(),
        'physicalState': TextEditingController(),
        'crit': TextEditingController(),
      });
    });
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState?.validate() ?? false) {
      if (_currentStep < 3) {
        setState(() => _currentStep++);
        _pageController?.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitForm();
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController?.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitForm() {
    print("---- Hazardous Waste ----");
    for (var e in hazardousWasteEntries) {
      print("Waste: ${e['wasteName']}");
      print("Category: ${e['category'].text}");
      print("Qty: ${e['quantity'].text}");
      print("Storage: ${e['storage'].text}");
      print("Characteristics: ${e['characteristics'].text}");
      print("Physical: ${e['physicalState'].text}");
      print("CRIT: ${e['crit'].text}");
    }

    print("Index 4: ${index4Ctrl.text}");

    Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
  }

  // ---------------- APPBAR TITLE (NEW) ----------------
  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return "Basic Details";
      case 1:
        return "Industry Details";
      case 2:
        return "Hazardous Waste";
      case 3:
        return "Declaration";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: "Membership Form (${_getStepTitle()})"),
        body: LoaderWrapper(
          isLoading: isLoading,
          shimmerItems: 6,
          showCard: true,
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildStepIndicator(width),
              const SizedBox(height: 8),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        // Darker ambient shadow
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06), // was 0.03
                          blurRadius: 30,
                          offset: Offset(0, 10),
                        ),
                        // Darker crisp shadow
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12), // was 0.08
                          blurRadius: 12,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildBasicDetailsStep(formKey: _formKeys[0]),
                        _buildIndustryDetailsStep(formKey: _formKeys[1]),
                        _buildHazardousWasteStep(formKey: _formKeys[2]) ,
                        _buildDeclarationStep(formKey: _formKeys[3]) ,
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLoading) ...[
                const SizedBox(height: 16),
                _buildNavButtons(),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- STEP INDICATOR ----------------
  Widget _buildStepIndicator(double width) {
    List<String> titles = [
      "Basic Details",
      "Industry Details",
      "Hazardous Waste",
      "Declaration",
    ];
    List<IconData> icons = [
      LucideIcons.clipboardList,
      LucideIcons.stickyNote,
      LucideIcons.listTodo,
      LucideIcons.fileSignature,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: List.generate(icons.length * 2 - 1, (index) {
          if (index.isEven) {
            int stepIndex = index ~/ 2;
            bool completedOrActive = stepIndex <= _currentStep;
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: completedOrActive
                        ? AppColors.primary
                        : Colors.grey.withOpacity(0.4),
                    child: Icon(
                      icons[stepIndex],
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    titles[stepIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: completedOrActive
                          ? AppColors.primary
                          : Colors.grey,
                      fontWeight: completedOrActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          } else {
            int lineIndex = (index - 1) ~/ 2;
            bool isFilled = lineIndex < _currentStep;
            return SizedBox(
              child: Container(
                height: 2,
                width: 25,
                margin: const EdgeInsets.only(bottom: 14),
                color: isFilled
                    ? AppColors.primary
                    : Colors.grey.withOpacity(0.3),
              ),
            );
          }
        }),
      ),
    );
  }

  // ---------------- BUTTONS ----------------
  Widget _buildNavButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep >= 1)
            SizedBox(
              height: 38,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: _prevStep,
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 16),
                    SizedBox(width: 5),
                    Text(
                      "BACK",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Text("Step ${_currentStep + 1} of 4"),
          SizedBox(
            height: 38,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: _nextStep,
              child: Row(
                children: [
                  Text(
                    _currentStep == 3 ? "SUBMIT" : "NEXT",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- BASIC DETAILS ----------------
  Widget _buildBasicDetailsStep({required GlobalKey<FormState> formKey}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE REMOVED FROM CENTER ✔
            const SizedBox(height: 10),

            CustomTextField(
              label: "Name of the Industry",
              hintText: "Enter industry name",
              controller: industryNameCtrl,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: "Plant Address",
              hintText: "Enter plant address",
              controller: plantAddressCtrl,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Office Address",
              hintText: "Enter office address",
              controller: officeAddressCtrl,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Contacting Person",
              hintText: "Enter contact person name",
              controller: contactPersonCtrl,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Designation",
              hintText: "Enter designation",
              controller: designationCtrl,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Telephone Number",
              hintText: "Enter telephone number",
              controller: telephoneCtrl,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Mobile Number",
              hintText: "Enter mobile number",
              controller: mobileCtrl,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Email Address",
              hintText: "Enter email address",
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Website (URL Address)",
              hintText: "Enter website URL",
              controller: websiteCtrl,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "GST Registration Number",
              hintText: "Enter GST number",
              controller: gstCtrl,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------- INDUSTRY DETAILS ----------------
  Widget _buildIndustryDetailsStep({required GlobalKey<FormState> formKey}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title removed ✔
            const SizedBox(height: 10),

            const Text(
              "Nature of Industry",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    activeColor: AppColors.primary,
                    title: const Text("Large Scale"),
                    value: "Large Scale",
                    groupValue: natureOfIndustry,
                    onChanged: (value) {
                      setState(() {
                        natureOfIndustry = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    activeColor: AppColors.primary,
                    title: const Text("Medium Scale"),
                    value: "Medium Scale",
                    groupValue: natureOfIndustry,
                    onChanged: (value) {
                      setState(() {
                        natureOfIndustry = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    activeColor: AppColors.primary,
                    title: const Text("Small Scale"),
                    value: "Small Scale",
                    groupValue: natureOfIndustry,
                    onChanged: (value) {
                      setState(() {
                        natureOfIndustry = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              "Type of Industry",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),

            _buildMultiSelectDropdown(),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Raw Material Used",
              hintText: "Enter raw materials",
              controller: rawMaterialCtrl,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Brief Process Details",
              hintText: "Enter process details",
              controller: processDetailsCtrl,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "End/Finished Product",
              hintText: "Enter finished product",
              controller: finishedProductCtrl,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelectDropdown() {
    final List<String> industryTypes = [
      "Chemical",
      "Petro-Chemical",
      "Electro-Plating",
      "Consumer Product",
      "Automotive",
      "Mining",
      "Engineering",
      "Plastic",
      "Pharmaceutical",
      "Paint",
      "Textile",
      "Tannery",
      "Steel or any metal",
      "Pulp & Paper",
      "Electronics",
      "Pesticide",
      "Battery",
      "Food",
      "Beverages",
      "Ordinance",
      "Cosmetics",
      "Petroleum",
      "Other",
    ];
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textfieldBorder, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              final ScrollController scrollController = ScrollController();
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setDialogState) {
                      return AlertDialog(
                        title: const Text("Select Industry Types"),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: industryTypes.length,
                                  itemBuilder: (context, index) {
                                    final type = industryTypes[index];
                                    return CheckboxListTile(
                                      title: Text(type),
                                      value: selectedIndustryTypes.contains(
                                        type,
                                      ),
                                      onChanged: (bool? checked) {
                                        setDialogState(() {
                                          if (checked == true) {
                                            selectedIndustryTypes.add(type);
                                            if (type == "Other") {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                    scrollController.animateTo(
                                                      scrollController
                                                          .position
                                                          .maxScrollExtent,
                                                      duration: const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      curve: Curves.easeOut,
                                                    );
                                                  });
                                            }
                                          } else {
                                            selectedIndustryTypes.remove(type);
                                            if (type == "Other") {
                                              otherIndustryTypeCtrl.clear();
                                            }
                                          }
                                        });
                                        setState(() {});
                                      },
                                      dense: true,
                                    );
                                  },
                                ),
                                if (selectedIndustryTypes.contains(
                                  "Other",
                                )) ...[
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: TextField(
                                      controller: otherIndustryTypeCtrl,
                                      decoration: InputDecoration(
                                        labelText: "Specify Other Type",
                                        hintText: "Enter industry type",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: AppColors.lighttextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            child: const Text("Done"),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedIndustryTypes.isEmpty
                          ? "Select industry types"
                          : selectedIndustryTypes.join(", "),
                      style: TextStyle(
                        color: selectedIndustryTypes.isEmpty
                            ? AppColors.bodytextColor.withOpacity(0.6)
                            : AppColors.bodytextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.bodytextColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------- HAZARDOUS WASTE (CARD BASED) ----------------
  Widget _buildHazardousWasteStep({required GlobalKey<FormState> formKey}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            ...List.generate(
              hazardousWasteEntries.length,
              (i) => _buildHazardousWasteCard(i),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHazardousWasteCard(int index) {
    final entry = hazardousWasteEntries[index];

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textfieldBorder),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ROW 1 — Waste Dropdown
              const Text(
                "Hazardous Waste Name / Nomenclature",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textfieldBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: entry['wasteName'],
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Select waste name"),
                    ),
                    items: wasteCategoryMap.keys.map((waste) {
                      return DropdownMenuItem(
                        value: waste,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(waste),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        entry['wasteName'] = value;
                        entry['category'].text = wasteCategoryMap[value] ?? "";
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ROW 2 — Category | Quantity
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Category",
                      controller: entry['category'],
                      hintText: '',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: "Quantity",
                      controller: entry['quantity'],
                      hintText: '',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ROW 3 — Storage | Characteristics
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Storage Method",
                      controller: entry['storage'],
                      hintText: '',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: "Characteristics",
                      controller: entry['characteristics'],
                      hintText: '',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ROW 4 — Physical State | CRIT
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Physical State",
                      controller: entry['physicalState'],
                      hintText: '',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: "CRIT",
                      controller: entry['crit'],
                      hintText: '',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ---------- FLOATING ENTRY TAG WITH + AND - ICONS ----------
        Positioned(
          top: 0,
          left: 22,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.teal.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Entry ${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 8),

                // ---- DELETE BUTTON (visible when more than 1 entry) ----
                if (hazardousWasteEntries.length > 1)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        hazardousWasteEntries.removeAt(index);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.remove, color: Colors.white, size: 16),
                    ),
                  ),

                const SizedBox(width: 6),

                // ---- ADD BUTTON (only for last entry) ----
                if (index == hazardousWasteEntries.length - 1)
                  GestureDetector(
                    onTap: _addHazardousWasteCard,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }



  // ---------------- DECLARATION ----------------
  Widget _buildDeclarationStep({required GlobalKey<FormState> formKey}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            CustomTextField(
              label: "Place",
              hintText: "Enter place",
              controller: placeCtrl,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Date",
              hintText: "Select date",
              controller: dateCtrl,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateCtrl.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            const Text(
              "Upload File",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),

            InkWell(
              onTap: () async {

                FilePickerResult? result = await FilePicker.platform.pickFiles();

                if (result != null) {
                  setState(() {
                    uploadedFileName = result.files.single.name;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textfieldBorder),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.upload,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        uploadedFileName ?? "Tap to upload file",
                        style: TextStyle(
                          color: uploadedFileName != null
                              ? AppColors.bodytextColor
                              : AppColors.bodytextColor.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (uploadedFileName != null)
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
