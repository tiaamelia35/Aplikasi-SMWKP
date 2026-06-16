import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/services/restaurant_service.dart';
import 'package:smwkp_culinary_tourism/models/restaurant_model.dart';
import 'package:smwkp_culinary_tourism/widgets/common/common_widgets.dart';
import 'package:smwkp_culinary_tourism/screens/culinary/search_culinary_screen.dart';
import 'package:smwkp_culinary_tourism/screens/account/account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _restaurantService = RestaurantService();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      const SearchCulinaryScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.appName,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.darkRed],
              ),
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang',
                  style: TextStyle(
                    fontSize: AppFontSize.md,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Temukan Kuliner Terbaik di Palembang',
                  style: TextStyle(
                    fontSize: AppFontSize.xl,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          // Quick Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.md),
            child: Text(
              'Jelajahi Kuliner',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            children: [
              _buildMenuCard(
                icon: Icons.search,
                title: 'Cari Kuliner',
                color: AppColors.primary,
                onTap: () {
                  setState(() => _selectedIndex = 1);
                },
              ),
              _buildMenuCard(
                icon: Icons.location_on,
                title: 'Lihat Peta',
                color: AppColors.info,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur peta sedang dikembangkan')),
                  );
                },
              ),
              _buildMenuCard(
                icon: Icons.star_rounded,
                title: 'Rating Terbaik',
                color: AppColors.warning,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menampilkan restoran dengan rating terbaik')),
                  );
                },
              ),
              _buildMenuCard(
                icon: Icons.verified_user,
                title: 'Tersertifikasi Halal',
                color: AppColors.success,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menampilkan restoran tersertifikasi halal')),
                  );
                },
              ),
            ],
          ),

          // Featured Restaurants
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.md),
            child: Text(
              'Restoran Unggulan',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
            ),
          ),
          FutureBuilder<List<RestaurantModel>>(
            future: _restaurantService.getRestaurants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }

              final restaurants = snapshot.data ?? [];

              if (restaurants.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text('Tidak ada restoran tersedia'),
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
                    imageUrl: restaurant.imageUrls.isNotEmpty ? restaurant.imageUrls.first : null,
                    isVerified: restaurant.status == RestaurantStatus.verified,
                    isHalalCertified: restaurant.certificationStatus == CertificationStatus.halal,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Membuka detail restoran: ${restaurant.name}')),
                      );
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Card(
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 45,
                color: color,
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
