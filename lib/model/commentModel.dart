class CommentModel {
  final int id;
  final int creatorId;
  final int postId;
  final String comment;
  final String likeCount;
  final int status;

//<editor-fold desc="Data Methods">
  const CommentModel({
    required this.id,
    required this.creatorId,
    required this.postId,
    required this.comment,
    required this.likeCount,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommentModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          creatorId == other.creatorId &&
          postId == other.postId &&
          comment == other.comment &&
          likeCount == other.likeCount &&
          status == other.status);

  @override
  int get hashCode =>
      id.hashCode ^
      creatorId.hashCode ^
      postId.hashCode ^
      comment.hashCode ^
      likeCount.hashCode ^
      status.hashCode;

  @override
  String toString() {
    return 'CommentModel{' +
        ' id: $id,' +
        ' creatorId: $creatorId,' +
        ' postId: $postId,' +
        ' comment: $comment,' +
        ' likeCount: $likeCount,' +
        ' status: $status,' +
        '}';
  }

  CommentModel copyWith({
    int? id,
    int? creatorId,
    int? postId,
    String? comment,
    String? likeCount,
    int? status,
  }) {
    return CommentModel(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      postId: postId ?? this.postId,
      comment: comment ?? this.comment,
      likeCount: likeCount ?? this.likeCount,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'creatorId': this.creatorId,
      'postId': this.postId,
      'comment': this.comment,
      'likeCount': this.likeCount,
      'status': this.status,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as int,
      creatorId: map['creatorId'] as int,
      postId: map['postId'] as int,
      comment: map['comment'] as String,
      likeCount: map['likeCount'] as String,
      status: map['status'] as int,
    );
  }

//</editor-fold>
}
