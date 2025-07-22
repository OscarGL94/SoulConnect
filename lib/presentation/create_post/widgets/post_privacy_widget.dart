import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Post Privacy Widget - Toggle between community-wide or matches-only visibility
/// Features: Privacy settings with clear explanations, maintains match-only chat restriction
class PostPrivacyWidget extends StatelessWidget {
  final String selectedPrivacy;
  final Function(String) onPrivacyChanged;

  const PostPrivacyWidget({
    super.key,
    required this.selectedPrivacy,
    required this.onPrivacyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Post Visibility',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 2.h),

        // Community Option
        _PrivacyOption(
          value: 'community',
          title: 'Everyone in Community',
          subtitle: 'All community members can see and react to your post',
          icon: Icons.public,
          isSelected: selectedPrivacy == 'community',
          onTap: () => onPrivacyChanged('community'),
        ),

        SizedBox(height: 2.h),

        // Matches Only Option
        _PrivacyOption(
          value: 'matches',
          title: 'Mutual Matches Only',
          subtitle: 'Only people you\'ve matched with can see your post',
          icon: Icons.favorite,
          isSelected: selectedPrivacy == 'matches',
          onTap: () => onPrivacyChanged('matches'),
        ),

        SizedBox(height: 2.h),

        // Privacy Note
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Private messaging is only available between mutual matches, regardless of post visibility.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrivacyOption extends StatelessWidget {
  final String value;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PrivacyOption({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }
}
