import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../utils/colors.dart';

class ManifestCard extends StatelessWidget {
  final String manifestId;
  final String company;
  final String city;
  final String date;
  final String priority;
  final Color priorityColor;


  const ManifestCard({
    super.key,
    required this.manifestId,
    required this.company,
    required this.city,
    required this.date,
    required this.priority,
    required this.priorityColor,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textfieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW — Name + Priority
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manifestId,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bodytextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    company,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.bodytextColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),

              // Priority Tag
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: priorityColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // LOCATION + DATE ROW
          Row(
            children: [
              const Icon(LucideIcons.mapPin, size: 20, color: AppColors.lighttextColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  city,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.bodytextColor.withOpacity(0.6),
                  ),
                ),
              ),

              const Icon(LucideIcons.calendar, size: 20, color: AppColors.lighttextColor),
              const SizedBox(width: 6),
              Text(
                date,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.bodytextColor.withOpacity(0.6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // BOTTOM BUTTONS
          Row(
            children: [
              Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          LucideIcons.edit,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text("Verify Manifests"),
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
                         onPressed: () {},
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
          )
        ],
      ),
    );
  }
}
