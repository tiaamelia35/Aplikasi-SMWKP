// API Response Models
// Gunakan untuk deserialize responses dari backend API

import 'restaurant_model.dart';
import 'review_model.dart';
import 'user_model.dart';

class ApiResponse<T> {

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) => ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      statusCode: json['statusCode'],
      error: json['error'],
    );
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final dynamic error;
}

// Pagination Response
class PaginatedResponse<T> {

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    final items = (json['items'] as List)
        .map((item) => fromJsonT(item))
        .toList();

    return PaginatedResponse(
      items: items,
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
  final List<T> items;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
}

// Authentication Responses
class LoginResponse {

  LoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
      user: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
}

class RegisterResponse {

  RegisterResponse({
    required this.user,
    required this.accessToken,
  });

  // ignore: lines_longer_than_80_chars
  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
      user: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
    );
  final UserModel user;
  final String accessToken;
}

// Restaurant Responses
class RestaurantListResponse {

  RestaurantListResponse({
    required this.restaurants,
    required this.total,
    required this.page,
    required this.limit,
  });

  // ignore: lines_longer_than_80_chars
  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) => RestaurantListResponse(
      restaurants: List<RestaurantModel>.from(
        (json['restaurants'] as List)
            .map((x) => RestaurantModel.fromJson(x))
      ),
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
    );
  final List<RestaurantModel> restaurants;
  final int total;
  final int page;
  final int limit;
}

// Image Upload Response
class ImageUploadResponse {

  ImageUploadResponse({
    required this.imageUrl,
    required this.imagePath,
    required this.size,
    required this.format,
  });

  // ignore: lines_longer_than_80_chars
  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) => ImageUploadResponse(
      imageUrl: json['imageUrl'],
      imagePath: json['imagePath'],
      size: json['size'],
      format: json['format'],
    );
  final String imageUrl;
  final String imagePath;
  final int size;
  final String format;
}

// Payment Response
class PaymentResponse {

  PaymentResponse({
    required this.paymentId,
    required this.status,
    required this.amount,
    required this.method,
    required this.createdAt,
    this.completedAt,
    this.transactionId,
    this.metadata,
  });

  // ignore: lines_longer_than_80_chars
  factory PaymentResponse.fromJson(Map<String, dynamic> json) => PaymentResponse(
      paymentId: json['paymentId'],
      status: json['status'],
      amount: (json['amount'] as num).toDouble(),
      method: json['method'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      transactionId: json['transactionId'],
      metadata: json['metadata'],
    );
  final String paymentId;
  final String status;
  final double amount;
  final String method;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? transactionId;
  final Map<String, dynamic>? metadata;
}

// Reservation Response
class ReservationResponse {

  ReservationResponse({
    required this.reservationId,
    required this.restaurant,
    required this.user,
    required this.reservationDateTime,
    required this.numberOfGuests,
    required this.status,
    required this.totalPrice,
    required this.createdAt, this.payment,
  });

  // ignore: lines_longer_than_80_chars
  factory ReservationResponse.fromJson(Map<String, dynamic> json) => ReservationResponse(
      reservationId: json['reservationId'],
      restaurant: RestaurantModel.fromJson(json['restaurant']),
      user: UserModel.fromJson(json['user']),
      reservationDateTime: DateTime.parse(json['reservationDateTime']),
      numberOfGuests: json['numberOfGuests'],
      status: json['status'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      payment: json['payment'] != null
          ? PaymentResponse.fromJson(json['payment'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  final String reservationId;
  final RestaurantModel restaurant;
  final UserModel user;
  final DateTime reservationDateTime;
  final int numberOfGuests;
  final String status;
  final double totalPrice;
  final PaymentResponse? payment;
  final DateTime createdAt;
}

// Review Response
class ReviewListResponse {

  ReviewListResponse({
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  // ignore: lines_longer_than_80_chars
  factory ReviewListResponse.fromJson(Map<String, dynamic> json) => ReviewListResponse(
      reviews: List<ReviewModel>.from(
        (json['reviews'] as List)
            .map((x) => ReviewModel.fromJson(x))
      ),
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
    );
  final List<ReviewModel> reviews;
  final double averageRating;
  final int totalReviews;
}

// Verification Response
class VerificationResponse {

  VerificationResponse({
    required this.restaurantId,
    required this.isVerified,
    this.verifiedAt,
    this.verificationNotes,
  });

  // ignore: lines_longer_than_80_chars
  factory VerificationResponse.fromJson(Map<String, dynamic> json) => VerificationResponse(
      restaurantId: json['restaurantId'],
      isVerified: json['isVerified'],
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.parse(json['verifiedAt'])
          : null,
      verificationNotes: json['verificationNotes'],
    );
  final String restaurantId;
  final bool isVerified;
  final DateTime? verifiedAt;
  final String? verificationNotes;
}

// Certification Response
class CertificationResponse {

  CertificationResponse({
    required this.restaurantId,
    required this.certificationNumber,
    required this.type,
    required this.issueDate,
    required this.expiryDate,
    required this.isValid,
  });

  // ignore: lines_longer_than_80_chars
  factory CertificationResponse.fromJson(Map<String, dynamic> json) => CertificationResponse(
      restaurantId: json['restaurantId'],
      certificationNumber: json['certificationNumber'],
      type: json['type'],
      issueDate: DateTime.parse(json['issueDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      isValid: json['isValid'],
    );
  final String restaurantId;
  final String certificationNumber;
  final String type;
  final DateTime issueDate;
  final DateTime expiryDate;
  final bool isValid;
}

// Error Response
class ErrorResponse {

  ErrorResponse({
    required this.code,
    required this.message,
    this.details,
    this.statusCode,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
      code: json['code'] ?? 'UNKNOWN_ERROR',
      message: json['message'] ?? 'An error occurred',
      details: json['details'],
      statusCode: json['statusCode'],
    );
  final String code;
  final String message;
  final Map<String, dynamic>? details;
  final int? statusCode;

  @override
  // ignore: lines_longer_than_80_chars
  String toString() => 'ErrorResponse(code: $code, message: $message, statusCode: $statusCode)';
}

// Statistics Response
class StatisticsResponse {

  StatisticsResponse({
    required this.totalRestaurants,
    required this.verifiedRestaurants,
    required this.halalCertifiedRestaurants,
    required this.totalReviews,
    required this.averageRating,
    required this.totalReservations,
    required this.totalUsers,
  });

  // ignore: lines_longer_than_80_chars
  factory StatisticsResponse.fromJson(Map<String, dynamic> json) => StatisticsResponse(
      totalRestaurants: json['totalRestaurants'],
      verifiedRestaurants: json['verifiedRestaurants'],
      halalCertifiedRestaurants: json['halalCertifiedRestaurants'],
      totalReviews: json['totalReviews'],
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReservations: json['totalReservations'],
      totalUsers: json['totalUsers'],
    );
  final int totalRestaurants;
  final int verifiedRestaurants;
  final int halalCertifiedRestaurants;
  final int totalReviews;
  final double averageRating;
  final int totalReservations;
  final int totalUsers;
}
