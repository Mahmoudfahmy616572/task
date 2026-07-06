import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  final int? id;
  final int postId;
  final String username;
  final String text;
  final String avatarUrl;
  final DateTime createdAt;

  const CommentModel({
    this.id,
    required this.postId,
    required this.username,
    required this.text,
    this.avatarUrl = '',
    required this.createdAt,
  });

  CommentModel copyWith({
    int? id,
    int? postId,
    String? username,
    String? text,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      text: text ?? this.text,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'postId': postId,
      'username': username,
      'text': text,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as int?,
      postId: map['postId'] as int,
      username: map['username'] as String,
      text: map['text'] as String,
      avatarUrl: map['avatarUrl'] as String? ?? '',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        postId,
        username,
        text,
        avatarUrl,
        createdAt,
      ];
}
