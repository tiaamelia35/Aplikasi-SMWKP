import 'package:flutter/material.dart';
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/screens/auth/login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan statistik
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.darkRed],
                ),
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang, Admin',
                    style: TextStyle(
                      fontSize: AppFontSize.xl,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Dinas Pariwisata Palembang',
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Stats Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              children: [
                _buildStatCard(
                  'Menunggu Verifikasi',
                  '12',
                  Icons.pending_actions,
                  AppColors.warning,
                ),
                _buildStatCard(
                  'Terverifikasi',
                  '48',
                  Icons.verified,
                  AppColors.success,
                ),
                _buildStatCard(
                  'Sertifikasi Halal',
                  '32',
                  Icons.verified_user,
                  AppColors.primary,
                ),
                _buildStatCard(
                  'Ditolak',
                  '5',
                  Icons.close,
                  AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Verifikasi & Sertifikasi
            Text(
              'Validasi & Sertifikasi',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildActionCard(
              icon: Icons.fact_check,
              title: 'Verifikasi Data Restoran',
              subtitle: 'Review dan validasi data kuliner yang masuk',
              color: AppColors.info,
              badgeText: '12',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu verifikasi sedang dikembangkan')),
                );
              },
            ),
            _buildActionCard(
              icon: Icons.approval,
              title: 'Sertifikasi Halal',
              subtitle: 'Berikan sertifikasi halal resmi untuk usaha kuliner',
              color: AppColors.success,
              badgeText: '8',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu sertifikasi sedang dikembangkan')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Moderasi Ulasan
            Text(
              'Moderasi Platform',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildActionCard(
              icon: Icons.rate_review,
              title: 'Moderasi Ulasan & Rating',
              subtitle: 'Review dan kelola ulasan dari pengunjung',
              color: AppColors.warning,
              badgeText: '24',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu moderasi sedang dikembangkan')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Aktivitas Terbaru
            Text(
              'Aktivitas Terbaru',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildActivityItem(
              'Rumah Makan Pempek Palembang',
              'Menunggu Verifikasi',
              AppColors.warning,
            ),
            _buildActivityItem(
              'Kafe Tekwan Modern',
              'Terverifikasi',
              AppColors.success,
            ),
            _buildActivityItem(
              'Warung Iga Bakar Sentral',
              'Tersertifikasi Halal',
              AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: AppSpacing.md),
              Text(
                count,
                style: TextStyle(
                  fontSize: AppFontSize.xxxl,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: AppFontSize.xs,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String badgeText,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: AppFontSize.sm,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: AppFontSize.xs,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Chip(
              label: Text(
                status,
                style: const TextStyle(color: AppColors.white),
              ),
              backgroundColor: statusColor,
              labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            ),
          ],
        ),
      ),
    );
  }
}
