
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ModernShimmer extends StatelessWidget {
  final int items;
  final bool showAvatar;
  final bool showTwoLines;
  final bool showCard; // for full card shimmer (Profile, Membership, etc.)
  final double verticalPadding;

  const ModernShimmer({
    super.key,
    this.items = 6,
    this.showAvatar = true,
    this.showTwoLines = false,
    this.showCard = true,
    this.verticalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: EdgeInsets.all(verticalPadding),
        itemCount: items,
        itemBuilder: (_, __) {
          return Container(
            margin: EdgeInsets.only(bottom: verticalPadding),
            padding: showCard ? const EdgeInsets.all(16) : EdgeInsets.zero,
            decoration: showCard
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  )
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showAvatar)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                if (showAvatar) const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First line
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Second line
                      Container(
                        height: 14,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // Optional third line
                      if (showTwoLines) const SizedBox(height: 8),
                      if (showTwoLines)
                        Container(
                          height: 14,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      // Optional extra for membership / document card rows
                      if (showCard) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              height: 14,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 14,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
