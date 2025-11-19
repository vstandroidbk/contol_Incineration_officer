import 'package:contol_officer_app/ReusableWidgets/shimmer.dart';
import 'package:flutter/material.dart';

class LoaderWrapper extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final int shimmerItems;
  final bool avatar;
  final bool twoLines;
  final bool showCard;
  final double verticalPadding;

  const LoaderWrapper({
    super.key,
    required this.isLoading,
    required this.child,
    this.shimmerItems = 6,
    this.avatar = true,
    this.twoLines = false,
    this.showCard = true,
    this.verticalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? ModernShimmer(
            items: shimmerItems,
            showAvatar: avatar,
            showTwoLines: twoLines,
            showCard: showCard,
            verticalPadding: verticalPadding,
          )
        : child;
  }
}
