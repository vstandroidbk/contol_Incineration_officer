import 'package:contol_officer_app/Modules/Concern/addConcern.dart';
import 'package:contol_officer_app/Modules/Concern/concernDetails.dart';
import 'package:contol_officer_app/Modules/Concern/updateStatus.dart';
import 'package:contol_officer_app/ReusableWidgets/appBar.dart';
import 'package:contol_officer_app/ReusableWidgets/loader.dart';
import 'package:contol_officer_app/ReusableWidgets/navbar.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Concern extends StatefulWidget {
  const Concern({super.key});

  @override
  State<Concern> createState() => _ConcernState();
}

class _ConcernState extends State<Concern> {
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
        title: "Concern & Escalations.",
        subtitle: "Manage compliance issues and alerts",
        rightWidget: SizedBox(
          width: 90,
          child: ElevatedButton.icon(
            onPressed: () {
              // To show bottom sheet form
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const RaiseConcernBottomSheet(),
              );
            },
            icon: Icon(LucideIcons.plus, color: Colors.white, size: 18),
            label: Text(
              'Add',
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

      body: LoaderWrapper(
        isLoading: isLoading,
        showCard: true,
        shimmerItems: 10,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// STATIC GRID SECTION (NOT SCROLLABLE)
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // keep fixed
                  children: [
                    _StatusContainer(
                      count: 8,
                      label: 'Open',
                      backgroundColor: AppColors.secondary.withOpacity(0.9),
                      textColor: Colors.black,
                    ),
                    _StatusContainer(
                      count: 5,
                      label: 'In Progress',
                      backgroundColor: AppColors.Container4.withOpacity(0.9),
                      textColor: Colors.white,
                    ),
                    _StatusContainer(
                      count: 24,
                      label: 'Resolved',
                      backgroundColor: AppColors.primary.withOpacity(0.9),
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Recent Concern',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.bodytextColor,
                    letterSpacing: .5,
                  ),
                ),
        
                const SizedBox(height: 10),
        
                /// SCROLLABLE SECTION
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 10),
                      ConcernCard(
                        industryName: "ABC Industries",
                        concern: "COOI - Capacity Exceeded",
                        statusIcon: LucideIcons.alertTriangle,
                        detail:
                            'Customer has exceeded annual capacity limit by 15%',
                        priority: "High",
                        prioritytext: AppColors.error,
                        progress: "Open",
                        progressbtnColor: AppColors.secondary,
                        goesTo: "Admin",
                        pickupDate: 'Oct 15, 2025',
                      ),
        
                      ConcernCard(
                        industryName: "ABC Industries",
                        concern: "COU - Manifest Discrepancy",
                        statusIcon: LucideIcons.clock,
                        detail:
                            'Waste category mismatch between manifest and actual waste',
                        priority: "Medium",
                        prioritytext: AppColors.secondary,
                        progress: "In-progress",
                        progressbtnColor: AppColors.inProgress,
                        goesTo: "Compliance Team",
                        pickupDate: 'Oct 25, 2025',
                      ),
        
                      ConcernCard(
                        industryName: "Medical Industries",
                        concern: "C003 - Documentation Issue",
                        statusIcon: LucideIcons.checkCircle,
                        detail: 'Missing required compliance certificates',
                        priority: "Low",
                        prioritytext: AppColors.primary,
                        progress: "Resolved",
                        progressbtnColor: AppColors.primary,
                        goesTo: "Document Team",
                        pickupDate: 'Nov 5, 2025',
                      ),
        
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavBarDesign(),
    );
  }
}

class _StatusContainer extends StatelessWidget {
  final int count;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _StatusContainer({
    required this.count,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
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
                  color: textColor,
                  fontWeight: FontWeight.w500,
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

class ConcernCard extends StatelessWidget {
  final String industryName;
  final String concern;
  final IconData statusIcon;
  final String detail;
  final String priority;
  final Color prioritytext;
  final String progress;
  final Color progressbtnColor;
  final String goesTo;

  final String pickupDate;

  const ConcernCard({
    super.key,
    required this.industryName,
    required this.statusIcon,
    required this.concern,
    required this.detail,
    required this.priority,
    required this.prioritytext,
    required this.progress,
    required this.progressbtnColor,
    required this.goesTo,

    required this.pickupDate,
  });

  bool isResolved(String value) {
    return value.toLowerCase() == "resolved";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textfieldBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(statusIcon, size: 22, color: AppColors.secondary),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        concern,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bodytextColor,
                        ),
                      ),
                      Text(
                        industryName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.bodytextColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Status Tag
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: prioritytext.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: prioritytext,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            detail,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.bodytextColor.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start, // allows multi-line
            children: [
              /// LEFT SIDE FLEXIBLE ROW
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: progressbtnColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: progressbtnColor.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        progress,
                        softWrap: true,
                        style: TextStyle(
                          color: progressbtnColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Icon(
                      LucideIcons.moveRight,
                      size: 22,
                      color: AppColors.lighttextColor,
                    ),

                    const SizedBox(width: 12),

                    /// GOES-TO TEXT WRAPS SAFELY
                    Expanded(
                      child: Text(
                        goesTo,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color: AppColors.bodytextColor.withOpacity(0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              /// DATE (PREVENT OVERFLOW)
              Text(
                pickupDate,
                softWrap: true,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.bodytextColor.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// BOTTOM BUTTONS
          isResolved(progress)
              ? SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ConcernDetailsScreen(
                            industryName: industryName,
                            concern: concern,
                            detail: detail,
                            priority: priority,
                            priorityColor: prioritytext,
                            progress: progress,
                            progressColor: progressbtnColor,
                            goesTo: goesTo,
                            pickupDate: pickupDate,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(LucideIcons.eye, size: 18),
                    label: const Text("View Details"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.bodytextColor,
                      side: const BorderSide(color: AppColors.textfieldBorder),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      minimumSize: const Size(0, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // To show bottom sheet form
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (_) => const UpdatestatusConcern(),
                          );
                        },
                        icon: const Icon(
                          LucideIcons.edit,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text("Update Status"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          minimumSize: const Size(0, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                         onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ConcernDetailsScreen(
                            industryName: industryName,
                            concern: concern,
                            detail: detail,
                            priority: priority,
                            priorityColor: prioritytext,
                            progress: progress,
                            progressColor: progressbtnColor,
                            goesTo: goesTo,
                            pickupDate: pickupDate,
                          ),
                        ),
                      );
                    },
                        icon: const Icon(LucideIcons.eye, size: 18),
                        label: const Text("View Details"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.bodytextColor,
                          side: const BorderSide(
                            color: AppColors.textfieldBorder,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          minimumSize: const Size(0, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
