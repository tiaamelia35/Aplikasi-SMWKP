import 'package:flutter/material.dart';
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/services/auth_service.dart';
import 'package:smwkp_culinary_tourism/widgets/common/common_widgets.dart';
import 'package:smwkp_culinary_tourism/screens/admin/admin_dashboard_screen.dart';
import 'package:smwkp_culinary_tourism/screens/home/home_screen.dart';
import 'package:smwkp_culinary_tourism/screens/owner/owner_dashboard_screen.dart';
import 'package:smwkp_culinary_tourism/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = await _authService.login(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil Masuk')),
          );

          Widget nextPage;
          switch (user.userType) {
            case UserType.admin:
              nextPage = const AdminDashboardScreen();
              break;
            case UserType.businessOwner:
              nextPage = const OwnerDashboardScreen();
              break;
            case UserType.tourist:
              nextPage = const HomeScreen();
              break;
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => nextPage),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Widget _buildCredentialHint(String label, String credential) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        '$label: $credential',
        style: const TextStyle(
          fontSize: AppFontSize.xs,
          color: AppColors.grey,
          fontFamily: 'Courier',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xl),
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: AppFontSize.xl,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Selamat Datang di SMWKP',
                    style: TextStyle(
                      fontSize: AppFontSize.md,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    label: AppStrings.email,
                    hintText: 'Masukkan email Anda',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    label: AppStrings.password,
                    hintText: 'Masukkan kata sandi Anda',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomButton(
                    label: AppStrings.login,
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Demo Credentials Hint
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
                    '📌 Demo Credential:',
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCredentialHint('👤 User', 'user@smwkp.com / user'),
                  _buildCredentialHint('🏢 Owner', 'owner@smwkp.com / owner'),
                  _buildCredentialHint('⚙️ Admin', 'admin@smwkp.com / admin'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun? ',
                    style: TextStyle(
                      color: AppColors.darkGrey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Daftar di sini',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
