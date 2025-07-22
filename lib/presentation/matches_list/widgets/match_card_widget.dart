import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MatchCardWidget extends StatelessWidget {
  final Map<String, dynamic> matchData;
  final VoidCallback onTap;
  final VoidCallback? onArchive;
  final VoidCallback? onQuickMessage;

  const MatchCardWidget({
    Key? key,
    required this.matchData,
    required this.onTap,
    this.onArchive,
    this.onQuickMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasUnreadMessages = matchData['hasUnreadMessages'] ?? false;
    final String lastMessage = matchData['lastMessage'] ?? '';
    final String timestamp = _formatTimestamp(matchData['lastMessageTime']);
    final int mutualInterests = matchData['mutualInterests'] ?? 0;

    return Dismissible(
        key: Key(matchData['id'].toString()),
        background: _buildSwipeBackground(true),
        secondaryBackground: _buildSwipeBackground(false),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd &&
              onQuickMessage != null) {
            onQuickMessage!();
          } else if (direction == DismissDirection.endToStart &&
              onArchive != null) {
            onArchive!();
          }
        },
        child: GestureDetector(
            onTap: onTap,
            onLongPress: () => _showContextMenu(context),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.shadowLight,
                          blurRadius: 8,
                          offset: Offset(0, 2)),
                    ]),
                child: Row(children: [
                  _buildProfileImage(),
                  SizedBox(width: 3.w),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        _buildNameAndBadge(hasUnreadMessages),
                        SizedBox(height: 0.5.h),
                        _buildMutualInterests(mutualInterests),
                        SizedBox(height: 1.h),
                        _buildLastMessage(lastMessage, hasUnreadMessages),
                      ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(timestamp,
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                                color: hasUnreadMessages
                                    ? AppTheme.primaryLight
                                    : AppTheme.textSecondaryLight,
                                fontWeight: hasUnreadMessages
                                    ? FontWeight.w600
                                    : FontWeight.w400)),
                    if (hasUnreadMessages) ...[
                      SizedBox(height: 1.h),
                      Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: BoxDecoration(shape: BoxShape.circle)),
                    ],
                  ]),
                ]))));
  }

  Widget _buildProfileImage() {
    return Container(
        width: 15.w,
        height: 15.w,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.borderLight, width: 1)),
        child: ClipOval(
            child: CustomImageWidget(
                imageUrl: matchData['profileImage'] ?? '',
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover)));
  }

  Widget _buildNameAndBadge(bool hasUnreadMessages) {
    return Row(children: [
      Expanded(
          child: Text(matchData['spiritualName'] ?? 'Unknown',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight:
                      hasUnreadMessages ? FontWeight.w600 : FontWeight.w500,
                  color: hasUnreadMessages
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textPrimaryLight),
              maxLines: 1,
              overflow: TextOverflow.ellipsis)),
      if (matchData['isNewMatch'] == true) ...[
        SizedBox(width: 2.w),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Text('Nuevo',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.onPrimaryLight,
                    fontWeight: FontWeight.w600))),
      ],
    ]);
  }

  Widget _buildMutualInterests(int count) {
    return Row(children: [
      CustomIconWidget(
          iconName: 'favorite', color: AppTheme.secondaryLight, size: 4.w),
      SizedBox(width: 1.w),
      Text('$count intereses en común',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryLight, fontWeight: FontWeight.w500)),
    ]);
  }

  Widget _buildLastMessage(String message, bool hasUnreadMessages) {
    return Text(
        message.isEmpty ? 'Toca para iniciar una conversación' : message,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: message.isEmpty
                ? AppTheme.textDisabledLight
                : (hasUnreadMessages
                    ? AppTheme.textPrimaryLight
                    : AppTheme.textSecondaryLight),
            fontWeight: hasUnreadMessages ? FontWeight.w500 : FontWeight.w400,
            fontStyle: message.isEmpty ? FontStyle.italic : FontStyle.normal),
        maxLines: 2,
        overflow: TextOverflow.ellipsis);
  }

  Widget _buildSwipeBackground(bool isQuickMessage) {
    return Container(
        alignment:
            isQuickMessage ? Alignment.centerLeft : Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomIconWidget(
              iconName: isQuickMessage ? 'message' : 'archive',
              color: AppTheme.onPrimaryLight,
              size: 6.w),
          SizedBox(height: 1.h),
          Text(isQuickMessage ? 'Mensaje' : 'Archivar',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.onPrimaryLight, fontWeight: FontWeight.w600)),
        ]));
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: AppTheme.borderLight,
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 3.h),
              _buildContextMenuItem(context, 'Ver perfil completo', 'person',
                  () => Navigator.pushNamed(context, '/profile-detail')),
              _buildContextMenuItem(context, 'Silenciar notificaciones',
                  'notifications_off', () => Navigator.pop(context)),
              _buildContextMenuItem(context, 'Reportar usuario', 'report',
                  () => Navigator.pop(context)),
              SizedBox(height: 2.h),
            ])));
  }

  Widget _buildContextMenuItem(
      BuildContext context, String title, String iconName, VoidCallback onTap) {
    return ListTile(
        leading: CustomIconWidget(
            iconName: iconName, color: AppTheme.textPrimaryLight, size: 6.w),
        title: Text(title, style: AppTheme.lightTheme.textTheme.bodyLarge),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime messageTime;
    if (timestamp is DateTime) {
      messageTime = timestamp;
    } else if (timestamp is String) {
      messageTime = DateTime.tryParse(timestamp) ?? DateTime.now();
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(messageTime);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${messageTime.day}/${messageTime.month}';
    }
  }
}
