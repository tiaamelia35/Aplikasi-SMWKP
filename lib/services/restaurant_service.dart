import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/models/restaurant_model.dart';
import 'package:smwkp_culinary_tourism/models/review_model.dart';
import 'package:smwkp_culinary_tourism/services/api_client.dart';

class RestaurantService {
  Future<List<RestaurantModel>> getRestaurants({
    int page = 1,
    int limit = 20,
    String? searchQuery,
    String? cuisineType,
  }) async {
    try {
      final response = await apiClient.get<List<dynamic>>(
        AppAPI.restaurantsEndpoint,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
          if (cuisineType != null && cuisineType.isNotEmpty) 'cuisineType': cuisineType,
        },
        fromJson: (data) {
          return (data as List<dynamic>);
        },
      );

      return response
          .map((item) => RestaurantModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      // Return sample data untuk testing jika API tidak tersedia
      return [
        RestaurantModel(
          id: '1',
          ownerId: 'owner1',
          name: 'Rumah Makan Pempek Palembang',
          description: 'Restoran pempek tradisional terbaik di Palembang',
          address: 'Jl. Merdeka No. 123, Palembang',
          phone: '0711-123456',
          latitude: -2.9264,
          longitude: 104.7520,
          imageUrls: [],
          cuisineTypes: ['Pempek'],
          operatingHoursStart: DateTime.now(),
          operatingHoursEnd: DateTime.now().add(const Duration(hours: 12)),
          averageRating: 4.5,
          reviewCount: 24,
          status: RestaurantStatus.verified,
          certificationStatus: CertificationStatus.halal,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        RestaurantModel(
          id: '2',
          ownerId: 'owner2',
          name: 'Kafe Tekwan Modern',
          description: 'Kafe dengan menu tekwan yang inovatif',
          address: 'Jl. Ahmad Yani No. 456, Palembang',
          phone: '0711-234567',
          latitude: -2.9300,
          longitude: 104.7600,
          imageUrls: [],
          cuisineTypes: ['Tekwan'],
          operatingHoursStart: DateTime.now(),
          operatingHoursEnd: DateTime.now().add(const Duration(hours: 12)),
          averageRating: 4.2,
          reviewCount: 18,
          status: RestaurantStatus.verified,
          certificationStatus: CertificationStatus.halal,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
  }

  Future<RestaurantModel> getRestaurantById(String restaurantId) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        '${AppAPI.restaurantsEndpoint}/$restaurantId',
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return RestaurantModel.fromJson(response);
    } catch (e) {
      // Return sample data untuk testing
      return RestaurantModel(
        id: restaurantId,
        ownerId: 'owner1',
        name: 'Sample Restaurant',
        description: 'Sample restaurant untuk testing',
        address: 'Jl. Sample No. 123',
        phone: '0711-000000',
        latitude: -2.9264,
        longitude: 104.7520,
        imageUrls: [],
        cuisineTypes: ['Sample'],
        operatingHoursStart: DateTime.now(),
        operatingHoursEnd: DateTime.now().add(const Duration(hours: 12)),
        averageRating: 4.0,
        reviewCount: 0,
        status: RestaurantStatus.verified,
        certificationStatus: CertificationStatus.halal,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<RestaurantModel> addRestaurant({
    required String ownerId,
    required String name,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    String? phone,
    String? email,
    String? websiteUrl,
    required List<String> cuisineTypes,
    required List<String> imageUrls,
    required DateTime operatingHoursStart,
    required DateTime operatingHoursEnd,
    int priceRange = 3,
  }) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        AppAPI.restaurantsEndpoint,
        data: {
          'ownerId': ownerId,
          'name': name,
          'description': description,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          if (phone != null) 'phone': phone,
          if (email != null) 'email': email,
          if (websiteUrl != null) 'websiteUrl': websiteUrl,
          'cuisineTypes': cuisineTypes,
          'imageUrls': imageUrls,
          'operatingHoursStart': operatingHoursStart.toIso8601String(),
          'operatingHoursEnd': operatingHoursEnd.toIso8601String(),
          'priceRange': priceRange,
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return RestaurantModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add restaurant: $e');
    }
  }

  Future<RestaurantModel> updateRestaurant({
    required RestaurantModel restaurant,
  }) async {
    try {
      final response = await apiClient.put<Map<String, dynamic>>(
        '${AppAPI.restaurantsEndpoint}/${restaurant.id}',
        data: restaurant.toJson(),
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return RestaurantModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update restaurant: $e');
    }
  }

  Future<void> deleteRestaurant({required String restaurantId}) async {
    try {
      await apiClient.delete<Map<String, dynamic>>(
        '${AppAPI.restaurantsEndpoint}/$restaurantId',
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
    } catch (e) {
      throw Exception('Failed to delete restaurant: $e');
    }
  }

  Future<List<ReviewModel>> getRestaurantReviews(String restaurantId) async {
    try {
      final response = await apiClient.get<List<dynamic>>(
        '${AppAPI.restaurantsEndpoint}/$restaurantId/reviews',
        fromJson: (data) => (data as List<dynamic>),
      );
      return response
          .map((item) => ReviewModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  Future<void> verifyRestaurant({required String restaurantId}) async {
    try {
      await apiClient.post<Map<String, dynamic>>(
        AppAPI.verifyRestaurantEndpoint.replaceFirst('{id}', restaurantId),
        data: {},
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
    } catch (e) {
      throw Exception('Failed to verify restaurant: $e');
    }
  }

  Future<void> certifyHalal({
    required String restaurantId,
    required String certificationNumber,
  }) async {
    try {
      await apiClient.post<Map<String, dynamic>>(
        AppAPI.certifyHalalEndpoint.replaceFirst('{id}', restaurantId),
        data: {
          'certificationNumber': certificationNumber,
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
    } catch (e) {
      throw Exception('Failed to certify restaurant: $e');
    }
  }
}
