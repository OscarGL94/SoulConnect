import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:photo_view/photo_view.dart';

/// Post Card Widget - Displays individual community posts with spiritual reactions
/// Features: Profile photo, content, media preview, spiritual reactions, comments
/// Responsive design with proper touch targets and accessibility
class PostCardWidget extends StatefulWidget {
  final Map<String, dynamic> post;
  final Function(String postId, String reaction) onReaction;
  final Function(String postId) onComment;
  final Function(String postId) onSave;
  final Function(String postId) onReport;
  final Function(String userId) onUserTap;

  const PostCardWidget({
    super.key,
    required this.post,
    required this.onReaction,
    required this.onComment,
    required this.onSave,
    required this.onReport,
    required this.onUserTap,
  });

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  bool _isExpanded = false;
  bool _showFullImage = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header with Profile Info
          _buildPostHeader(),

          // Post Content
          _buildPostContent(),

          // Media Content (Image/Video)
          if (widget.post['hasImage'] == true) _buildImageContent(),
          if (widget.post['hasVideo'] == true) _buildVideoContent(),

          // Spiritual Tags
          _buildSpiritualTags(),

          // Reactions and Actions Bar
          _buildActionsBar(),

          // Comments Preview
          _buildCommentsPreview(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          // Profile Avatar
          GestureDetector(
            onTap: () => widget.onUserTap(widget.post['userId']),
            child: CircleAvatar(
              radius: 6.w,
              backgroundImage: CachedNetworkImageProvider(
                widget.post['userAvatar'] ?? '',
              ),
            ),
          ),
          SizedBox(width: 3.w),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => widget.onUserTap(widget.post['userId']),
                  child: Text(
                    widget.post['userName'] ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Text(
                  _formatTimestamp(widget.post['timestamp']),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),

          // More Options Menu
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'save', child: Text('Save Post')),
              const PopupMenuItem(value: 'hide', child: Text('Hide from Feed')),
              const PopupMenuItem(value: 'report', child: Text('Report Post')),
            ],
            child: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    final content = widget.post['content'] ?? '';
    final shouldShowReadMore = content.length > 150;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isExpanded || !shouldShowReadMore
                ? content
                : '${content.substring(0, 150)}...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.4,
                ),
          ),
          if (shouldShowReadMore) ...[
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(
                _isExpanded ? 'Show less' : 'Read more',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    final imageUrl = widget.post['imageUrl'];
    if (imageUrl == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: GestureDetector(
        onTap: () => _showImageFullScreen(imageUrl),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(child: Icon(Icons.error)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    // Placeholder for video content - implement with video_player package
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.play_circle_filled, size: 50),
          ),
        ),
      ),
    );
  }

  Widget _buildSpiritualTags() {
    final tags = widget.post['spiritualTags'] as List<dynamic>? ?? [];
    if (tags.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 0),
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: tags
            .map((tag) => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '#$tag',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildActionsBar() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          // Spiritual Reactions Button
          _buildSpiritualReactions(),

          SizedBox(width: 6.w),

          // Comments Button
          GestureDetector(
            onTap: () => widget.onComment(widget.post['id']),
            child: Row(
              children: [
                Icon(
                  Icons.comment_outlined,
                  size: 5.w,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${widget.post['commentsCount'] ?? 0}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Save Button
          GestureDetector(
            onTap: () => widget.onSave(widget.post['id']),
            child: Icon(
              Icons.bookmark_border,
              size: 5.w,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpiritualReactions() {
    final reactions = widget.post['reactions'] as Map<String, dynamic>? ?? {};

    return ReactionButton<String>(
      itemSize: Size(8.w, 8.w),
      onReactionChanged: (reaction) {
        if (reaction?.value != null) {
          widget.onReaction(widget.post['id'], reaction!.value!);
        }
      },
      reactions: [
        Reaction<String>(
          value: 'gratitude',
          title: Text('Gratitude'),
          previewIcon: Text('🙏', style: TextStyle(fontSize: 6.w)),
          icon: Text('🙏', style: TextStyle(fontSize: 4.w)),
        ),
        Reaction<String>(
          value: 'love',
          title: Text('Love'),
          previewIcon: Text('💚', style: TextStyle(fontSize: 6.w)),
          icon: Text('💚', style: TextStyle(fontSize: 4.w)),
        ),
        Reaction<String>(
          value: 'light',
          title: Text('Light'),
          previewIcon: Text('✨', style: TextStyle(fontSize: 6.w)),
          icon: Text('✨', style: TextStyle(fontSize: 4.w)),
        ),
      ],
      selectedReaction: null, // Track user's current reaction
      child: Row(
        children: [
          Icon(
            Icons.favorite_border,
            size: 5.w,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 1.w),
          Text(
            _getTotalReactions(reactions).toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsPreview() {
    final commentsCount = widget.post['commentsCount'] as int? ?? 0;
    if (commentsCount == 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
      child: GestureDetector(
        onTap: () => widget.onComment(widget.post['id']),
        child: Text(
          commentsCount == 1
              ? 'View 1 comment'
              : 'View all $commentsCount comments',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }

  int _getTotalReactions(Map<String, dynamic> reactions) {
    return reactions.values
        .fold<int>(0, (sum, count) => sum + (count as int? ?? 0));
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 7).floor()}w';
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'save':
        widget.onSave(widget.post['id']);
        break;
      case 'hide':
        // Implement hide functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post hidden from your feed')),
        );
        break;
      case 'report':
        widget.onReport(widget.post['id']);
        break;
    }
  }

  void _showImageFullScreen(String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}