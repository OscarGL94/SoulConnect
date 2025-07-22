import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final VoidCallback? onLongPress;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isMe,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 4.w),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              CircleAvatar(
                radius: 2.5.w,
                child: CustomImageWidget(
                  imageUrl: message["senderAvatar"] as String? ?? "",
                  width: 5.w,
                  height: 5.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 2.w),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: 70.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isMe
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                    bottomLeft:
                        isMe ? Radius.circular(4.w) : Radius.circular(1.w),
                    bottomRight:
                        isMe ? Radius.circular(1.w) : Radius.circular(4.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow
                          .withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message["content"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isMe
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message["timestamp"] as DateTime),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isMe
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                    .withValues(alpha: 0.7)
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                            fontSize: 10.sp,
                          ),
                        ),
                        if (isMe) ...[
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: _getStatusIcon(
                                message["status"] as String? ?? "sent"),
                            size: 3.w,
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.7),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isMe) ...[
              SizedBox(width: 2.w),
              CircleAvatar(
                radius: 2.5.w,
                child: CustomImageWidget(
                  imageUrl:
                      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
                  width: 5.w,
                  height: 5.w,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return "${timestamp.day}/${timestamp.month}";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m";
    } else {
      return "ahora";
    }
  }

  String _getStatusIcon(String status) {
    switch (status) {
      case "sent":
        return "check";
      case "delivered":
        return "done_all";
      case "read":
        return "done_all";
      default:
        return "schedule";
    }
  }
}
