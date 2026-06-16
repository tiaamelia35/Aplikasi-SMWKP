class ReviewModel {
  final String id;
  final String restaurantId;
  final String userId;
  final String userName;
  final String? userImageUrl;
  final double rating;
  final String title;
  final String content;
  final List<String> imageUrls;
  final int helpfulCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.rating,
    required this.title,
    required this.content,
    this.imageUrls = const [],
    this.helpfulCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userImageUrl: json['userImageUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List? ?? []),
      helpfulCount: json['helpfulCount'] as int? ?? 0,
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
      'userImageUrl': userImageUrl,
      'rating': rating,
      'title': title,
      'content': content,
      'imageUrls': imageUrls,
      'helpfulCount': helpfulCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ReviewModel copyWith({
    String? id,
    String? restaurantId,
    String? userId,
    String? userName,
    String? userImageUrl,
    double? rating,
    String? title,
    String? content,
    List<String>? imageUrls,
    int? helpfulCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
