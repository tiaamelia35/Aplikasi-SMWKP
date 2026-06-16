# SMWKP - Fitur Lanjutan

Dokumentasi implementasi fitur-fitur advanced untuk aplikasi SMWKP.

## Daftar Fitur

1. [API Client & Integration](#1-api-client--integration)
2. [Image Upload Service](#2-image-upload-service)
3. [Payment Integration](#3-payment-integration)
4. [Push Notifications](#4-push-notifications)
5. [Advanced Filtering](#5-advanced-filtering)
6. [Review Submission Form](#6-review-submission-form)
7. [Interactive Map Picker](#7-interactive-map-picker)

---

## 1. API Client & Integration

### File: `lib/services/api_client.dart`

Solusi centralized untuk semua HTTP requests dengan fitur:
- Singleton pattern untuk konsistensi
- Interceptor untuk authentication token
- Automatic error handling
- Support untuk file upload

### Penggunaan:

```dart
// GET request
final restaurants = await apiClient.get<List<RestaurantModel>>(
  '/restaurants',
  fromJson: (data) => List<RestaurantModel>.from(
    (data as List).map((x) => RestaurantModel.fromJson(x as Map<String, dynamic>))
  ),
);

// POST request
final user = await apiClient.post<UserModel>(
  '/auth/login',
  data: {
    'email': 'user@example.com',
    'password': 'password123',
  },
  fromJson: (data) => UserModel.fromJson(data as Map<String, dynamic>),
);

// Upload file
final result = await apiClient.uploadFile<Map<String, dynamic>>(
  '/restaurants/123/images',
  filePath: '/path/to/image.jpg',
  fromJson: (data) => Map<String, dynamic>.from(data),
);
```

### Konfigurasi:

1. Update `AppAPI.baseUrl` di `app_constants.dart`
2. Set token menggunakan: `apiClient.setToken(token)`
3. Clear token saat logout: `apiClient.clearToken()`

### API Endpoints yang Didukung:

- `GET` - Fetch data
- `POST` - Create/Submit data
- `PUT` - Update complete object
- `PATCH` - Partial update
- `DELETE` - Remove data
- File uploads (single & multiple)

---

## 2. Image Upload Service

### File: `lib/services/image_upload_service.dart`

Service lengkap untuk handling image:

### Fitur:

- ✅ Pick image dari gallery
- ✅ Pick image dari camera
- ✅ Pick multiple images
- ✅ Image validation (format & size)
- ✅ Upload ke server
- ✅ Compression support
- ✅ Delete image

### Penggunaan:

```dart
final imageUploadService = ImageUploadService();

// Pick single image
final File? image = await imageUploadService.pickImageFromGallery();

// Pick multiple images
final List<File> images = await imageUploadService.pickMultipleImages();

// Validate image
if (imageUploadService.isValidImageFile(imageFile)) {
  // File is valid (format & size)
}

// Upload restaurant images
await imageUploadService.uploadRestaurantImage(
  imageFile: imageFile,
  restaurantId: restaurantId,
);

// Upload multiple images
await imageUploadService.uploadMultipleRestaurantImages(
  imageFiles: imageFiles,
  restaurantId: restaurantId,
);
```

### Validasi:

- Format: JPG, JPEG, PNG, GIF, WebP
- Max size: 10 MB
- Image quality: 85
- Max dimension: 1024x1024

---

## 3. Payment Integration

### File: `lib/services/payment_service.dart`

Implementasi payment gateway dengan multi-method support.

### Payment Methods:

```dart
enum PaymentMethod {
  creditCard,    // Kartu Kredit
  debitCard,     // Kartu Debit
  eWallet,       // E-Wallet (GCash, OVO, Dana)
  bankTransfer,  // Transfer Bank
  cod,           // Cash on Delivery
}
```

### Penggunaan:

```dart
final paymentService = PaymentService();

// Create payment token
final token = await paymentService.createPaymentToken(
  amount: 250000,
  description: 'Reservation at Restaurant ABC',
  email: 'user@example.com',
  phoneNumber: '081234567890',
);

// Process payment
final result = await paymentService.processPayment(
  reservationId: 'res_123',
  amount: 250000,
  paymentMethod: PaymentMethod.creditCard,
  phoneNumber: '081234567890',
  cardToken: token['token'],
);

// Get payment status
final status = await paymentService.getPaymentStatus(
  paymentId: result['paymentId'],
);

// Refund
await paymentService.refundPayment(
  paymentId: result['paymentId'],
  amount: 250000, // Partial refund
);

// Format currency
final formatted = paymentService.formatCurrency(250000);
// Output: "Rp 250.000"
```

### Integrasi Payment Gateway:

#### Stripe (Recommended):
```yaml
flutter_stripe: ^9.0.0
```

#### Razorpay:
```yaml
razorpay_flutter: ^1.3.0
```

#### Midtrans (Indonesia):
```yaml
# Uncomment payment providers as needed
```

---

## 4. Push Notifications

### File: `lib/services/push_notification_service.dart`

Firebase Cloud Messaging integration untuk push notifications.

### Setup:

#### Android:
1. Download `google-services.json` dari Firebase Console
2. Tempatkan di `android/app/`
3. Update `android/build.gradle`:
   ```gradle
   classpath 'com.google.gms:google-services:4.3.15'
   ```
4. Update `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

#### iOS:
1. Download `GoogleService-Info.plist` dari Firebase Console
2. Buka Xcode: `open ios/Runner.xcworkspace`
3. Drag `GoogleService-Info.plist` ke Xcode project
4. Enable Push Notifications capability

### Penggunaan:

```dart
// Initialize (call di main.dart)
await PushNotificationService.initialize();

// Get FCM token
final token = await PushNotificationService.getFCMToken();
print('FCM Token: $token');

// Subscribe to topic
await PushNotificationService.subscribeToTopic('restaurant_updates');

// Unsubscribe from topic
await PushNotificationService.unsubscribeFromTopic('restaurant_updates');

// Send local notification
await PushNotificationService.sendLocalNotification(
  title: 'Reservation Confirmed',
  body: 'Your reservation is confirmed for 7:00 PM',
);

// Subscribe user
await PushNotificationService.subscribeUserToNotifications(userId);

// Unsubscribe user
await PushNotificationService.unsubscribeUserFromNotifications(userId);
```

### Topics untuk Subscribe:

- `all_users` - Semua user
- `user_{userId}` - User spesifik
- `restaurant_{restaurantId}` - Update restoran
- `promotions` - Promosi & deals
- `reservations` - Update reservasi

---

## 5. Advanced Filtering

### File: `lib/screens/culinary/advanced_filter_screen.dart`

UI lengkap untuk filtering restoran dengan berbagai kriteria.

### Filter Tersedia:

- 🔍 **Search Query** - Cari berdasarkan nama
- 💰 **Price Range** - Filter harga (1-5 scale)
- ⭐ **Minimum Rating** - Filter rating minimum
- 📍 **Distance** - Filter jarak dari lokasi saya
- 🍜 **Cuisine Types** - Filter jenis makanan
- ✅ **Verified Only** - Hanya restoran terverifikasi
- 🔔 **Halal Certified Only** - Hanya bersertifikat halal
- ⏰ **Open Now** - Hanya yang sedang buka

### Penggunaan:

```dart
// Navigate to filter screen
final filters = await Navigator.push<Map<String, dynamic>>(
  context,
  MaterialPageRoute(
    builder: (context) => const AdvancedFilterScreen(),
  ),
);

if (filters != null) {
  // Navigate to filtered results
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FilteredRestaurantsScreen(filters: filters),
    ),
  );
}
```

### Filter Object:

```dart
{
  'searchQuery': 'pempek',
  'priceRange': RangeValues(1, 3),
  'minRating': 4,
  'cuisines': ['Pempek', 'Tekwan'],
  'radius': 5.0,  // km
  'verifiedOnly': true,
  'halalOnly': false,
  'openNow': true,
}
```

---

## 6. Review Submission Form

### File: `lib/screens/restaurant/review_submission_screen.dart`

Comprehensive form untuk submit review dengan multi-rating system.

### Fitur:

- ⭐ Overall rating (1-5 stars)
- 🎯 Sub-ratings:
  - Food Quality
  - Service
  - Cleanliness
  - Price Value
- 📝 Title & content validation
- 📸 Multiple image upload (max 5)
- ✓ Form validation

### Penggunaan:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ReviewSubmissionScreen(
      restaurantId: restaurantId,
      restaurantName: restaurantName,
    ),
  ),
);
```

### Validasi:

- Title: Minimum 5 karakter
- Content: Minimum 20 karakter
- Images: Format valid, max 10MB each, max 5 total
- Rating: 1-5 scale

---

## 7. Interactive Map Picker

### File: `lib/screens/culinary/map_picker_screen.dart`

Google Maps integration untuk pemilihan lokasi interaktif.

### Screens:

#### A. MapPickerScreen
Untuk memilih lokasi tunggal (tambah restoran, dll)

```dart
final result = await Navigator.push<Map<String, dynamic>>(
  context,
  MaterialPageRoute(
    builder: (context) => const MapPickerScreen(
      initialLatitude: -2.915808,
      initialLongitude: 104.745199,
      initialAddress: 'Palembang, Indonesia',
    ),
  ),
);

if (result != null) {
  final latitude = result['latitude'] as double;
  final longitude = result['longitude'] as double;
  final address = result['address'] as String;
}
```

#### B. MultiMarkerMapScreen
Untuk menampilkan multiple markers (browse restoran)

```dart
final markers = [
  MapMarker(
    id: '1',
    title: 'Restaurant A',
    address: 'Jl. Sudirman No. 123',
    latitude: -2.915808,
    longitude: 104.745199,
    isHalalCertified: true,
    rating: 4.5,
  ),
  // ... more markers
];

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => MultiMarkerMapScreen(
      markers: markers,
      onMarkerTap: (marker) {
        // Handle marker tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              restaurantId: marker.id,
            ),
          ),
        );
      },
    ),
  ),
);
```

### Fitur Map:

- 📍 Current location button
- 🎯 Tap to select location
- 🗺️ Multiple marker support
- 📌 Marker color (Red: Normal, Green: Halal Certified)
- 🔍 Zoom controls
- 🧭 My location button
- 📍 Location info card

---

## Integration Checklist

### Backend API:

- [ ] Setup API endpoints untuk authentication
- [ ] Setup endpoints untuk CRUD restoran
- [ ] Setup file upload endpoints
- [ ] Setup payment processing endpoints
- [ ] Setup review endpoints
- [ ] Setup reservation endpoints

### Firebase:

- [ ] Create Firebase project
- [ ] Enable Firebase Authentication
- [ ] Enable Firebase Cloud Messaging
- [ ] Setup Firestore (opsional)
- [ ] Download credentials (JSON & PLIST)

### Payment Gateway:

- [ ] Choose payment provider (Stripe/Razorpay/Midtrans)
- [ ] Get API keys
- [ ] Configure dalam app
- [ ] Test dengan test cards/credentials

### Google Maps:

- [ ] Create API key di Google Cloud Console
- [ ] Enable Maps APIs:
  - Maps SDK for Android
  - Maps SDK for iOS
  - Places API
  - Geolocation API
- [ ] Add restrictions (app/package name)
- [ ] Configure dalam app

---

## Testing

### Unit Tests:
```bash
flutter test
```

### Integration Tests:
```bash
flutter drive --target=test_driver/app.dart
```

### Device Testing:
```bash
# Android
flutter run

# iOS
flutter run -d iPhone
```

---

## Troubleshooting

### Google Maps tidak muncul:
1. Verify API key di AndroidManifest.xml
2. Check bundle ID untuk iOS
3. Verify API key restrictions

### Push notifications tidak terima:
1. Verify FCM token
2. Check Firebase Cloud Messaging enabled
3. Check Android/iOS permissions
4. Test dengan Firebase Console

### Image upload gagal:
1. Check permissions (READ_EXTERNAL_STORAGE)
2. Verify file path & format
3. Check server file size limit
4. Enable CORS di backend

### Payment processing error:
1. Verify payment method availability
2. Check API credentials
3. Test dengan test accounts
4. Verify network connectivity

---

## Security Best Practices

- ✅ Never hardcode API keys - use environment variables
- ✅ Validate all user input on backend
- ✅ Use HTTPS for all API calls
- ✅ Implement SSL pinning
- ✅ Store sensitive data securely (encrypted SharedPreferences)
- ✅ Implement rate limiting
- ✅ Never store payment credentials locally
- ✅ Use secure token refresh mechanism

---

## Performance Tips

- ✅ Implement image caching
- ✅ Lazy load list items
- ✅ Paginate API responses
- ✅ Compress large payloads
- ✅ Optimize Google Maps zoom levels
- ✅ Implement connection pooling
- ✅ Cache frequently accessed data
- ✅ Use Hive for local caching

---

## Dokumentasi Lengkap

Untuk dokumentasi lebih detail, lihat:
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Google Maps API Docs](https://developers.google.com/maps/documentation)
- [Dio HTTP Client](https://pub.dev/packages/dio)
