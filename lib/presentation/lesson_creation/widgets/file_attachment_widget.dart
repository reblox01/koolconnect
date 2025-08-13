import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FileAttachmentWidget extends StatefulWidget {
  final List<Map<String, dynamic>> attachedFiles;
  final Function(Map<String, dynamic>) onFileAdded;
  final Function(int) onFileRemoved;

  const FileAttachmentWidget({
    Key? key,
    required this.attachedFiles,
    required this.onFileAdded,
    required this.onFileRemoved,
  }) : super(key: key);

  @override
  State<FileAttachmentWidget> createState() => _FileAttachmentWidgetState();
}

class _FileAttachmentWidgetState extends State<FileAttachmentWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _showCameraPreview = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!kIsWeb) {
        final hasPermission = await _requestCameraPermission();
        if (!hasPermission) return;
      }

      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        final camera = kIsWeb
            ? _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.front,
                orElse: () => _cameras.first)
            : _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.back,
                orElse: () => _cameras.first);

        _cameraController = CameraController(
            camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

        await _cameraController!.initialize();
        await _applySettings();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      // Silent fail - camera not available
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;
    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.auto);
      }
    } catch (e) {
      // Settings not supported on this platform
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      final fileData = {
        'name': 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
        'path': photo.path,
        'type': 'image',
        'size': kIsWeb ? 0 : await File(photo.path).length(),
        'isImage': true,
      };

      widget.onFileAdded(fileData);
      setState(() {
        _showCameraPreview = false;
      });
    } catch (e) {
      // Handle capture error silently
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final fileData = {
          'name': image.name,
          'path': image.path,
          'type': 'image',
          'size': kIsWeb ? 0 : await File(image.path).length(),
          'isImage': true,
        };
        widget.onFileAdded(fileData);
      }
    } catch (e) {
      // Handle gallery error silently
    }
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'ppt', 'pptx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final fileData = {
          'name': file.name,
          'path': file.path ?? '',
          'type': _getFileType(file.extension ?? ''),
          'size': file.size,
          'isImage': false,
          'bytes': kIsWeb ? file.bytes : null,
        };
        widget.onFileAdded(fileData);
      }
    } catch (e) {
      // Handle file picker error silently
    }
  }

  String _getFileType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'PDF Document';
      case 'doc':
      case 'docx':
        return 'Word Document';
      case 'ppt':
      case 'pptx':
        return 'PowerPoint';
      case 'txt':
        return 'Text File';
      default:
        return 'Document';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  Widget _buildFilePreview(Map<String, dynamic> file, int index) {
    return Container(
      width: 25.w,
      margin: EdgeInsets.only(right: 3.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lightTheme.colorScheme.outline),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              ),
              child: file['isImage'] == true
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8.0)),
                      child: kIsWeb
                          ? Container(
                              color: AppTheme
                                  .lightTheme.colorScheme.surfaceContainerHighest,
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'image',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 32,
                                ),
                              ),
                            )
                          : Image.file(
                              File(file['path']),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppTheme
                                      .lightTheme.colorScheme.surfaceContainerHighest,
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'image',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 32,
                                    ),
                                  ),
                                );
                              },
                            ),
                    )
                  : Center(
                      child: CustomIconWidget(
                        iconName: _getDocumentIcon(file['name']),
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 32,
                      ),
                    ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file['name'],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatFileSize(file['size']),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onLongPress: () => widget.onFileRemoved(index),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.errorContainer,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(8.0)),
              ),
              child: Center(
                child: Text(
                  'Hold to remove',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onErrorContainer,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDocumentIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'doc':
      case 'docx':
        return 'description';
      case 'ppt':
      case 'pptx':
        return 'slideshow';
      case 'txt':
        return 'text_snippet';
      default:
        return 'insert_drive_file';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickDocument,
                icon: CustomIconWidget(
                  iconName: 'attach_file',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('Document'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickFromGallery,
                icon: CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('Gallery'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isCameraInitialized
                    ? () => setState(() => _showCameraPreview = true)
                    : null,
                icon: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: _isCameraInitialized
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                label: Text('Camera'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Camera preview
        if (_showCameraPreview &&
            _isCameraInitialized &&
            _cameraController != null)
          Container(
            height: 30.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border:
                  Border.all(color: AppTheme.lightTheme.colorScheme.outline),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Stack(
                children: [
                  CameraPreview(_cameraController!),
                  Positioned(
                    bottom: 2.h,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          heroTag: "cancel_camera",
                          onPressed: () =>
                              setState(() => _showCameraPreview = false),
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.surface
                              .withValues(alpha: 0.9),
                          child: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: "capture_photo",
                          onPressed: _capturePhoto,
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          child: CustomIconWidget(
                            iconName: 'camera',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // File previews
        if (widget.attachedFiles.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Container(
            height: 20.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.attachedFiles.length,
              itemBuilder: (context, index) {
                return _buildFilePreview(widget.attachedFiles[index], index);
              },
            ),
          ),
        ],

        if (widget.attachedFiles.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'cloud_upload',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 32,
                ),
                SizedBox(height: 1.h),
                Text(
                  'No attachments added',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Add documents, images, or take photos to enhance your lesson',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
