import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

/// Media Attachment Widget - Handles photo and video selection with preview
/// Features: Camera/gallery selection, preview functionality, editing options
class MediaAttachmentWidget extends StatelessWidget {
  final XFile? selectedImage;
  final XFile? selectedVideo;
  final VoidCallback onImageCamera;
  final VoidCallback onImageGallery;
  final VoidCallback onVideoRecord;
  final VoidCallback onRemoveMedia;

  const MediaAttachmentWidget({
    super.key,
    this.selectedImage,
    this.selectedVideo,
    required this.onImageCamera,
    required this.onImageGallery,
    required this.onVideoRecord,
    required this.onRemoveMedia,
  });

  @override
  Widget build(BuildContext context) {
    final hasMedia = selectedImage != null || selectedVideo != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Media',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 2.h),

        if (hasMedia) ...[
          _buildMediaPreview(context),
          SizedBox(height: 2.h),
        ],

        // Media Selection Buttons
        Row(
          children: [
            Expanded(
              child: _MediaButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onPressed: onImageCamera,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _MediaButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onPressed: onImageGallery,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _MediaButton(
                icon: Icons.videocam,
                label: 'Video',
                onPressed: onVideoRecord,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 25.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: selectedImage != null
                ? _buildImagePreview()
                : _buildVideoPreview(context),
          ),

          // Remove Media Button
          Positioned(
            top: 2.w,
            right: 2.w,
            child: GestureDetector(
              onTap: onRemoveMedia,
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 5.w,
                ),
              ),
            ),
          ),

          // Media Type Indicator
          Positioned(
            bottom: 2.w,
            left: 2.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selectedImage != null ? Icons.image : Icons.videocam,
                    color: Colors.white,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    selectedImage != null ? 'Photo' : 'Video',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    if (selectedImage == null) return const SizedBox.shrink();

    return kIsWeb
        ? FutureBuilder<Uint8List>(
            future: selectedImage!.readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        : Image.file(
            File(selectedImage!.path),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          );
  }

  Widget _buildVideoPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_circle_filled,
            size: 15.w,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Video Preview',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _MediaButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
