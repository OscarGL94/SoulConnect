import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> partner;
  final VoidCallback onBackPressed;
  final VoidCallback onProfileTap;
  final VoidCallback onMenuPressed;

  const ChatHeaderWidget({
    Key? key,
    required this.partner,
    required this.onBackPressed,
    required this.onProfileTap,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 1,
      shadowColor:
          AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
      leading: GestureDetector(
        onTap: onBackPressed,
        child: Container(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: "arrow_back",
            size: 6.w,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ),
      title: GestureDetector(
        onTap: onProfileTap,
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 5.w,
                  child: CustomImageWidget(
                    imageUrl: partner["avatar"] as String,
                    width: 10.w,
                    height: 10.w,
                    fit: BoxFit.cover,
                  ),
                ),
                if (partner["isOnline"] as bool)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: AppTheme.successLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partner["name"] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    partner["isOnline"] as bool
                        ? "En línea"
                        : "Última vez ${_formatLastSeen(partner["lastSeen"] as DateTime)}",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: partner["isOnline"] as bool
                          ? AppTheme.successLight
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onMenuPressed,
          child: Container(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: "more_vert",
              size: 6.w,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inDays > 0) {
      return "hace ${difference.inDays}d";
    } else if (difference.inHours > 0) {
      return "hace ${difference.inHours}h";
    } else if (difference.inMinutes > 0) {
      return "hace ${difference.inMinutes}m";
    } else {
      return "hace un momento";
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
