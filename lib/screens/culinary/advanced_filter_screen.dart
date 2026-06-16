import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/services/restaurant_service.dart';
import 'package:smwkp_culinary_tourism/models/restaurant_model.dart';
import 'package:smwkp_culinary_tourism/services/maps_service.dart';
import 'package:smwkp_culinary_tourism/widgets/common/common_widgets.dart';
import 'package:smwkp_culinary_tourism/screens/restaurant/restaurant_detail_screen.dart';
import 'package:geolocator/geolocator.dart';

class AdvancedFilterScreen extends StatefulWidget {
  const AdvancedFilterScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedFilterScreen> createState() => _AdvancedFilterScreenState();
}

class _AdvancedFilterScreenState extends State<AdvancedFilterScreen> {
  final _mapsService = MapsService();

  // Filter values
  String _searchQuery = '';
  RangeValues _priceRange = const RangeValues(1, 5);
  // distance tracking removed (unused)
  double _selectedRadius = 5.0; // Default 5 km
  int _minRating = 0;
  List<String> _selectedCuisines = [];
  bool _verifiedOnly = false;
  bool _halalOnly = false;
  bool _openNow = false;

  // Location
  Position? _userPosition;

  final _cuisineTypes = [
    'Pempek',
    'Tekwan',
    'Palembang Kering',
    'Nasi Kuning',
    'Makanan Tradisional',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    try {
      _userPosition = await _mapsService.getCurrentLocation();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get location: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Filter Lanjutan',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Price range filter
            Text(
              'Harga Per Porsi',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            RangeSlider(
              values: _priceRange,
              min: 1,
              max: 5,
              divisions: 4,
              labels: RangeLabels(
                '\$${_priceRange.start.toInt()}',
                '\$${_priceRange.end.toInt()}',
              ),
              onChanged: (RangeValues values) {
                setState(() => _priceRange = values);
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Minimum rating filter
            Text(
              'Minimum Rating: ${_minRating.toStringAsFixed(0)} ⭐',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Slider(
              value: _minRating.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              label: _minRating.toStringAsFixed(1),
              onChanged: (value) {
                setState(() => _minRating = value.toInt());
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Distance filter
            if (_userPosition != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jarak Maksimal: ${_selectedRadius.toStringAsFixed(1)} km',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Slider(
                    value: _selectedRadius,
                    min: 0.5,
                    max: 50,
                    divisions: 49,
                    label: '${_selectedRadius.toStringAsFixed(1)} km',
                    onChanged: (value) {
                      setState(() => _selectedRadius = value);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),

            // Cuisine types
            Text(
              'Jenis Makanan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              children: _cuisineTypes.map((cuisine) {
                return FilterChip(
                  label: Text(cuisine),
                  selected: _selectedCuisines.contains(cuisine),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCuisines.add(cuisine);
                      } else {
                        _selectedCuisines.remove(cuisine);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Additional filters
            Text(
              'Filter Tambahan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            CheckboxListTile(
              title: const Text('Hanya Restoran Terverifikasi'),
              value: _verifiedOnly,
              onChanged: (value) {
                setState(() => _verifiedOnly = value ?? false);
              },
              activeColor: AppColors.primary,
            ),
            CheckboxListTile(
              title: const Text('Hanya Restoran Bersertifikat Halal'),
              value: _halalOnly,
              onChanged: (value) {
                setState(() => _halalOnly = value ?? false);
              },
              activeColor: AppColors.primary,
            ),
            CheckboxListTile(
              title: const Text('Buka Sekarang'),
              value: _openNow,
              onChanged: (value) {
                setState(() => _openNow = value ?? false);
              },
              activeColor: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Apply filters button
            CustomButton(
              label: 'Terapkan Filter',
              onPressed: () {
                Navigator.pop(context, {
                  'searchQuery': _searchQuery,
                  'priceRange': _priceRange,
                  'minRating': _minRating,
                  'cuisines': _selectedCuisines,
                  'radius': _selectedRadius,
                  'verifiedOnly': _verifiedOnly,
                  'halalOnly': _halalOnly,
                  'openNow': _openNow,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Screen untuk menampilkan hasil filter
class FilteredRestaurantsScreen extends StatefulWidget {
  final Map<String, dynamic> filters;

  const FilteredRestaurantsScreen({
    Key? key,
    required this.filters,
  }) : super(key: key);

  @override
  State<FilteredRestaurantsScreen> createState() =>
      _FilteredRestaurantsScreenState();
}

class _FilteredRestaurantsScreenState extends State<FilteredRestaurantsScreen> {
  final _restaurantService = RestaurantService();
  late Future<List<RestaurantModel>> _futureRestaurants;

  @override
  void initState() {
    super.initState();
    _futureRestaurants = _restaurantService.getRestaurants();
  }

  List<RestaurantModel> _applyFilters(List<RestaurantModel> restaurants) {
    return restaurants.where((restaurant) {
      // Search query
      if (widget.filters['searchQuery'] != null &&
          widget.filters['searchQuery']!.isNotEmpty &&
          !restaurant.name.toLowerCase().contains(
              widget.filters['searchQuery']!.toLowerCase())) {
        return false;
      }

      // Price range
      final priceRange = widget.filters['priceRange'] as RangeValues?;
      if (priceRange != null &&
          (restaurant.priceRange < priceRange.start ||
              restaurant.priceRange > priceRange.end)) {
        return false;
      }

      // Minimum rating
      final minRating = widget.filters['minRating'] as int?;
      if (minRating != null && restaurant.averageRating < minRating) {
        return false;
      }

      // Verified only
      if (widget.filters['verifiedOnly'] == true &&
          restaurant.status != RestaurantStatus.verified) {
        return false;
      }

      // Halal only
      if (widget.filters['halalOnly'] == true &&
          restaurant.certificationStatus != CertificationStatus.halal) {
        return false;
      }

      // Cuisine types
      final cuisines = widget.filters['cuisines'] as List<String>?;
      if (cuisines != null && cuisines.isNotEmpty) {
        final hasCuisine = restaurant.cuisineTypes
            .any((type) => cuisines.contains(type));
        if (!hasCuisine) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hasil Filter',
        showBackButton: true,
      ),
      body: FutureBuilder<List<RestaurantModel>>(
        future: _futureRestaurants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (snapshot.hasError) {
            return ErrorWidget(
              message: 'Gagal memuat restoran',
              onRetry: () => setState(() {
                _futureRestaurants = _restaurantService.getRestaurants();
              }),
            );
          }

          final allRestaurants = snapshot.data ?? [];
          final filteredRestaurants = _applyFilters(allRestaurants);

          if (filteredRestaurants.isEmpty) {
            return const Center(
              child: Text('Tidak ada restoran yang sesuai dengan filter'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: filteredRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = filteredRestaurants[index];
              return RestaurantCard(
                name: restaurant.name,
                address: restaurant.address,
                rating: restaurant.averageRating,
                reviewCount: restaurant.reviewCount,
                cuisineTypes: restaurant.cuisineTypes,
                isVerified: restaurant.status == RestaurantStatus.verified,
                isHalalCertified:
                    restaurant.certificationStatus == CertificationStatus.halal,
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
    );
  }
}
