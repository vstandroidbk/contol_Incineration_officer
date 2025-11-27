import 'package:contol_officer_app/Modules/Reports/activityReport.dart';
import 'package:contol_officer_app/Modules/Reports/customersReport.dart';
import 'package:contol_officer_app/Modules/Reports/districtReport.dart';
import 'package:contol_officer_app/ReusableWidgets/appBar.dart';
import 'package:contol_officer_app/ReusableWidgets/dropdown.dart';
import 'package:contol_officer_app/ReusableWidgets/loader.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({super.key});
  
  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = ['District', 'Activity', 'Customers'];
  String selectedQuarter = "Q4 2024";
    bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update tab selection
    });
     // Simulate network/data load
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        title: "Regional Reports",
        subtitle: "Comprehensive analytics for your region",
        rightWidget: SizedBox(
          width: 120,
          child: CustomDropdownField(
            label: "Select Quarter",
            value: selectedQuarter,
            items: const ["Q4 2024", "Q3 2024"],
            hintText: "Select",
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  selectedQuarter = val;
                });
              }
            },
          ),
        ),
      ),

      body: LoaderWrapper(
        isLoading: isLoading,
        shimmerItems: 10,
        showCard: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                   // Tab Bar
                  Container(
                    height: 45,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.tabBarColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final bool isActive = _tabController.index == index;
        
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _tabController.index = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tabs[index],
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.white
                                      : AppColors.bodytextColor.withOpacity(0.6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
        
                   // Tab Views
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics:
                          const NeverScrollableScrollPhysics(), // disable swipe
                      children: const [
                        Districtreport(),
                        Activityreport(),
                        Customersreport()
                      ],
                    ),
                  ),
              ],
              
            ),
          )),
      ),

     
    );
  }
}
