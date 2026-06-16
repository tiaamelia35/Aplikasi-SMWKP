import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';

class RestaurantModel {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? email;
  final String? websiteUrl;
  final List<String> cuisineTypes;
  final List<String> imageUrls;
  final double averageRating;
  final int reviewCount;
  final RestaurantStatus status;
  final CertificationStatus certificationStatus;
  final String? certificationNumber;
  final DateTime operatingHoursStart;
  final DateTime operatingHoursEnd;
  final int priceRange; // 1-5 scale
  final DateTime createdAt;
  final DateTime updatedAt;

  RestaurantModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.email,
    this.websiteUrl,
    required this.cuisineTypes,
    required this.imageUrls,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.status = RestaurantStatus.pending,
    this.certificationStatus = CertificationStatus.none,
    this.certificationNumber,
    required this.operatingHoursStart,
    required this.operatingHoursEnd,
    this.priceRange = 3,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      cuisineTypes: List<String>.from(json['cuisineTypes'] as List),
      imageUrls: List<String>.from(json['imageUrls'] as List),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      status: RestaurantStatus.values[json['status'] as int? ?? 0],
      certificationStatus: CertificationStatus.values[json['certificationStatus'] as int? ?? 0],
      certificationNumber: json['certificationNumber'] as String?,
      operatingHoursStart: DateTime.parse(json['operatingHoursStart'] as String),
      operatingHoursEnd: DateTime.parse(json['operatingHoursEnd'] as String),
      priceRange: json['priceRange'] as int? ?? 3,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'websiteUrl': websiteUrl,
      'cuisineTypes': cuisineTypes,
      'imageUrls': imageUrls,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'status': status.index,
      'certificationStatus': certificationStatus.index,
      'certificationNumber': certificationNumber,
      'operatingHoursStart': operatingHoursStart.toIso8601String(),
      'operatingHoursEnd': operatingHoursEnd.toIso8601String(),
      'priceRange': priceRange,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  RestaurantModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    String? websiteUrl,
    List<String>? cuisineTypes,
    List<String>? imageUrls,
    double? averageRating,
    int? reviewCount,
    RestaurantStatus? status,
    CertificationStatus? certificationStatus,
    String? certificationNumber,
    DateTime? operatingHoursStart,
    DateTime? operatingHoursEnd,
    int? priceRange,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      imageUrls: imageUrls ?? this.imageUrls,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      status: status ?? this.status,
      certificationStatus: certificationStatus ?? this.certificationStatus,
      certificationNumber: certificationNumber ?? this.certificationNumber,
      operatingHoursStart: operatingHoursStart ?? this.operatingHoursStart,
      operatingHoursEnd: operatingHoursEnd ?? this.operatingHoursEnd,
      priceRange: priceRange ?? this.priceRange,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
