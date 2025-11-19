import 'package:contol_officer_app/Modules/Field/recentManifests.dart';
import 'package:contol_officer_app/ReusableWidgets/appBar.dart';
import 'package:contol_officer_app/ReusableWidgets/loader.dart';
import 'package:contol_officer_app/ReusableWidgets/navbar.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Field extends StatefulWidget {
  const Field({super.key});

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate network/data load
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,

      appBar: CustomAppBar(
        title: "Field Reporting",
        subtitle: "Create & manage on-field Reports",
        rightWidget: SizedBox(
          width: 90,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(LucideIcons.plus, color: Colors.white, size: 18),
            label: Text(
              'Create',
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
      body:LoaderWrapper(
        isLoading: isLoading,
        shimmerItems: 10,
        showCard: true,
        child: SafeArea(
          child:Padding(padding: EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GRID
            GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _StatusContainer(
            count: 12,
            label: 'This Month',
            textColor: AppColors.Container4,
          ),
          _StatusContainer(
            count: 3,
            label: 'Pending',
            textColor: AppColors.primary,
          ),
          _StatusContainer(
            count: 1,
            label: 'Drafts',
            textColor: AppColors.secondary,
          ),
        ],
            ),
        
            const SizedBox(height: 20),
        
            const Text(
        "Assigned Manifests",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.bodytextColor,
        ),
            ),
        
            const SizedBox(height: 12),
        
            Expanded(
        child: ListView(
          children: [
            ManifestCard(
              manifestId: "MNF-2025-456",
              company: "Medical Center A",
              city: "Nashik",
              date: "Oct 12, 2025",
              priority: "High",
              priorityColor: AppColors.error,
            
            ),
            ManifestCard(
              manifestId: "MNF-2025-457",
              company: "Green Energy Co",
              city: "Pune",
              date: "Oct 11, 2025",
              priority: "Medium",
              priorityColor: AppColors.secondary,
            
            ),
            ManifestCard(
              manifestId: "MNF-2025-458",
              company: "ABC Industries",
              city: "Nashik",
              date: "Oct 10, 2025",
              priority: "Low",
              priorityColor: AppColors.primary,
            
            ),
          ],
        ),
            )
          ],
        ),
        
          )
           ),
      ),
         bottomNavigationBar: BottomNavBarDesign(),
         
    );
  }
}
class _StatusContainer extends StatelessWidget {
  final int count;
  final String label;
  final Color textColor;

  const _StatusContainer({
    required this.count,
    required this.label,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.bodytextColor.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$count',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.bodytextColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
