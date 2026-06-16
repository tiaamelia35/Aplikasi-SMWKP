import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/screens/restaurant/review_submission_screen.dart';
import 'package:smwkp_culinary_tourism/models/restaurant_model.dart';
import 'package:smwkp_culinary_tourism/models/review_model.dart';
import 'package:smwkp_culinary_tourism/services/restaurant_service.dart';
import 'package:smwkp_culinary_tourism/widgets/common/common_widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RestaurantDetailScreen extends StatefulWidget {

  const RestaurantDetailScreen({
    required this.restaurantId, super.key,
  });
  final String restaurantId;

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final _restaurantService = RestaurantService();
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.restaurantDetail,
        showBackButton: true,
      ),
      body: FutureBuilder<RestaurantModel>(
        future: _restaurantService.getRestaurantById(widget.restaurantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (snapshot.hasError) {
            return ErrorWidget(
              message: 'Gagal memuat detail restoran',
              onRetry: () => setState(() {}),
            );
          }

          final restaurant = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Image
                Container(
                  width: double.infinity,
                  height: 250,
                  color: AppColors.lightGrey,
                  child: restaurant.imageUrls.isNotEmpty
                      // ignore: lines_longer_than_80_chars
                      ? Image.network(restaurant.imageUrls.first, fit: BoxFit.cover)
                      // ignore: lines_longer_than_80_chars
                      : const Icon(Icons.restaurant, size: 80, color: AppColors.grey),
                ),

                // Restaurant Info
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: const TextStyle(
                                    fontSize: AppFontSize.xl,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Wrap(
                                  spacing: AppSpacing.sm,
                                  children: [
                                    // ignore: lines_longer_than_80_chars
                                    if (restaurant.status == RestaurantStatus.verified)
                                      const Chip(
                                        label: Text('Terverifikasi'),
                                        backgroundColor: AppColors.success,
                                        // ignore: lines_longer_than_80_chars
                                        labelStyle: TextStyle(color: AppColors.white),
                                      ),
                                    // ignore: lines_longer_than_80_chars
                                    if (restaurant.certificationStatus == CertificationStatus.halal)
                                      const Chip(
                                        label: Text('Halal'),
                                        backgroundColor: AppColors.primary,
                                        // ignore: lines_longer_than_80_chars
                                        labelStyle: TextStyle(color: AppColors.white),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                // ignore: lines_longer_than_80_chars
                                const SnackBar(content: Text('Ditambahkan ke favorit')),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Rating
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: restaurant.averageRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: AppColors.warning,
                            ),
                            onRatingUpdate: (rating) {},
                            ignoreGestures: true,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            // ignore: lines_longer_than_80_chars
                            '${restaurant.averageRating} (${restaurant.reviewCount} reviews)',
                            style: const TextStyle(
                              fontSize: AppFontSize.sm,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Address and Contact
                      _buildInfoRow(Icons.location_on, restaurant.address),
                      const SizedBox(height: AppSpacing.md),
                      _buildInfoRow(Icons.phone, restaurant.phone ?? '-'),
                      const SizedBox(height: AppSpacing.md),
                      _buildInfoRow(Icons.email, restaurant.email ?? '-'),
                      const SizedBox(height: AppSpacing.lg),

                      // Description
                      Text(
                        'Deskripsi',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        restaurant.description,
                        style: const TextStyle(
                          fontSize: AppFontSize.sm,
                          color: AppColors.darkGrey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Cuisine Types
                      Text(
                        'Jenis Makanan',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.md,
                        children: restaurant.cuisineTypes
                            .map(
                              (type) => Chip(
                                label: Text(type),
                                backgroundColor: AppColors.lightGrey,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Tabs
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: const [
                                Tab(text: 'Ulasan'),
                                Tab(text: 'Reservasi'),
                              ],
                              onTap: (index) {
                                setState(() => _selectedTab = index);
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            if (_selectedTab == 0)
                              _buildReviewsSection(restaurant)
                            else
                              _buildReservationSection(restaurant),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

  Widget _buildInfoRow(IconData icon, String value) => Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: AppFontSize.sm),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

  Widget _buildReviewsSection(RestaurantModel restaurant) => FutureBuilder<List<ReviewModel>>(
      future: _restaurantService.getRestaurantReviews(widget.restaurantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }

        if (snapshot.hasError) {
          return const ErrorWidget(message: 'Gagal memuat ulasan');
        }

        final reviews = snapshot.data ?? [];

        if (reviews.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Center(child: Text(AppStrings.noReviews)),
          );
        }

        return Column(
          children: [
            ...reviews.map((review) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        RatingBar.builder(
                          initialRating: review.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: AppColors.warning,
                          ),
                          onRatingUpdate: (rating) {},
                          ignoreGestures: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      review.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      review.content,
                      style: const TextStyle(color: AppColors.darkGrey),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: AppSpacing.md),
            CustomButton(
              label: 'Tambah Ulasan',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // ignore: lines_longer_than_80_chars
                    builder: (context) => ReviewSubmissionScreen(
                      restaurantId: widget.restaurantId,
                      restaurantName: restaurant.name,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );

  Widget _buildReservationSection(RestaurantModel restaurant) => Column(
      children: [
        const Text(
          'Buat Reservasi Meja',
          style: TextStyle(
            fontSize: AppFontSize.md,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        CustomButton(
          label: 'Pesan Meja Sekarang',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur reservasi segera hadir')),
            );
          },
        ),
      ],
    );
}
