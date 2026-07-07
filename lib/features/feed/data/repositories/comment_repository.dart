import '../../../../core/database/database_helper.dart';
import '../models/comment_model.dart';

class CommentRepository {
  Future<List<CommentModel>> getComments(int postId) async {
    final db = await DatabaseHelper.database;

    final results = await db.query(
      'comments',
      where: 'postId = ?',
      whereArgs: [postId],
      orderBy: 'createdAt ASC',
    );

    return results.map((e) => CommentModel.fromMap(e)).toList();
  }

  Future<CommentModel> addComment({
    required int postId,
    int? parentId,
    required String username,
    required String text,
  }) async {
    final db = await DatabaseHelper.database;

    final comment = CommentModel(
      postId: postId,
      parentId: parentId,
      username: username,
      text: text,
      avatarUrl: 'assets/task.jpeg',
      createdAt: DateTime.now(),
    );

    final id = await db.insert('comments', comment.toMap());
    return comment.copyWith(id: id);
  }

  Future<CommentModel> toggleCommentLike(CommentModel comment) async {
    final db = await DatabaseHelper.database;

    final updated = comment.copyWith(
      isLiked: !comment.isLiked,
      likesCount: comment.isLiked
          ? (comment.likesCount - 1).clamp(0, double.infinity).toInt()
          : comment.likesCount + 1,
      isDisliked: comment.isDisliked ? false : comment.isDisliked,
      dislikesCount: comment.isDisliked
          ? (comment.dislikesCount - 1).clamp(0, double.infinity).toInt()
          : comment.dislikesCount,
    );

    await db.update('comments', updated.toMap(),
        where: 'id = ?', whereArgs: [comment.id]);

    return updated;
  }

  Future<void> deleteComment(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete('comments', where: 'id = ?', whereArgs: [id]);
  }

  Future<CommentModel> toggleCommentDislike(CommentModel comment) async {
    final db = await DatabaseHelper.database;

    final updated = comment.copyWith(
      isDisliked: !comment.isDisliked,
      dislikesCount: comment.isDisliked
          ? (comment.dislikesCount - 1).clamp(0, double.infinity).toInt()
          : comment.dislikesCount + 1,
      isLiked: comment.isLiked ? false : comment.isLiked,
      likesCount: comment.isLiked
          ? (comment.likesCount - 1).clamp(0, double.infinity).toInt()
          : comment.likesCount,
    );

    await db.update('comments', updated.toMap(),
        where: 'id = ?', whereArgs: [comment.id]);

    return updated;
  }
}
