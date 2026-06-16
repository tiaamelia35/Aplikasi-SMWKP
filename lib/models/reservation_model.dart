enum ReservationStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class ReservationModel {
  final String id;
  final String restaurantId;
  final String userId;
  final String userName;
  final String userPhone;
  final DateTime reservationDate;
  final DateTime reservationTime;
  final int numberOfGuests;
  final String? specialRequest;
  final ReservationStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReservationModel({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.reservationDate,
    required this.reservationTime,
    required this.numberOfGuests,
    this.specialRequest,
    this.status = ReservationStatus.pending,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhone: json['userPhone'] as String,
      reservationDate: DateTime.parse(json['reservationDate'] as String),
      reservationTime: DateTime.parse(json['reservationTime'] as String),
      numberOfGuests: json['numberOfGuests'] as int,
      specialRequest: json['specialRequest'] as String?,
      status: ReservationStatus.values[json['status'] as int? ?? 0],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'reservationDate': reservationDate.toIso8601String(),
      'reservationTime': reservationTime.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'specialRequest': specialRequest,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ReservationModel copyWith({
    String? id,
    String? restaurantId,
    String? userId,
    String? userName,
    String? userPhone,
    DateTime? reservationDate,
    DateTime? reservationTime,
    int? numberOfGuests,
    String? specialRequest,
    ReservationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      reservationDate: reservationDate ?? this.reservationDate,
      reservationTime: reservationTime ?? this.reservationTime,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      specialRequest: specialRequest ?? this.specialRequest,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
