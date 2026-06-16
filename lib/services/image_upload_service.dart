import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:smwkp_culinary_tourism/services/api_client.dart';

class ImageUploadService {
  final ImagePicker _imagePicker = ImagePicker();

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  // Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  // Pick multiple images
  Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      return images.map((image) => File(image.path)).toList();
    } catch (e) {
      throw Exception('Failed to pick images: $e');
    }
  }

  // Upload single image to server
  Future<Map<String, dynamic>> uploadRestaurantImage({
    required File imageFile,
    required String restaurantId,
  }) async {
    try {
      final result = await apiClient.uploadFile<Map<String, dynamic>>(
        '/restaurants/$restaurantId/images',
        filePath: imageFile.path,
        additionalData: {
          'restaurantId': restaurantId,
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return result;
    } catch (e) {
      throw Exception('Failed to upload restaurant image: $e');
    }
  }

  // Upload multiple images
  Future<Map<String, dynamic>> uploadMultipleRestaurantImages({
    required List<File> imageFiles,
    required String restaurantId,
  }) async {
    try {
      final filePaths = imageFiles.map((f) => f.path).toList();
      final result = await apiClient.uploadFiles<Map<String, dynamic>>(
        '/restaurants/$restaurantId/images/bulk',
        filePaths: filePaths,
        fileKey: 'images',
        additionalData: {
          'restaurantId': restaurantId,
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return result;
    } catch (e) {
      throw Exception('Failed to upload restaurant images: $e');
    }
  }

  // Upload profile image
  Future<Map<String, dynamic>> uploadProfileImage({
    required File imageFile,
    required String userId,
  }) async {
    try {
      final result = await apiClient.uploadFile<Map<String, dynamic>>(
        '/users/$userId/profile-image',
        filePath: imageFile.path,
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return result;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Upload review images
  Future<Map<String, dynamic>> uploadReviewImages({
    required List<File> imageFiles,
    required String reviewId,
  }) async {
    try {
      final filePaths = imageFiles.map((f) => f.path).toList();
      final result = await apiClient.uploadFiles<Map<String, dynamic>>(
        '/reviews/$reviewId/images',
        filePaths: filePaths,
        fileKey: 'images',
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return result;
    } catch (e) {
      throw Exception('Failed to upload review images: $e');
    }
  }

  // Delete image
  Future<void> deleteImage({required String imageUrl}) async {
    try {
      await apiClient.delete<Map<String, dynamic>>(
        '/images/delete',
        queryParameters: {'url': imageUrl},
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Get file size in MB
  double getFileSizeInMB(File file) {
    return file.lengthSync() / (1024 * 1024);
  }

  // Validate image file
  bool isValidImageFile(File file) {
    const maxSizeMB = 10.0;
    const validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

    final fileSizeMB = getFileSizeInMB(file);
    if (fileSizeMB > maxSizeMB) {
      return false;
    }

    final fileExtension = file.path.split('.').last.toLowerCase();
    if (!validExtensions.contains(fileExtension)) {
      return false;
    }

    return true;
  }

  // Compress image path
  Future<File?> compressImage(File imageFile) async {
    try {
      // TODO: Implement image compression using image_cropper or similar
      // For now, return the original file
      return imageFile;
    } catch (e) {
      throw Exception('Failed to compress image: $e');
    }
  }
}
