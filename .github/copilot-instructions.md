# SMWKP Flutter Application - Development Guide

## Project Overview
Sistem Manajemen Wisata Kuliner Palembang (SMWKP) - A comprehensive Flutter application for culinary tourism management in Palembang with three user types: tourists/locals, restaurant owners, and admin (Tourism Department).

## Technology Stack
- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Backend Integration**: REST API / Firebase
- **Maps**: Google Maps Flutter
- **Local Storage**: SQLite / Hive
- **Theme**: Red (#E63946) and White (#FFFFFF)

## Project Structure
```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
├── models/
│   ├── user_model.dart
│   ├── restaurant_model.dart
│   ├── review_model.dart
│   └── reservation_model.dart
├── screens/
│   ├── auth/
│   ├── home/
│   ├── culinary/
│   ├── restaurant/
│   ├── account/
│   └── admin/
├── widgets/
│   └── common/
├── services/
│   ├── auth_service.dart
│   ├── restaurant_service.dart
│   └── maps_service.dart
└── providers/
    └── app_providers.dart
```

## Key Features
1. **Authentication**: Login, Registration, Account Management
2. **Culinary Search**: Browse and filter restaurants
3. **Maps Integration**: View location and navigation
4. **Restaurant Management**: CRUD operations for business owners
5. **Verification System**: Admin data validation
6. **Certification**: Halal certification status
7. **Reviews & Ratings**: User feedback system
8. **Reservations**: Table booking system

## User Roles
- **Wisatawan/Masyarakat Lokal**: Browse, search, review, reserve
- **Pemilik Usaha**: Manage restaurant data
- **Admin (Dinas Pariwisata)**: Verify, certify, moderate content

## Setup Instructions
1. Ensure Flutter SDK is installed (flutter --version)
2. Run: flutter pub get
3. Configure Google Maps API keys
4. Run: flutter run

## Development Notes
- Follow Dart style guide
- Use Provider for state management
- Keep UI responsive for mobile devices
- Always validate user input
- Implement error handling gracefully
