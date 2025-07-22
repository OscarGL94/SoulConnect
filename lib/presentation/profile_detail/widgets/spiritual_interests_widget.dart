import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SpiritualInterestsWidget extends StatelessWidget {
  final List<String> interests;
  final List<String> sharedInterests;

  const SpiritualInterestsWidget({
    Key? key,
    required this.interests,
    required this.sharedInterests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Intereses Espirituales',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: interests.map((interest) {
            final bool isShared = sharedInterests.contains(interest);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isShared
                    ? AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.2)
                    : AppTheme.lightTheme.colorScheme.surface,
                border: Border.all(
                  color: isShared
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6.w),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isShared)
                    Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: CustomIconWidget(
                        iconName: 'favorite',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 4.w,
                      ),
                    ),
                  Text(
                    interest,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isShared
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: isShared ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
