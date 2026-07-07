import '../../../../core/database/database_helper.dart';
import '../models/post_model.dart';

class PostRepository {
  Future<PostModel> getOrCreatePost() async {
    final db = await DatabaseHelper.database;

    final posts = await db.query('posts', limit: 1);

    if (posts.isNotEmpty) {
      return PostModel.fromMap(posts.first);
    }

    const initial = PostModel(
      username: 'johndoe',
      subtitle: '2026-07-06T15:30:00.000',
      text:
          'The greatest of all time. 5 Ballon d\'Ors, 5 Champions League titles, '
          'and countless records broken. From Madeira to the world — '
          'Cristiano Ronaldo, the legend who redefined greatness.',
      imageUrl: 'assets/task.jpeg',
      likesCount: 142,
      isLiked: false,
      commentsCount: 18,
    );

    final id = await db.insert('posts', initial.toMap());
    return initial.copyWith(id: id);
  }

  Future<PostModel> toggleLike(PostModel post) async {
    final db = await DatabaseHelper.database;

    final updated = post.copyWith(
      isLiked: !post.isLiked,
      likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
    );

    await db.update('posts', updated.toMap(), where: 'id = ?', whereArgs: [post.id]);

    return updated;
  }

  Future<void> incrementCommentsCount(int postId) async {
    final db = await DatabaseHelper.database;
    await db.rawUpdate(
      'UPDATE posts SET commentsCount = commentsCount + 1 WHERE id = ?',
      [postId],
    );
  }
}
