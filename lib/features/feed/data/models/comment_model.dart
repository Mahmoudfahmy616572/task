import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  final int? id;
  final int postId;
  final int? parentId;
  final String username;
  final String text;
  final String avatarUrl;
  final DateTime createdAt;
  final int likesCount;
  final int dislikesCount;
  final bool isLiked;
  final bool isDisliked;

  const CommentModel({
    this.id,
    required this.postId,
    this.parentId,
    required this.username,
    required this.text,
    this.avatarUrl = '',
    required this.createdAt,
    this.likesCount = 0,
    this.dislikesCount = 0,
    this.isLiked = false,
    this.isDisliked = false,
  });

  bool get isTopLevel => parentId == null;

  CommentModel copyWith({
    int? id,
    int? postId,
    int? parentId,
    String? username,
    String? text,
    String? avatarUrl,
    DateTime? createdAt,
    int? likesCount,
    int? dislikesCount,
    bool? isLiked,
    bool? isDisliked,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      parentId: parentId ?? this.parentId,
      username: username ?? this.username,
      text: text ?? this.text,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      dislikesCount: dislikesCount ?? this.dislikesCount,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'postId': postId,
      if (parentId != null) 'parentId': parentId,
      'username': username,
      'text': text,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'dislikesCount': dislikesCount,
      'isLiked': isLiked ? 1 : 0,
      'isDisliked': isDisliked ? 1 : 0,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as int?,
      postId: map['postId'] as int,
      parentId: map['parentId'] as int?,
      username: map['username'] as String,
      text: map['text'] as String,
      avatarUrl: map['avatarUrl'] as String? ?? '',
      createdAt: DateTime.parse(map['createdAt'] as String),
      likesCount: map['likesCount'] as int? ?? 0,
      dislikesCount: map['dislikesCount'] as int? ?? 0,
      isLiked: (map['isLiked'] as int? ?? 0) == 1,
      isDisliked: (map['isDisliked'] as int? ?? 0) == 1,
    );
  }

  @override
  List<Object?> get props => [
        id,
        postId,
        parentId,
        username,
        text,
        avatarUrl,
        createdAt,
        likesCount,
        dislikesCount,
        isLiked,
        isDisliked,
      ];
}
