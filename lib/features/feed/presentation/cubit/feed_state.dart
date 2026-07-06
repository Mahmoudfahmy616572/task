import 'package:equatable/equatable.dart';

import '../../data/models/comment_model.dart';
import '../../data/models/post_model.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  final PostModel post;
  final List<CommentModel> comments;
  final bool isLiking;
  final bool isSubmitting;

  const FeedLoaded({
    required this.post,
    required this.comments,
    this.isLiking = false,
    this.isSubmitting = false,
  });

  FeedLoaded copyWith({
    PostModel? post,
    List<CommentModel>? comments,
    bool? isLiking,
    bool? isSubmitting,
  }) {
    return FeedLoaded(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      isLiking: isLiking ?? this.isLiking,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [post, comments, isLiking, isSubmitting];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object?> get props => [message];
}
