import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Community Guidelines Widget - Subtle reminder banner for conscious sharing
/// Features: Dismissible banner with spiritual community guidelines
class CommunityGuidelinesWidget extends StatefulWidget {
  const CommunityGuidelinesWidget({super.key});

  @override
  State<CommunityGuidelinesWidget> createState() =>
      _CommunityGuidelinesWidgetState();
}

class _CommunityGuidelinesWidgetState extends State<CommunityGuidelinesWidget> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Share with love, respect, and authenticity ✨',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isVisible = false),
            child: Icon(
              Icons.close,
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
              size: 4.w,
            ),
          ),
        ],
      ),
    );
  }
}
