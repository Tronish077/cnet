class Listing {
  final String id;
  final String ownerObjRef;
  final String title;
  final String description;
  final String price;
  final String condition;
  final List<String> tags;
  final List<String> imageUrls;
  final String category;
  final String location;
  final String status;
  final String ownerId;
  final String ownerName;
  final String ownerContact;
  final String ownerProfileImage;
  final int shareCount;
  final int inquireCount;
  final int commentCount;
  final int viewCount;
  final int followCount;
  final DateTime createdAt;
  final int engagementScore;
  final int ratings;
  final int ratingsCount;

  Listing({
    required this.id,
    required this.ownerObjRef,
    required this.title,
    required this.description,
    required this.price,
    required this.condition,
    required this.tags,
    required this.imageUrls,
    required this.category,
    required this.location,
    required this.status,
    required this.ownerId,
    required this.ownerName,
    required this.ownerContact,
    required this.ownerProfileImage,
    required this.shareCount,
    required this.inquireCount,
    required this.commentCount,
    required this.viewCount,
    required this.followCount,
    required this.createdAt,
    required this.engagementScore,
    required this.ratings,
    required this.ratingsCount,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['postId'] ?? '',
      ownerObjRef: json['user']['_id'] ?? json['user'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0',
      condition: json['condition'] ?? '',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      imageUrls: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? '',
      ownerId: json['ownerId'] ?? '',
      ownerName: json['ownerName'] ?? '',
      ownerContact: json['ownerContact'] ?? '',
      ownerProfileImage: json['ownerProfileImage'] ?? '',
      viewCount: json['viewCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      ratings: json['ratings'] ?? 0,
      ratingsCount: json['ratingsCount'] ?? 0,
      commentCount: json['commentsCount'] ?? 0,
      followCount: json['followCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      engagementScore: json['engagementScore'] ?? 0,
      inquireCount: json['inquireCount'] ?? 0,
    );
  }


  Listing copyWith({
    String? id,
    String? title,
    String? description,
    String? price,
    String? condition,
    List<String>? tags,
    List<String>? imageUrls,
    String? category,
    String? location,
    String? status,
    String? ownerId,
    String? ownerName,
    String? ownerContact,
    String? ownerProfileImage,
    int? shareCount,
    int? inquireCount,
    int? commentCount,
    int? viewCount,
    int? followCount,
    DateTime? createdAt,
    int? engagementScore,
    int? ratings,
    int? ratingsCount,
  }) {
    return Listing(
      id: id ?? this.id,
      ownerObjRef: ownerObjRef,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      condition: condition ?? this.condition,
      tags: tags ?? this.tags,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      location: location ?? this.location,
      status: status ?? this.status,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerContact: ownerContact ?? this.ownerContact,
      ownerProfileImage: ownerProfileImage ?? this.ownerProfileImage,
      shareCount: shareCount ?? this.shareCount,
      inquireCount: inquireCount ?? this.inquireCount,
      commentCount: commentCount ?? this.commentCount,
      viewCount: viewCount ?? this.viewCount,
      followCount: followCount ?? this.followCount,
      createdAt: createdAt ?? this.createdAt,
      engagementScore: engagementScore ?? this.engagementScore,
      ratings: ratings ?? this.ratings,
      ratingsCount: ratingsCount ?? this.ratingsCount,
    );
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Listing && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
