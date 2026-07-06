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
    required String username,
    required String text,
  }) async {
    final db = await DatabaseHelper.database;

    final comment = CommentModel(
      postId: postId,
      username: username,
      text: text,
      avatarUrl: 'assets/task.jpeg',
      createdAt: DateTime.now(),
    );

    final id = await db.insert('comments', comment.toMap());
    return comment.copyWith(id: id);
  }
}
