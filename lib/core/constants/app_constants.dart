import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFE63946); // Red
  static const Color white = Color(0xFFFFFFFF);
  
  // Secondary Colors
  static const Color lightRed = Color(0xFFFF6B6B);
  static const Color darkRed = Color(0xFFC91B1B);
  
  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF424242);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE63946);
  static const Color info = Color(0xFF2196F3);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppBorderRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

class AppFontSize {
  static const double xs = 12.0;
  static const double sm = 14.0;
  static const double md = 16.0;
  static const double lg = 18.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

class AppStrings {
  // General
  static const String appName = 'SMWKP';
  static const String appTitle = 'Sistem Manajemen Wisata Kuliner Palembang';
  
  // Authentication
  static const String login = 'Masuk';
  static const String register = 'Daftar';
  static const String email = 'Email';
  static const String password = 'Kata Sandi';
  static const String confirmPassword = 'Konfirmasi Kata Sandi';
  static const String loginSuccess = 'Berhasil Masuk';
  static const String registerSuccess = 'Pendaftaran Berhasil';
  
  // Navigation
  static const String home = 'Beranda';
  static const String search = 'Cari';
  static const String restaurants = 'Restoran';
  static const String account = 'Akun';
  static const String admin = 'Admin';
  
  // Culinary
  static const String searchCulinary = 'Cari Kuliner';
  static const String viewLocation = 'Lihat Lokasi';
  static const String viewDetails = 'Lihat Detail';
  static const String restaurantDetail = 'Detail Restoran';
  
  // Restaurant Management
  static const String addRestaurant = 'Tambah Restoran';
  static const String updateRestaurant = 'Ubah Restoran';
  static const String deleteRestaurant = 'Hapus Restoran';
  static const String restaurantName = 'Nama Restoran';
  static const String description = 'Deskripsi';
  static const String address = 'Alamat';
  static const String phone = 'No. Telepon';
  static const String location = 'Lokasi';
  
  // Reviews & Ratings
  static const String rating = 'Rating';
  static const String review = 'Ulasan';
  static const String addReview = 'Tambah Ulasan';
  static const String noReviews = 'Belum ada ulasan';
  
  // Reservations
  static const String makeReservation = 'Buat Reservasi';
  static const String reservationDate = 'Tanggal Reservasi';
  static const String reservationTime = 'Jam Reservasi';
  static const String numberOfGuests = 'Jumlah Tamu';
  static const String specialRequest = 'Permintaan Khusus';
  
  // Verification & Certification
  static const String verification = 'Verifikasi';
  static const String certification = 'Sertifikasi';
  static const String halalCertified = 'Tersertifikasi Halal';
  static const String verified = 'Terverifikasi';
  static const String pending = 'Menunggu';
  static const String rejected = 'Ditolak';
  
  // Account
  static const String editProfile = 'Edit Profil';
  static const String deleteAccount = 'Hapus Akun';
  static const String logout = 'Keluar';
  static const String userType = 'Tipe Pengguna';
  static const String tourist = 'Wisatawan';
  static const String businessOwner = 'Pemilik Usaha';
  static const String admin2 = 'Admin';
  
  // Common
  static const String save = 'Simpan';
  static const String delete = 'Hapus';
  static const String edit = 'Edit';
  static const String cancel = 'Batal';
  static const String confirm = 'Konfirmasi';
  static const String loading = 'Memuat...';
  static const String error = 'Terjadi kesalahan';
  static const String success = 'Berhasil';
  static const String back = 'Kembali';
}

class AppAPI {
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/v1';
  
  // Authentication Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String userProfileEndpoint = '/auth/me';
  
  // Restaurant Endpoints
  static const String restaurantsEndpoint = '/restaurants';
  static const String restaurantDetailEndpoint = '/restaurants/{id}';
  static const String restaurantReviewsEndpoint = '/restaurants/{id}/reviews';
  static const String verifyRestaurantEndpoint = '/restaurants/{id}/verify';
  static const String certifyHalalEndpoint = '/restaurants/{id}/certify-halal';
  
  // Review Endpoints
  static const String reviewsEndpoint = '/reviews';
  
  // Reservation Endpoints
  static const String reservationsEndpoint = '/reservations';
}


// User Types
enum UserType {
  tourist,
  businessOwner,
  admin,
}

// Restaurant Status
enum RestaurantStatus {
  pending,
  verified,
  rejected,
}

// Certification Status
enum CertificationStatus {
  none,
  halal,
  pending,
  rejected,
}
