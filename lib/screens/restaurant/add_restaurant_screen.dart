import 'package:flutter/material.dart';
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/services/restaurant_service.dart';
import 'package:smwkp_culinary_tourism/widgets/common/common_widgets.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({Key? key}) : super(key: key);

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _restaurantService = RestaurantService();

  double? _latitude;
  double? _longitude;
  List<String> _selectedCuisines = [];
  bool _isLoading = false;

  final _cuisineTypes = [
    'Pempek',
    'Tekwan',
    'Palembang Kering',
    'Nasi Kuning',
    'Makanan Tradisional',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleAddRestaurant() async {
    if (_formKey.currentState!.validate()) {
      if (_latitude == null || _longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih lokasi di peta')),
        );
        return;
      }

      if (_selectedCuisines.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih minimal satu jenis makanan')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        await _restaurantService.addRestaurant(
          ownerId: 'owner1', // TODO: Get from auth provider
          name: _nameController.text,
          description: _descriptionController.text,
          address: _addressController.text,
          latitude: _latitude!,
          longitude: _longitude!,
          phone: _phoneController.text,
          email: _emailController.text,
          cuisineTypes: _selectedCuisines,
          imageUrls: [],
          operatingHoursStart: DateTime(0, 0, 0, 10, 0),
          operatingHoursEnd: DateTime(0, 0, 0, 22, 0),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Restoran berhasil ditambahkan')),
          );
          Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.addRestaurant,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Info
              CustomTextField(
                label: AppStrings.restaurantName,
                hintText: 'Nama Restoran',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama restoran tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              CustomTextField(
                label: AppStrings.description,
                hintText: 'Deskripsi restoran',
                controller: _descriptionController,
                maxLines: 3,
                minLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              CustomTextField(
                label: AppStrings.address,
                hintText: 'Alamat lengkap',
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              CustomTextField(
                label: AppStrings.phone,
                hintText: '081234567890',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.lg),

              CustomTextField(
                label: AppStrings.email,
                hintText: 'email@restoran.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Cuisine Types
              Text(
                'Jenis Makanan',
                style: const TextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
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

              // Location
              Text(
                'Lokasi (Latitude, Longitude)',
                style: const TextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Column(
                  children: [
                    if (_latitude != null && _longitude != null)
                      Text('$_latitude, $_longitude')
                    else
                      const Text('Lokasi belum dipilih'),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Open map picker
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur pemilihan lokasi peta segera hadir'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text('Pilih Lokasi'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              CustomButton(
                label: AppStrings.addRestaurant,
                isLoading: _isLoading,
                onPressed: _handleAddRestaurant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
