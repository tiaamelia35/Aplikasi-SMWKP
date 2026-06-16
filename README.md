# SMWKP - Sistem Manajemen Wisata Kuliner Palembang

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Flutter](https://img.shields.io/badge/flutter-3.0.0%2B-blue)

Aplikasi mobile comprehensive untuk manajemen wisata kuliner di Palembang dengan fitur pencarian, verifikasi, sertifikasi, dan reservasi restoran.

## Daftar Isi

- [Fitur](#fitur)
- [Teknologi](#teknologi)
- [Persyaratan Sistem](#persyaratan-sistem)
- [Instalasi](#instalasi)
- [Struktur Proyek](#struktur-proyek)
- [Panduan Penggunaan](#panduan-penggunaan)
- [API Integration](#api-integration)
- [Kontribusi](#kontribusi)

## Fitur

### 1. **Autentikasi & Akun**
- ✅ Pendaftaran akun dengan tipe pengguna
- ✅ Login dengan validasi email dan password
- ✅ Edit profil pengguna
- ✅ Hapus akun
- ✅ Keluar dari aplikasi

### 2. **Pencarian & Browsing Kuliner**
- ✅ Cari restoran by nama
- ✅ Filter berdasarkan jenis makanan
- ✅ Lihat daftar restoran dengan rating
- ✅ Lihat detail lengkap restoran
- ✅ Integrasi Google Maps untuk navigasi lokasi

### 3. **Manajemen Data Restoran (Business Owner)**
- ✅ Tambah data restoran baru
- ✅ Update informasi restoran
- ✅ Hapus data restoran
- ✅ Upload foto restoran
- ✅ Kelola jam operasional

### 4. **Verifikasi & Sertifikasi (Admin)**
- ✅ Verifikasi data restoran
- ✅ Sertifikasi halal resmi
- ✅ Dashboard admin untuk moderasi

### 5. **Ulasan & Rating**
- ✅ Lihat ulasan restoran
- ✅ Tambah ulasan dan rating
- ✅ Sistem rating berbintang (1-5)

### 6. **Reservasi Meja**
- ✅ Pesan meja di restoran
- ✅ Pilih tanggal dan jam
- ✅ Input jumlah tamu
- ✅ Permintaan khusus

## Teknologi

### Frontend
- **Framework**: Flutter 3.0.0+
- **Language**: Dart 3.0.0+
- **State Management**: Provider
- **UI Components**: Material Design 3

### Backend & Services
- **HTTP Client**: Dio / HTTP
- **Maps**: Google Maps Flutter
- **Location Services**: Geolocator
- **Authentication**: Firebase Auth (optional)
- **Database**: Firestore / REST API

### Local Storage
- **Preferences**: Shared Preferences
- **Database**: Hive / SQLite

### Dependencies
```yaml
# State Management
provider: ^6.0.0

# Networking
http: ^1.1.0
dio: ^5.3.0

# Local Storage
shared_preferences: ^2.2.0
hive: ^2.2.0

# Maps & Location
google_maps_flutter: ^2.5.0
geolocator: ^9.0.0

# UI & Widgets
flutter_rating_bar: ^4.0.0
smooth_page_indicator: ^1.1.0
```

## Persyaratan Sistem

### Minimum
- **Android**: API Level 21 (Android 5.0) atau lebih tinggi
- **iOS**: iOS 11.0 atau lebih tinggi
- **Flutter SDK**: v3.0.0 atau lebih baru

### Recommended
- **Android**: API Level 28 (Android 9.0) atau lebih tinggi
- **iOS**: iOS 13.0 atau lebih tinggi
- **Flutter SDK**: v3.10.0 atau lebih baru

## Instalasi

### 1. Prasyarat
Pastikan Flutter SDK sudah terinstal:
```bash
flutter --version
```

### 2. Clone Repository
```bash
git clone https://github.com/yourusername/Aplikasi-SMWKP.git
cd Aplikasi-SMWKP
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Konfigurasi Google Maps API
- Buka `android/app/build.gradle`
- Tambahkan Google Maps API key:
  ```gradle
  android {
    ...
    defaultConfig {
      ...
      manifestPlaceholders = [MAPS_API_KEY: "YOUR_GOOGLE_MAPS_API_KEY"]
    }
  }
  ```

### 5. Jalankan Aplikasi
```bash
flutter run
```

### 6. Build Release
```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## Struktur Proyek

```
lib/
├── main.dart                      # Entry point aplikasi
├── core/
│   ├── constants/
│   │   └── app_constants.dart    # Constants warna, text, API endpoints
│   ├── theme/
│   │   └── app_theme.dart        # Theme red & white
│   └── utils/
│       └── validators.dart       # Input validation utilities
├── models/
│   ├── user_model.dart           # User data structure
│   ├── restaurant_model.dart     # Restaurant data structure
│   ├── review_model.dart         # Review data structure
│   └── reservation_model.dart    # Reservation data structure
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart     # Login UI
│   │   ├── register_screen.dart  # Registration UI
│   │   └── splash_screen.dart    # Splash screen
│   ├── home/
│   │   └── home_screen.dart      # Home/Dashboard
│   ├── culinary/
│   │   └── search_culinary_screen.dart  # Search & filter
│   ├── restaurant/
│   │   ├── restaurant_detail_screen.dart # Restaurant detail
│   │   ├── add_restaurant_screen.dart    # Add restaurant
│   │   └── manage_restaurant_screen.dart # Manage restaurant
│   ├── account/
│   │   └── account_screen.dart   # User account management
│   └── admin/
│       ├── admin_dashboard.dart  # Admin dashboard
│       └── verification_screen.dart # Verify restaurants
├── widgets/
│   └── common/
│       └── common_widgets.dart   # Reusable widgets
├── services/
│   ├── auth_service.dart         # Authentication logic
│   ├── restaurant_service.dart   # Restaurant operations
│   └── maps_service.dart         # Maps & location services
└── providers/
    └── app_providers.dart        # Provider configuration
```

## Panduan Penggunaan

### Untuk Wisatawan/Masyarakat Lokal

1. **Registrasi & Login**
   - Buka aplikasi dan klik "Daftar di sini"
   - Pilih tipe pengguna: "Wisatawan"
   - Isi form registrasi dengan email, nama, dan password
   - Setelah registrasi berhasil, login dengan akun Anda

2. **Cari Kuliner**
   - Di home screen, klik menu "Cari Kuliner"
   - Gunakan search box untuk mencari restoran
   - Filter berdasarkan jenis makanan (Pempek, Tekwan, dll)
   - Klik restoran untuk melihat detail lengkap

3. **Lihat Detail Restoran**
   - Klik salah satu restoran dari daftar
   - Lihat informasi lengkap: alamat, jam operasional, kontak
   - Lihat rating dan ulasan dari pengunjung lain
   - Lihat badge verifikasi dan sertifikasi halal (jika ada)

4. **Lihat Lokasi di Peta**
   - Di detail restoran, klik tombol "Lihat Lokasi"
   - Peta akan menampilkan lokasi restoran
   - Gunakan tombol navigasi untuk membuka GPS

5. **Ulasan & Rating**
   - Buka detail restoran
   - Scroll ke tab "Ulasan"
   - Lihat ulasan dari pengunjung lain
   - Klik "Tambah Ulasan" untuk memberikan rating dan review

6. **Reservasi Meja**
   - Buka detail restoran
   - Scroll ke tab "Reservasi"
   - Klik "Pesan Meja Sekarang"
   - Isi form reservasi: tanggal, jam, jumlah tamu, permintaan khusus
   - Konfirmasi pemesanan

### Untuk Pemilik Usaha Kuliner

1. **Registrasi & Login**
   - Buka aplikasi dan klik "Daftar di sini"
   - Pilih tipe pengguna: "Pemilik Usaha"
   - Isi form dengan data bisnis Anda

2. **Tambah Data Restoran**
   - Di menu akun, klik "Tambah Restoran Baru"
   - Isi form:
     - Nama restoran
     - Deskripsi
     - Alamat
     - Koordinat lokasi (latitude/longitude)
     - Nomor telepon
     - Email
     - Jam operasional
     - Jenis makanan
     - Upload foto restoran
   - Klik "Simpan"

3. **Update Data Restoran**
   - Buka detail restoran milik Anda
   - Klik tombol "Edit"
   - Ubah informasi yang diperlukan
   - Klik "Simpan Perubahan"

4. **Kelola Restoran**
   - Lihat list restoran milik Anda
   - Lihat status verifikasi admin
   - Lihat ulasan dan rating dari tamu
   - Hapus restoran jika diperlukan

### Untuk Admin (Dinas Pariwisata)

1. **Login Admin**
   - Login dengan akun admin (setup oleh developer)

2. **Verifikasi Data Restoran**
   - Buka Dashboard Admin
   - Lihat list restoran yang pending verifikasi
   - Review data lengkap restoran
   - Klik "Terima" atau "Tolak"

3. **Sertifikasi Halal**
   - Di detail restoran yang terverifikasi
   - Klik "Beri Sertifikasi Halal"
   - Input nomor sertifikasi halal
   - Klik "Simpan Sertifikasi"

4. **Moderasi Ulasan**
   - Lihat list ulasan dari pengunjung
   - Hapus ulasan yang tidak sesuai
   - Tindak lanjuti laporan abuse

## API Integration

### Authentication Endpoints
```dart
POST /auth/login
  - body: { email, password }
  - response: { user, token }

POST /auth/register
  - body: { email, name, password, userType }
  - response: { user, token }

POST /auth/logout
  - response: { success }
```

### Restaurant Endpoints
```dart
GET /restaurants
  - params: { page, limit, searchQuery, cuisineType }
  - response: { restaurants, total }

GET /restaurants/{id}
  - response: { restaurant }

POST /restaurants
  - body: { name, description, address, ... }
  - response: { restaurant }

PUT /restaurants/{id}
  - body: { name, description, address, ... }
  - response: { restaurant }

DELETE /restaurants/{id}
  - response: { success }
```

### Review Endpoints
```dart
GET /restaurants/{id}/reviews
  - params: { page, limit }
  - response: { reviews, total }

POST /reviews
  - body: { restaurantId, rating, title, content }
  - response: { review }
```

### Reservation Endpoints
```dart
POST /reservations
  - body: { restaurantId, date, time, numberOfGuests, ... }
  - response: { reservation }

GET /reservations
  - response: { reservations }
```

## Konfigurasi Tema

Aplikasi menggunakan tema merah dan putih sesuai kebutuhan:

```dart
// Warna Primary
AppColors.primary     = #E63946 (Red)
AppColors.white       = #FFFFFF (White)

// Warna Secondary
AppColors.lightRed    = #FF6B6B
AppColors.darkRed     = #C91B1B
AppColors.lightGrey   = #F5F5F5
AppColors.grey        = #9E9E9E
AppColors.darkGrey    = #424242

// Warna Status
AppColors.success     = #4CAF50 (Green)
AppColors.warning     = #FFC107 (Yellow)
AppColors.error       = #E63946 (Red)
AppColors.info        = #2196F3 (Blue)
```

## Development Notes

### TODO Items
- [ ] Complete admin dashboard implementation
- [ ] Implement restaurant management screens
- [ ] Add image upload functionality
- [ ] Integrate with backend API
- [ ] Setup Firebase authentication
- [ ] Implement offline functionality
- [ ] Add payment integration for reservations
- [ ] Implement push notifications
- [ ] Add advanced filtering and sorting
- [ ] Setup comprehensive error handling

### Best Practices
- ✅ Follow Dart style guide and conventions
- ✅ Use Provider for state management
- ✅ Keep UI components reusable
- ✅ Always validate user input
- ✅ Implement error handling gracefully
- ✅ Use constants for strings and values
- ✅ Keep themes centralized
- ✅ Use responsive design for all screens

### Debugging
```bash
# Enable verbose logging
flutter run -v

# Run with Observatory
flutter run --observatory

# Check widget tree
dart devtools
```

## Contributing

Kami menerima kontribusi! Silakan ikuti langkah berikut:

1. Fork repository
2. Buat branch feature (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buka Pull Request

## License

Proyek ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detail.

## Support

Untuk pertanyaan atau dukungan, silakan:
- Buka issue di [GitHub Issues](https://github.com/yourusername/Aplikasi-SMWKP/issues)
- Email: support@smwkp.com
- WhatsApp: [Link WhatsApp]

## Changelog

### Version 1.0.0 (Initial Release)
- Initial project setup
- Authentication system (Login/Register)
- Restaurant browsing and search
- Review and rating system
- Reservation functionality
- Admin dashboard (basic)
- Google Maps integration

---

**Dibuat dengan ❤️ untuk Wisata Kuliner Palembang**
