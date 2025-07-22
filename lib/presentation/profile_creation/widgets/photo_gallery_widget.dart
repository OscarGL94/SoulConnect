import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoGalleryWidget extends StatefulWidget {
  final Function(List<String>) onPhotosChanged;
  final List<String> initialPhotos;

  const PhotoGalleryWidget({
    Key? key,
    required this.onPhotosChanged,
    this.initialPhotos = const [],
  }) : super(key: key);

  @override
  State<PhotoGalleryWidget> createState() => _PhotoGalleryWidgetState();
}

class _PhotoGalleryWidgetState extends State<PhotoGalleryWidget> {
  List<String> _photos = [];
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.initialPhotos);
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) return;

      final camera = kIsWeb
          ? _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras!.first)
          : _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras!.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      // Silent fail - camera not available
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {}

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {}
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_isCameraInitialized) return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      _addPhoto(photo.path);
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _addPhoto(image.path);
      }
    } catch (e) {
      // Silent fail
    }
  }

  void _addPhoto(String photoPath) {
    if (_photos.length < 6) {
      setState(() {
        _photos.add(photoPath);
      });
      widget.onPhotosChanged(_photos);
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
    widget.onPhotosChanged(_photos);
  }

  void _reorderPhotos(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final String photo = _photos.removeAt(oldIndex);
      _photos.insert(newIndex, photo);
    });
    widget.onPhotosChanged(_photos);
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Tomar foto',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _capturePhoto();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Elegir de galería',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fotos del perfil',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Agrega hasta 6 fotos que reflejen tu esencia espiritual',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _photos.length + (_photos.length < 6 ? 1 : 0),
            onReorder: _reorderPhotos,
            buildDefaultDragHandles: false,
            itemBuilder: (context, index) {
              if (index == _photos.length) {
                return _buildAddPhotoCard(index);
              }
              return _buildPhotoCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard(int index) {
    final isMainPhoto = index == 0;
    final cardWidth = isMainPhoto ? 40.w : 30.w;

    return Container(
      key: ValueKey(_photos[index]),
      width: cardWidth,
      margin: EdgeInsets.only(right: 3.w),
      child: ReorderableDragStartListener(
        index: index,
        child: Stack(
          children: [
            Container(
              width: cardWidth,
              height: 25.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isMainPhoto
                    ? Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      )
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl: _photos[index],
                  width: cardWidth,
                  height: 25.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isMainPhoto)
              Positioned(
                top: 1.h,
                left: 2.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Principal',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 1.h,
              right: 2.w,
              child: GestureDetector(
                onTap: () => _removePhoto(index),
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onError,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPhotoCard(int index) {
    return Container(
      key: ValueKey('add_photo_$index'),
      width: 30.w,
      margin: EdgeInsets.only(right: 3.w),
      child: GestureDetector(
        onTap: _showPhotoOptions,
        child: Container(
          width: 30.w,
          height: 25.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'add_a_photo',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 32,
              ),
              SizedBox(height: 1.h),
              Text(
                'Agregar foto',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
