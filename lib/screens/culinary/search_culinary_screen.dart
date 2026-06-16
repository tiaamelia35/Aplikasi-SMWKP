import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/screens/culinary/advanced_filter_screen.dart';
import 'package:smwkp_culinary_tourism/services/restaurant_service.dart';
import 'package:smwkp_culinary_tourism/models/restaurant_model.dart';
import 'package:smwkp_culinary_tourism/widgets/common/common_widgets.dart';
import 'package:smwkp_culinary_tourism/screens/restaurant/restaurant_detail_screen.dart';

class SearchCulinaryScreen extends StatefulWidget {
  const SearchCulinaryScreen({Key? key}) : super(key: key);

  @override
  State<SearchCulinaryScreen> createState() => _SearchCulinaryScreenState();
}

class _SearchCulinaryScreenState extends State<SearchCulinaryScreen> {
  final _restaurantService = RestaurantService();
  final _searchController = TextEditingController();
  String _selectedCuisine = '';
  List<String> cuisineTypes = [
    'Pempek',
    'Tekwan',
    'Palembang Kering',
    'Makanan Tradisional',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.searchCulinary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              final filters = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdvancedFilterScreen(),
                ),
              );

              if (filters != null && mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilteredRestaurantsScreen(filters: filters),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Cuisine Filter
            Text(
              'Filter Jenis Makanan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: cuisineTypes.map((cuisine) {
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: FilterChip(
                      label: Text(cuisine),
                      selected: _selectedCuisine == cuisine,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCuisine = selected ? cuisine : '';
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Search Results
            Text(
              'Hasil Pencarian',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            FutureBuilder<List<RestaurantModel>>(
              future: _restaurantService.getRestaurants(
                searchQuery: _searchController.text,
                cuisineType: _selectedCuisine.isEmpty ? null : _selectedCuisine,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                }

                if (snapshot.hasError) {
                  return ErrorWidget(
                    message: 'Gagal memuat data',
                    onRetry: () => setState(() {}),
                  );
                }

                final restaurants = snapshot.data ?? [];

                if (restaurants.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: Text('Tidak ada restoran yang cocok'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return RestaurantCard(
                      name: restaurant.name,
                      address: restaurant.address,
                      rating: restaurant.averageRating,
                      reviewCount: restaurant.reviewCount,
                      cuisineTypes: restaurant.cuisineTypes,
                      isVerified: restaurant.status == RestaurantStatus.verified,
                      isHalalCertified: restaurant.certificationStatus == CertificationStatus.halal,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RestaurantDetailScreen(
                              restaurantId: restaurant.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
