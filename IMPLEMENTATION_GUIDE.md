# Implementation Guide - Advanced Features

Panduan step-by-step untuk mengimplementasikan fitur-fitur advanced.

## Quick Start

### 1. Update Dependencies

```bash
cd Aplikasi-SMWKP
flutter pub get
```

### 2. Initialize Services di main.dart

```dart
import 'package:smwkp_culinary_tourism/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (if using)
  // await Firebase.initializeApp();
  
  // Initialize Push Notifications
  await PushNotificationService.initialize();
  
  runApp(const MyApp());
}
```

### 3. Update Search Screen dengan Advanced Filter

```dart
// Di search_culinary_screen.dart, tambahkan button:

FloatingActionButton(
  onPressed: () async {
    final filters = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const AdvancedFilterScreen(),
      ),
    );
    
    if (filters != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilteredRestaurantsScreen(filters: filters),
        ),
      );
    }
  },
  child: const Icon(Icons.filter_list),
),
```

---

## Feature-by-Feature Implementation

### Feature 1: API Client Integration

**Step 1:** Update app constants
```dart
// lib/core/constants/app_constants.dart
class AppAPI {
  static const String baseUrl = 'https://your-api.com/api/v1';
  // ... rest of endpoints
}
```

**Step 2:** Replace mock services dengan API calls
```dart
// lib/services/restaurant_service.dart
Future<List<RestaurantModel>> getRestaurants(...) async {
  try {
    return await apiClient.get<List<RestaurantModel>>(
      '/restaurants',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (searchQuery != null) 'search': searchQuery,
        if (cuisineType != null) 'cuisineType': cuisineType,
      },
      fromJson: (data) => List<RestaurantModel>.from(
        (data as List).map((x) => RestaurantModel.fromJson(x))
      ),
    );
  } catch (e) {
    throw Exception('Failed to fetch restaurants: $e');
  }
}
```

**Step 3:** Update Auth Service
```dart
// lib/services/auth_service.dart
Future<UserModel> login({...}) async {
  final result = await apiClient.post<Map<String, dynamic>>(
    '/auth/login',
    data: {
      'email': email,
      'password': password,
    },
    fromJson: (data) => Map<String, dynamic>.from(data),
  );
  
  // Save token
  await apiClient.setToken(result['token']);
  
  return UserModel.fromJson(result['user']);
}
```

---

### Feature 2: Image Upload

**Step 1:** Import image upload service
```dart
import 'package:smwkp_culinary_tourism/services/image_upload_service.dart';

final imageUploadService = ImageUploadService();
```

**Step 2:** Add image picker button di form
```dart
ElevatedButton.icon(
  onPressed: () async {
    final images = await imageUploadService.pickMultipleImages();
    // Handle selected images
  },
  icon: const Icon(Icons.image),
  label: const Text('Pick Images'),
),
```

**Step 3:** Upload images dengan restaurant
```dart
if (_selectedImages.isNotEmpty) {
  final uploadResult = await imageUploadService.uploadMultipleRestaurantImages(
    imageFiles: _selectedImages,
    restaurantId: restaurant.id,
  );
}
```

---

### Feature 3: Payment Integration

**Step 1:** Setup payment method di form
```dart
// Choose payment gateway based on region
const paymentProvider = 'stripe'; // or 'razorpay', 'midtrans'

final paymentService = PaymentService();
```

**Step 2:** Implement payment flow
```dart
// Step 1: Calculate price
final pricing = await paymentService.calculateBookingPrice(
  restaurantId: restaurantId,
  numberOfGuests: numberOfGuests,
  reservationDateTime: reservationDateTime,
);

// Step 2: Create payment
final payment = await paymentService.processPayment(
  reservationId: reservationId,
  amount: pricing['totalPrice'],
  paymentMethod: selectedPaymentMethod,
  phoneNumber: phoneNumber,
);

// Step 3: Check status
final status = await paymentService.getPaymentStatus(
  paymentId: payment['paymentId'],
);
```

**Step 3:** Display payment methods
```dart
DropdownButton<PaymentMethod>(
  value: _selectedMethod,
  items: [
    DropdownMenuItem(
      value: PaymentMethod.creditCard,
      child: const Text('Credit/Debit Card'),
    ),
    DropdownMenuItem(
      value: PaymentMethod.eWallet,
      child: const Text('E-Wallet (GCash, OVO, Dana)'),
    ),
    DropdownMenuItem(
      value: PaymentMethod.bankTransfer,
      child: const Text('Bank Transfer'),
    ),
    DropdownMenuItem(
      value: PaymentMethod.cod,
      child: const Text('Cash on Delivery'),
    ),
  ],
  onChanged: (value) {
    setState(() => _selectedMethod = value ?? PaymentMethod.cod);
  },
)
```

---

### Feature 4: Push Notifications

**Step 1:** Setup Firebase (Android)

Edit `android/app/build.gradle`:
```gradle
android {
    ...
    defaultConfig {
        ...
        minSdkVersion 21
    }
}

dependencies {
    ...
    implementation 'com.google.firebase:firebase-bom:32.0.0'
    implementation 'com.google.firebase:firebase-messaging'
}

apply plugin: 'com.google.gms.google-services'
```

**Step 2:** Setup Firebase (iOS)

```bash
cd ios
pod install
cd ..
```

**Step 3:** Handle notifications
```dart
// Listen to foreground messages
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification');
  }
});

// Handle notification tap
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  print('A new onMessageOpenedApp event was published!');
  // Navigate based on message
});
```

**Step 4:** Subscribe user
```dart
// Di login screen atau after successful login
final userId = user.id;
await PushNotificationService.subscribeUserToNotifications(userId);
```

---

### Feature 5: Advanced Filtering

**Step 1:** Add filter button ke search screen
```dart
// Di search_culinary_screen.dart
FloatingActionButton(
  onPressed: () async {
    final filters = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const AdvancedFilterScreen()),
    );
    
    if (filters != null) {
      _applyFilters(filters);
    }
  },
  child: const Icon(Icons.filter_list),
),
```

**Step 2:** Apply filters ke restaurants
```dart
Future<void> _applyFilters(Map<String, dynamic> filters) async {
  final restaurants = await _restaurantService.getRestaurants();
  
  final filtered = restaurants.where((r) {
    // Implement filter logic
    return true;
  }).toList();
  
  setState(() => _filteredRestaurants = filtered);
}
```

---

### Feature 6: Review Submission

**Step 1:** Add review button di detail screen
```dart
// Di restaurant_detail_screen.dart, di review tab:

ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewSubmissionScreen(
          restaurantId: restaurant.id,
          restaurantName: restaurant.name,
        ),
      ),
    );
  },
  child: const Text('Add Review'),
),
```

**Step 2:** Submit review dengan images
```dart
// Di review_submission_screen.dart
Future<void> _submitReview() async {
  // 1. Upload images
  if (_selectedImages.isNotEmpty) {
    await _imageUploadService.uploadReviewImages(
      imageFiles: _selectedImages,
      reviewId: reviewId,
    );
  }
  
  // 2. Submit review
  await apiClient.post<Map<String, dynamic>>(
    '/reviews',
    data: {
      'restaurantId': widget.restaurantId,
      'rating': _rating,
      'title': _titleController.text,
      'content': _contentController.text,
      'foodQuality': _foodQualityRating,
      'service': _serviceRating,
      'cleanliness': _cleanlinessRating,
      'price': _priceRating,
    },
    fromJson: (data) => Map<String, dynamic>.from(data),
  );
}
```

---

### Feature 7: Map Picker

**Step 1:** Import map picker
```dart
import 'package:smwkp_culinary_tourism/screens/culinary/map_picker_screen.dart';
```

**Step 2:** Add map picker button di form
```dart
ElevatedButton.icon(
  onPressed: () async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const MapPickerScreen(
          initialLatitude: _latitude,
          initialLongitude: _longitude,
        ),
      ),
    );
    
    if (result != null) {
      setState(() {
        _latitude = result['latitude'];
        _longitude = result['longitude'];
        _address = result['address'];
      });
    }
  },
  icon: const Icon(Icons.location_on),
  label: const Text('Pick Location'),
),
```

**Step 3:** Display map untuk browse restaurants
```dart
// Create markers dari restaurants
final markers = restaurants.map((r) => MapMarker(
  id: r.id,
  title: r.name,
  address: r.address,
  latitude: r.latitude,
  longitude: r.longitude,
  isHalalCertified: r.certificationStatus == CertificationStatus.halal,
  rating: r.averageRating,
)).toList();

// Navigate to map
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => MultiMarkerMapScreen(
      markers: markers,
      onMarkerTap: (marker) {
        // Show restaurant detail
      },
    ),
  ),
);
```

---

## Testing

### Test API Integration
```dart
test('API client should get restaurants', () async {
  final restaurants = await apiClient.get(
    '/restaurants',
    fromJson: (data) => data,
  );
  expect(restaurants, isNotEmpty);
});
```

### Test Image Upload
```dart
test('Image upload should validate file', () {
  final imageService = ImageUploadService();
  final isValid = imageService.isValidImageFile(testImageFile);
  expect(isValid, true);
});
```

### Test Payment
```dart
test('Payment should process successfully', () async {
  final paymentService = PaymentService();
  final result = await paymentService.processPayment(
    reservationId: 'test_res_123',
    amount: 100000,
    paymentMethod: PaymentMethod.creditCard,
    phoneNumber: '081234567890',
  );
  expect(result['status'], 'completed');
});
```

---

## Deployment Checklist

### Before Release:

- [ ] Update `pubspec.yaml` version
- [ ] Remove debug logging
- [ ] Configure API base URL untuk production
- [ ] Setup Firebase credentials (production)
- [ ] Configure payment gateway (production keys)
- [ ] Test semua features di device fisik
- [ ] Run `flutter analyze` untuk check errors
- [ ] Run `flutter test` untuk unit tests
- [ ] Implement proper error handling
- [ ] Add ProGuard/R8 rules untuk Android

### Android Build:
```bash
flutter build apk --release
# atau
flutter build appbundle --release
```

### iOS Build:
```bash
flutter build ios --release
```

---

## Common Issues & Solutions

### Issue: Google Maps blank
**Solution:**
```dart
// Ensure GoogleMapsController is initialized
_mapController.animateCamera(
  CameraUpdate.newLatLng(location),
);
```

### Issue: Image upload timeout
**Solution:**
```dart
// Increase timeout di ApiClient
_dio = Dio(
  BaseOptions(
    receiveTimeout: const Duration(seconds: 60),
  ),
);
```

### Issue: Push notification not received
**Solution:**
```dart
// Check FCM token
final token = await PushNotificationService.getFCMToken();
print('FCM Token: $token');

// Ensure app has notification permission
await PushNotificationService.initialize();
```

---

## Support & Resources

- 📚 [Official Documentation](../README.md)
- 🔧 [Features Documentation](./FEATURES.md)
- 📞 [Contact Support](mailto:support@smwkp.com)
- 💬 [GitHub Issues](https://github.com/yourusername/Aplikasi-SMWKP/issues)
