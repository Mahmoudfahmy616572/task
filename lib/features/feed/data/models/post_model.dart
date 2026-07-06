import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final int? id;
  final String username;
  final String subtitle;
  final String text;
  final String imageUrl;
  final int likesCount;
  final bool isLiked;
  final int commentsCount;

  const PostModel({
    this.id,
    required this.username,
    required this.subtitle,
    required this.text,
    this.imageUrl = '',
    this.likesCount = 0,
    this.isLiked = false,
    this.commentsCount = 0,
  });

  PostModel copyWith({
    int? id,
    String? username,
    String? subtitle,
    String? text,
    String? imageUrl,
    int? likesCount,
    bool? isLiked,
    int? commentsCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      username: username ?? this.username,
      subtitle: subtitle ?? this.subtitle,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'subtitle': subtitle,
      'text': text,
      'imageUrl': imageUrl,
      'likesCount': likesCount,
      'isLiked': isLiked ? 1 : 0,
      'commentsCount': commentsCount,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as int?,
      username: map['username'] as String,
      subtitle: map['subtitle'] as String,
      text: map['text'] as String,
      imageUrl: map['imageUrl'] as String? ?? '',
      likesCount: map['likesCount'] as int? ?? 0,
      isLiked: (map['isLiked'] as int? ?? 0) == 1,
      commentsCount: map['commentsCount'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        subtitle,
        text,
        imageUrl,
        likesCount,
        isLiked,
        commentsCount,
      ];
}
