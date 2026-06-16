import 'package:flutter/material.dart';
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/screens/auth/login_screen.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pemilik Usaha'),
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
            // Header
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
                    'Selamat Datang',
                    style: TextStyle(
                      fontSize: AppFontSize.md,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Kelola Restoran & Usaha Anda',
                    style: TextStyle(
                      fontSize: AppFontSize.xl,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBadge('Restoran', '8', Icons.restaurant),
                      _buildStatBadge('Ulasan', '24', Icons.rate_review),
                      _buildStatBadge('Reservasi', '12', Icons.calendar_today),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Kelola Data Restoran
            Text(
              'Kelola Data Restoran',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildActionCard(
              icon: Icons.add_business,
              title: 'Tambah Restoran Baru',
              subtitle: 'Daftarkan restoran atau warung Anda',
              color: AppColors.success,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu tambah restoran sedang dikembangkan')),
                );
              },
            ),
            _buildActionCard(
              icon: Icons.edit,
              title: 'Update Data Restoran',
              subtitle: 'Edit menu, lokasi, atau informasi usaha',
              color: AppColors.info,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu update restoran sedang dikembangkan')),
                );
              },
            ),
            _buildActionCard(
              icon: Icons.delete,
              title: 'Hapus Restoran',
              subtitle: 'Menghapus restoran dari platform',
              color: AppColors.error,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu hapus restoran sedang dikembangkan')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Monitoring Usaha
            Text(
              'Monitoring Usaha',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildActionCard(
              icon: Icons.rate_review,
              title: 'Lihat Ulasan & Rating',
              subtitle: 'Kelola feedback dan rating dari pengunjung',
              color: AppColors.warning,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu ulasan sedang dikembangkan')),
                );
              },
            ),
            _buildActionCard(
              icon: Icons.calendar_today,
              title: 'Reservasi Meja',
              subtitle: 'Kelola dan konfirmasi reservasi dari pengunjung',
              color: AppColors.primary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu reservasi sedang dikembangkan')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Pengaturan Akun
            Text(
              'Pengaturan Akun',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildActionCard(
              icon: Icons.person,
              title: 'Kelola Akun',
              subtitle: 'Edit profil dan informasi kontak Anda',
              color: AppColors.info,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu kelola akun sedang dikembangkan')),
                );
              },
            ),
            _buildActionCard(
              icon: Icons.delete_forever,
              title: 'Hapus Akun',
              subtitle: 'Menghapus akun dan semua data terkait',
              color: AppColors.error,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu hapus akun sedang dikembangkan')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 28),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppFontSize.lg,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          title,
          style: const TextStyle(
            fontSize: AppFontSize.xs,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
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
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
