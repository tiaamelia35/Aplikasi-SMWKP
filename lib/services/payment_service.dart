import 'package:smwkp_culinary_tourism/services/api_client.dart';

enum PaymentMethod {
  creditCard,
  debitCard,
  eWallet,
  bankTransfer,
  cod, // Cash on Delivery
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

class PaymentService {
  // Create payment token
  Future<Map<String, dynamic>> createPaymentToken({
    required double amount,
    required String description,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final result = await apiClient.post<Map<String, dynamic>>(
        '/payments/token',
        data: {
          'amount': amount,
          'description': description,
          'email': email,
          'phoneNumber': phoneNumber,
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return result;
    } catch (e) {
      throw Exception('Failed to create payment token: $e');
    }
  }

  // Process payment
  Future<Map<String, dynamic>> processPayment({
    required String reservationId,
    required double amount,
    required PaymentMethod paymentMethod,
    required String phoneNumber,
    String? cardToken,
  }) async {
    try {
      final result = await apiClient.post<Map<String, dynamic>>(
        '/payments/process',
        data: {
          'reservationId': reservationId,
          'amount': amount,
          'paymentMethod': paymentMethod.name,
          'phoneNumber': phoneNumber,
          'cardToken': cardToken,
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return result;
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  // Get payment status
  Future<Map<String, dynamic>> getPaymentStatus({
    required String paymentId,
  }) async {
    try {
      final result = await apiClient.get<Map<String, dynamic>>(
        '/payments/$paymentId/status',
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return result;
    } catch (e) {
      throw Exception('Failed to get payment status: $e');
    }
  }

  // Cancel payment
  Future<void> cancelPayment({required String paymentId}) async {
    try {
      await apiClient.post<Map<String, dynamic>>(
        '/payments/$paymentId/cancel',
        data: {},
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
    } catch (e) {
      throw Exception('Failed to cancel payment: $e');
    }
  }

  // Refund payment
  Future<Map<String, dynamic>> refundPayment({
    required String paymentId,
    double? amount, // Partial refund if specified
  }) async {
    try {
      final result = await apiClient.post<Map<String, dynamic>>(
        '/payments/$paymentId/refund',
        data: {
          if (amount != null) 'amount': amount,
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return result;
    } catch (e) {
      throw Exception('Failed to refund payment: $e');
    }
  }

  // Get payment methods available
  Future<List<String>> getAvailablePaymentMethods() async {
    try {
      // For now return mock data
      // TODO: Fetch from API
      return [
        PaymentMethod.creditCard.name,
        PaymentMethod.debitCard.name,
        PaymentMethod.eWallet.name,
        PaymentMethod.bankTransfer.name,
        PaymentMethod.cod.name,
      ];
    } catch (e) {
      throw Exception('Failed to get payment methods: $e');
    }
  }

  // Validate card
  Future<bool> validateCard({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    try {
      // Basic validation
      if (cardNumber.length < 13 || cardNumber.length > 19) {
        return false;
      }

      if (cvv.length < 3 || cvv.length > 4) {
        return false;
      }

      // Validate expiry date format (MM/YY)
      final parts = expiryDate.split('/');
      if (parts.length != 2) {
        return false;
      }

      final month = int.tryParse(parts[0]);
      final year = int.tryParse(parts[1]);

      if (month == null || year == null || month > 12 || month < 1) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get transaction history
  Future<List<Map<String, dynamic>>> getTransactionHistory({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await apiClient.get<Map<String, dynamic>>(
        '/payments/transactions',
        queryParameters: {
          'userId': userId,
          'page': page,
          'limit': limit,
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );

      final transactions = result['transactions'] as List?;
      return transactions?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      throw Exception('Failed to get transaction history: $e');
    }
  }

  // Format currency
  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  // Calculate booking price
  Future<Map<String, dynamic>> calculateBookingPrice({
    required String restaurantId,
    required int numberOfGuests,
    required DateTime reservationDateTime,
  }) async {
    try {
      final result = await apiClient.post<Map<String, dynamic>>(
        '/reservations/calculate-price',
        data: {
          'restaurantId': restaurantId,
          'numberOfGuests': numberOfGuests,
          'reservationDateTime': reservationDateTime.toIso8601String(),
        },
        fromJson: (data) => Map<String, dynamic>.from(data),
      );
      return result;
    } catch (e) {
      throw Exception('Failed to calculate booking price: $e');
    }
  }
}
