import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
// removed unused import: restaurant_service
import 'package:smwkp_culinary_tourism/services/image_upload_service.dart';
import 'package:smwkp_culinary_tourism/widgets/common/common_widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewSubmissionScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const ReviewSubmissionScreen({
    Key? key,
    required this.restaurantId,
    required this.restaurantName,
  }) : super(key: key);

  @override
  State<ReviewSubmissionScreen> createState() => _ReviewSubmissionScreenState();
}

class _ReviewSubmissionScreenState extends State<ReviewSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUploadService = ImageUploadService();
  // final _restaurantService = RestaurantService(); // unused for now

  double _rating = 5.0;
  List<File> _selectedImages = [];
  bool _isSubmitting = false;

  // Sub-ratings
  double _foodQualityRating = 5.0;
  double _serviceRating = 5.0;
  double _cleanlinessRating = 5.0;
  double _priceRating = 5.0;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final images = await _imageUploadService.pickMultipleImages();

      if (images.length > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 5 images allowed')),
        );
        return;
      }

      for (final image in images) {
        final isValid = _imageUploadService.isValidImageFile(image);
        if (!isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid image format or size (max 10MB)'),
            ),
          );
          return;
        }
      }

      setState(() => _selectedImages = images);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: ${e.toString()}')),
      );
    }
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        // TODO: Implement actual submission logic with your API
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review submitted successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit review: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tulis Ulasan',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant name
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Restoran',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: AppFontSize.sm,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      widget.restaurantName,
                      style: const TextStyle(
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Overall rating
              Text(
                'Rating Keseluruhan',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 50,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: AppColors.warning,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() => _rating = rating);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Sub-ratings
              Text(
                'Rating Detail',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildSubRatingItem(
                'Kualitas Makanan',
                _foodQualityRating,
                (value) => setState(() => _foodQualityRating = value),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildSubRatingItem(
                'Layanan',
                _serviceRating,
                (value) => setState(() => _serviceRating = value),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildSubRatingItem(
                'Kebersihan',
                _cleanlinessRating,
                (value) => setState(() => _cleanlinessRating = value),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildSubRatingItem(
                'Harga',
                _priceRating,
                (value) => setState(() => _priceRating = value),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              CustomTextField(
                label: 'Judul Ulasan',
                hintText: 'Ringkas ulasan Anda',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  if (value.length < 5) {
                    return 'Judul minimal 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Content
              CustomTextField(
                label: 'Isi Ulasan',
                hintText: 'Jelaskan pengalaman Anda...',
                controller: _contentController,
                maxLines: 5,
                minLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi ulasan tidak boleh kosong';
                  }
                  if (value.length < 20) {
                    return 'Isi ulasan minimal 20 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Images
              Text(
                'Foto (Opsional, Maks 5)',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.image),
                      label: const Text('Pilih Foto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: Text(
                      '${_selectedImages.length}/5',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (_selectedImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.md),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppBorderRadius.md),
                              child: Image.file(
                                _selectedImages[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: AppColors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),

              // Submit button
              CustomButton(
                label: 'Kirim Ulasan',
                isLoading: _isSubmitting,
                onPressed: _submitReview,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubRatingItem(
    String label,
    double rating,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '${rating.toStringAsFixed(1)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Slider(
          value: rating,
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
