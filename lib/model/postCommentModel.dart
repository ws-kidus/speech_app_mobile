class PostCommentModel {
  final int id;
  final int creatorId;
  final int postId;
  final String comment;
  final bool liked;
  final int likeCount;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const PostCommentModel({
    required this.id,
    required this.creatorId,
    required this.postId,
    required this.comment,
    required this.liked,
    required this.likeCount,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostCommentModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          creatorId == other.creatorId &&
          postId == other.postId &&
          comment == other.comment &&
          liked == other.liked &&
          likeCount == other.likeCount &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      creatorId.hashCode ^
      postId.hashCode ^
      comment.hashCode ^
      liked.hashCode ^
      likeCount.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'PostCommentModel{' +
        ' id: $id,' +
        ' creatorId: $creatorId,' +
        ' postId: $postId,' +
        ' comment: $comment,' +
        ' liked: $liked,' +
        ' likeCount: $likeCount,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  PostCommentModel copyWith({
    int? id,
    int? creatorId,
    int? postId,
    String? comment,
    bool? liked,
    int? likeCount,
    DateTime? createdAt,
  }) {
    return PostCommentModel(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      postId: postId ?? this.postId,
      comment: comment ?? this.comment,
      liked: liked ?? this.liked,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'creatorId': this.creatorId,
      'postId': this.postId,
      'comment': this.comment,
      'liked': this.liked,
      'likeCount': this.likeCount,
      'createdAt': this.createdAt,
    };
  }

  factory PostCommentModel.fromMap(Map<String, dynamic> map) {
    return PostCommentModel(
      id: map['id'] as int,
      creatorId: map['creatorId'] as int,
      postId: map['postId'] as int,
      comment: map['comment'] as String,
      liked: map['liked'] as bool,
      likeCount: map['likeCount'] as int,
      createdAt: map['createdAt'] as DateTime,
    );
  }

//</editor-fold>
}
