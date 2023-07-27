class PostModel {
  final int id;
  final String speech;
  final int creatorId;
  final String creatorName;
  final bool liked;
  final int likeCount;
  final int commentCount;
  final int repostCount;
  final List<ImageModel> images;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const PostModel({
    required this.id,
    required this.speech,
    required this.creatorId,
    required this.creatorName,
    required this.liked,
    required this.likeCount,
    required this.commentCount,
    required this.repostCount,
    required this.images,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          speech == other.speech &&
          creatorId == other.creatorId &&
          creatorName == other.creatorName &&
          liked == other.liked &&
          likeCount == other.likeCount &&
          commentCount == other.commentCount &&
          repostCount == other.repostCount &&
          images == other.images &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      speech.hashCode ^
      creatorId.hashCode ^
      creatorName.hashCode ^
      liked.hashCode ^
      likeCount.hashCode ^
      commentCount.hashCode ^
      repostCount.hashCode ^
      images.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'PostModel{' +
        ' id: $id,' +
        ' speech: $speech,' +
        ' creatorId: $creatorId,' +
        ' creatorName: $creatorName,' +
        ' liked: $liked,' +
        ' likeCount: $likeCount,' +
        ' commentCount: $commentCount,' +
        ' repostCount: $repostCount,' +
        ' images: $images,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  PostModel copyWith({
    int? id,
    String? speech,
    int? creatorId,
    String? creatorName,
    bool? liked,
    int? likeCount,
    int? commentCount,
    int? repostCount,
    List<ImageModel>? images,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      speech: speech ?? this.speech,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      liked: liked ?? this.liked,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      repostCount: repostCount ?? this.repostCount,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'speech': this.speech,
      'creatorId': this.creatorId,
      'creatorName': this.creatorName,
      'liked': this.liked,
      'likeCount': this.likeCount,
      'commentCount': this.commentCount,
      'repostCount': this.repostCount,
      'images': this.images,
      'createdAt': this.createdAt,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    final List<ImageModel> images = [];
    map['images'].map((e) => images.add(ImageModel.fromMap(e))).toList();

    return PostModel(
      id: map['id'],
      speech: map['speech'],
      creatorId: map['creatorId'],
      creatorName: map['creatorName'],
      liked: map['liked'],
      likeCount: map['likeCount'],
      commentCount: map['commentCount'],
      repostCount: map['repostCount'],
      images: images,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

//</editor-fold>
}

class ImageModel {
  final int id;
  final int creatorId;
  final String imageTitle;
  final String imageUrl;

//<editor-fold desc="Data Methods">

  const ImageModel({
    required this.id,
    required this.creatorId,
    required this.imageTitle,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImageModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          creatorId == other.creatorId &&
          imageTitle == other.imageTitle &&
          imageUrl == other.imageUrl);

  @override
  int get hashCode =>
      id.hashCode ^
      creatorId.hashCode ^
      imageTitle.hashCode ^
      imageUrl.hashCode;

  @override
  String toString() {
    return 'ImageModel{' +
        ' id: $id,' +
        ' creatorId: $creatorId,' +
        ' imageTitle: $imageTitle,' +
        ' imageUrl: $imageUrl,' +
        '}';
  }

  ImageModel copyWith({
    int? id,
    int? creatorId,
    String? imageTitle,
    String? imageUrl,
  }) {
    return ImageModel(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      imageTitle: imageTitle ?? this.imageTitle,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'creatorId': this.creatorId,
      'imageTitle': this.imageTitle,
      'imageUrl': this.imageUrl,
    };
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      creatorId: map['creatorId'],
      imageTitle: map['imageTitle'],
      imageUrl: map['imageUrl'],
    );
  }

//</editor-fold>
}
