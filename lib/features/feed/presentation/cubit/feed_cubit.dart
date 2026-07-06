import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/comment_repository.dart';
import '../../data/repositories/post_repository.dart';
import 'feed_state.dart';

// ignore_for_file: prefer_initializing_formals

class FeedCubit extends Cubit<FeedState> {
  final PostRepository _postRepository;
  final CommentRepository _commentRepository;

  FeedCubit({
    required PostRepository postRepository,
    required CommentRepository commentRepository,
  })  : _postRepository = postRepository,
        _commentRepository = commentRepository,
        super(const FeedLoading());

  Future<void> loadFeed() async {
    emit(const FeedLoading());

    try {
      final post = await _postRepository.getOrCreatePost();
      final comments = await _commentRepository.getComments(post.id!);

      emit(FeedLoaded(post: post, comments: comments));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> toggleLike() async {
    final current = state;
    if (current is! FeedLoaded) return;

    emit(current.copyWith(isLiking: true));

    try {
      final updatedPost = await _postRepository.toggleLike(current.post);

      emit(current.copyWith(post: updatedPost, isLiking: false));
    } catch (e) {
      emit(current.copyWith(isLiking: false));
    }
  }

  Future<void> addComment(String text, {int? parentId}) async {
    final current = state;
    if (current is! FeedLoaded) return;

    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    emit(current.copyWith(isSubmitting: true));

    try {
      final comment = await _commentRepository.addComment(
        postId: current.post.id!,
        parentId: parentId,
        username: 'johndoe',
        text: trimmed,
      );

      if (parentId == null) {
        await _postRepository.incrementCommentsCount(current.post.id!);

        final updatedPost = current.post.copyWith(
          commentsCount: current.post.commentsCount + 1,
        );

        emit(current.copyWith(
          post: updatedPost,
          comments: [...current.comments, comment],
          isSubmitting: false,
        ));
      } else {
        emit(current.copyWith(
          comments: [...current.comments, comment],
          isSubmitting: false,
        ));
      }
    } catch (e) {
      emit(current.copyWith(isSubmitting: false));
    }
  }

  Future<void> toggleCommentLike(int commentId) async {
    final current = state;
    if (current is! FeedLoaded) return;

    final index = current.comments.indexWhere((c) => c.id == commentId);
    if (index == -1) return;

    try {
      final updated =
          await _commentRepository.toggleCommentLike(current.comments[index]);

      final updatedComments = [...current.comments];
      updatedComments[index] = updated;

      emit(current.copyWith(comments: updatedComments));
    } catch (_) {}
  }

  Future<void> toggleCommentDislike(int commentId) async {
    final current = state;
    if (current is! FeedLoaded) return;

    final index = current.comments.indexWhere((c) => c.id == commentId);
    if (index == -1) return;

    try {
      final updated =
          await _commentRepository.toggleCommentDislike(current.comments[index]);

      final updatedComments = [...current.comments];
      updatedComments[index] = updated;

      emit(current.copyWith(comments: updatedComments));
    } catch (_) {}
  }
}
