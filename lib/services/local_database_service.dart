import 'package:hive/hive.dart';
import 'package:smwkp_culinary_tourism/models/restaurant_model.dart';
import 'package:smwkp_culinary_tourism/models/user_model.dart';
import 'package:smwkp_culinary_tourism/models/review_model.dart';

class LocalDatabaseService {
  // Box names
  static const String restaurantsBox = 'restaurants';
  static const String usersBox = 'users';
  static const String reviewsBox = 'reviews';
  static const String favoritesBox = 'favorites';
  static const String cacheBox = 'cache';

  static bool _initialized = false;

  // Initialize Hive
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Register adapters if using Hive objects
      // Hive.registerAdapter(RestaurantAdapter());
      // Hive.registerAdapter(UserAdapter());
      // Hive.registerAdapter(ReviewAdapter());

      // Open boxes
      await Hive.openBox<Map>(restaurantsBox);
      await Hive.openBox<Map>(usersBox);
      await Hive.openBox<Map>(reviewsBox);
      await Hive.openBox<String>(favoritesBox);
      await Hive.openBox<Map>(cacheBox);

      _initialized = true;
      print('Local database initialized successfully');
    } catch (e) {
      print('Error initializing local database: $e');
    }
  }

  // Restaurant caching
  static Future<void> cacheRestaurants(List<RestaurantModel> restaurants) async {
    try {
      final box = Hive.box<Map>(restaurantsBox);
      await box.clear();

      for (final restaurant in restaurants) {
        await box.put(restaurant.id, restaurant.toJson());
      }
    } catch (e) {
      print('Error caching restaurants: $e');
    }
  }

  static Future<List<RestaurantModel>> getCachedRestaurants() async {
    try {
      final box = Hive.box<Map>(restaurantsBox);
      final restaurants = <RestaurantModel>[];

      for (final value in box.values) {
        restaurants.add(RestaurantModel.fromJson(
          Map<String, dynamic>.from(value),
        ));
      }

      return restaurants;
    } catch (e) {
      print('Error getting cached restaurants: $e');
      return [];
    }
  }

  static Future<void> cacheRestaurant(RestaurantModel restaurant) async {
    try {
      final box = Hive.box<Map>(restaurantsBox);
      await box.put(restaurant.id, restaurant.toJson());
    } catch (e) {
      print('Error caching restaurant: $e');
    }
  }

  static Future<RestaurantModel?> getCachedRestaurant(String id) async {
    try {
      final box = Hive.box<Map>(restaurantsBox);
      final data = box.get(id);

      if (data != null) {
        return RestaurantModel.fromJson(
          Map<String, dynamic>.from(data),
        );
      }
    } catch (e) {
      print('Error getting cached restaurant: $e');
    }
    return null;
  }

  // User caching
  static Future<void> cacheUser(UserModel user) async {
    try {
      final box = Hive.box<Map>(usersBox);
      await box.put(user.id, user.toJson());
    } catch (e) {
      print('Error caching user: $e');
    }
  }

  static Future<UserModel?> getCachedUser(String id) async {
    try {
      final box = Hive.box<Map>(usersBox);
      final data = box.get(id);

      if (data != null) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(data),
        );
      }
    } catch (e) {
      print('Error getting cached user: $e');
    }
    return null;
  }

  // Review caching
  static Future<void> cacheReviews(List<ReviewModel> reviews) async {
    try {
      final box = Hive.box<Map>(reviewsBox);
      await box.clear();

      for (final review in reviews) {
        await box.put(review.id, review.toJson());
      }
    } catch (e) {
      print('Error caching reviews: $e');
    }
  }

  static Future<List<ReviewModel>> getCachedReviews() async {
    try {
      final box = Hive.box<Map>(reviewsBox);
      final reviews = <ReviewModel>[];

      for (final value in box.values) {
        reviews.add(ReviewModel.fromJson(
          Map<String, dynamic>.from(value),
        ));
      }

      return reviews;
    } catch (e) {
      print('Error getting cached reviews: $e');
      return [];
    }
  }

  // Favorites management
  static Future<void> addFavorite(String restaurantId) async {
    try {
      final box = Hive.box<String>(favoritesBox);
      await box.put(restaurantId, restaurantId);
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  static Future<void> removeFavorite(String restaurantId) async {
    try {
      final box = Hive.box<String>(favoritesBox);
      await box.delete(restaurantId);
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  static Future<List<String>> getFavorites() async {
    try {
      final box = Hive.box<String>(favoritesBox);
      return box.values.toList();
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  static Future<bool> isFavorite(String restaurantId) async {
    try {
      final box = Hive.box<String>(favoritesBox);
      return box.containsKey(restaurantId);
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  // Generic cache operations
  static Future<void> setCacheValue(String key, Map<String, dynamic> value) async {
    try {
      final box = Hive.box<Map>(cacheBox);
      await box.put(key, value);
    } catch (e) {
      print('Error setting cache value: $e');
    }
  }

  static Future<Map<String, dynamic>?> getCacheValue(String key) async {
    try {
      final box = Hive.box<Map>(cacheBox);
      final data = box.get(key);

      if (data != null) {
        return Map<String, dynamic>.from(data);
      }
    } catch (e) {
      print('Error getting cache value: $e');
    }
    return null;
  }

  static Future<void> clearCache() async {
    try {
      final box = Hive.box<Map>(cacheBox);
      await box.clear();
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  // Database cleanup
  static Future<void> clearAllData() async {
    try {
      await Hive.box<Map>(restaurantsBox).clear();
      await Hive.box<Map>(usersBox).clear();
      await Hive.box<Map>(reviewsBox).clear();
      await Hive.box<String>(favoritesBox).clear();
      await Hive.box<Map>(cacheBox).clear();
      print('All local data cleared');
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  // Cache statistics
  static Future<Map<String, int>> getCacheStats() async {
    try {
      return {
        'restaurants': Hive.box<Map>(restaurantsBox).length,
        'users': Hive.box<Map>(usersBox).length,
        'reviews': Hive.box<Map>(reviewsBox).length,
        'favorites': Hive.box<String>(favoritesBox).length,
        'cache': Hive.box<Map>(cacheBox).length,
      };
    } catch (e) {
      print('Error getting cache stats: $e');
      return {};
    }
  }

  // Search in cached restaurants
  static Future<List<RestaurantModel>> searchCachedRestaurants(String query) async {
    try {
      final restaurants = await getCachedRestaurants();
      return restaurants
          .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching cached restaurants: $e');
      return [];
    }
  }

  // Filter cached restaurants
  static Future<List<RestaurantModel>> filterCachedRestaurants({
    double? minRating,
    List<String>? cuisineTypes,
  }) async {
    try {
      final restaurants = await getCachedRestaurants();
      
      return restaurants.where((r) {
        if (minRating != null && r.averageRating < minRating) {
          return false;
        }
        
        if (cuisineTypes != null && cuisineTypes.isNotEmpty) {
          final hasCuisine = r.cuisineTypes
              .any((type) => cuisineTypes.contains(type));
          if (!hasCuisine) {
            return false;
          }
        }
        
        return true;
      }).toList();
    } catch (e) {
      print('Error filtering cached restaurants: $e');
      return [];
    }
  }
}
