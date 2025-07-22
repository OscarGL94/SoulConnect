
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import './widgets/media_attachment_widget.dart';
import './widgets/post_privacy_widget.dart';
import './widgets/spiritual_tags_widget.dart';
import './widgets/writing_prompts_widget.dart';

/// Create Post Screen - Enables spiritual content sharing with media upload
/// Features: Text input, photo/video attachment, spiritual tags, privacy settings
/// Mobile-first creation interface with keyboard avoidance and draft saving
class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Media handling
  final ImagePicker _imagePicker = ImagePicker();
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;

  // Post data
  XFile? _selectedImage;
  XFile? _selectedVideo;
  List<String> _selectedTags = [];
  String _privacySetting = 'community'; // 'community' or 'matches'
  bool _isPosting = false;
  bool _isDraft = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadDraftContent();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
    }
  }

  Future<void> _loadDraftContent() async {
    // Implement draft loading from SharedPreferences
    setState(() => _isDraft = false);
  }

  Future<void> _saveDraft() async {
    if (_contentController.text.trim().isEmpty &&
        _selectedImage == null &&
        _selectedVideo == null) return;

    // Implement draft saving to SharedPreferences
    setState(() => _isDraft = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Draft saved'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    try {
      if (!kIsWeb && source == ImageSource.camera) {
        final permission = await Permission.camera.request();
        if (!permission.isGranted) {
          _showPermissionDialog('Camera');
          return;
        }
      }

      if (!kIsWeb && source == ImageSource.gallery) {
        final permission = await Permission.photos.request();
        if (!permission.isGranted) {
          _showPermissionDialog('Photo Library');
          return;
        }
      }

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _selectedVideo = null; // Clear video if image selected
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to select image: $e');
    }
  }

  Future<void> _handleVideoSelection() async {
    try {
      if (!kIsWeb) {
        final permission = await Permission.camera.request();
        if (!permission.isGranted) {
          _showPermissionDialog('Camera');
          return;
        }
      }

      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 2),
      );

      if (video != null) {
        setState(() {
          _selectedVideo = video;
          _selectedImage = null; // Clear image if video selected
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to record video: $e');
    }
  }

  void _removeMedia() {
    setState(() {
      _selectedImage = null;
      _selectedVideo = null;
    });
  }

  void _onTagsChanged(List<String> tags) {
    setState(() => _selectedTags = tags);
  }

  void _onPrivacyChanged(String privacy) {
    setState(() => _privacySetting = privacy);
  }

  Future<void> _publishPost() async {
    if (_contentController.text.trim().isEmpty &&
        _selectedImage == null &&
        _selectedVideo == null) {
      _showErrorSnackBar('Please add some content to your post');
      return;
    }

    setState(() => _isPosting = true);

    try {
      // Show preview dialog first
      final shouldPublish = await _showPreviewDialog();
      if (!shouldPublish) {
        setState(() => _isPosting = false);
        return;
      }

      // Simulate API call to publish post
      await Future.delayed(const Duration(seconds: 2));

      // Clear form data
      _contentController.clear();
      _selectedImage = null;
      _selectedVideo = null;
      _selectedTags.clear();
      _privacySetting = 'community';
      _isDraft = false;

      setState(() => _isPosting = false);

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Post published successfully! ✨'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => _isPosting = false);
      _showErrorSnackBar('Failed to publish post: $e');
    }
  }

  Future<bool> _showPreviewDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Preview Post'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_contentController.text.trim().isNotEmpty) ...[
                    Text(
                      'Content:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 1.h),
                    Text(_contentController.text.trim()),
                    SizedBox(height: 2.h),
                  ],
                  if (_selectedTags.isNotEmpty) ...[
                    Text(
                      'Tags:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 1.w,
                      children: _selectedTags
                          .map((tag) => Chip(
                                label: Text('#$tag'),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 2.h),
                  ],
                  Text(
                    'Visibility: ${_privacySetting == 'community' ? 'Everyone in community' : 'Mutual matches only'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Publish'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showPermissionDialog(String permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permission Permission Required'),
        content: Text(
            'This app needs $permission permission to capture and share your spiritual moments.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            if (_contentController.text.trim().isNotEmpty ||
                _selectedImage != null ||
                _selectedVideo != null) {
              await _saveDraft();
            }
            if (mounted) Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          if (_isDraft)
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: Chip(
                label: const Text('Draft'),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.2),
              ),
            ),
          TextButton(
            onPressed: _isPosting ? null : _publishPost,
            child: _isPosting
                ? SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Publish',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(4.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Writing Prompts
                  WritingPromptsWidget(
                    onPromptSelected: (prompt) {
                      _contentController.text = prompt;
                      _contentFocusNode.requestFocus();
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Content Input
                  TextField(
                    controller: _contentController,
                    focusNode: _contentFocusNode,
                    maxLines: null,
                    minLines: 6,
                    maxLength: 2000,
                    decoration: InputDecoration(
                      hintText:
                          'Share your spiritual reflection, wisdom, or experience...',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      counterStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) => setState(() {}),
                  ),

                  SizedBox(height: 3.h),

                  // Media Attachment
                  MediaAttachmentWidget(
                    selectedImage: _selectedImage,
                    selectedVideo: _selectedVideo,
                    onImageCamera: () =>
                        _handleImageSelection(ImageSource.camera),
                    onImageGallery: () =>
                        _handleImageSelection(ImageSource.gallery),
                    onVideoRecord: _handleVideoSelection,
                    onRemoveMedia: _removeMedia,
                  ),

                  SizedBox(height: 3.h),

                  // Spiritual Tags
                  SpiritualTagsWidget(
                    selectedTags: _selectedTags,
                    onTagsChanged: _onTagsChanged,
                  ),

                  SizedBox(height: 3.h),

                  // Privacy Settings
                  PostPrivacyWidget(
                    selectedPrivacy: _privacySetting,
                    onPrivacyChanged: _onPrivacyChanged,
                  ),

                  SizedBox(height: 10.h), // Extra space for keyboard
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
