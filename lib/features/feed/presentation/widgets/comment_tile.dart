import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/avatar_widget.dart';
import '../../../../core/widgets/comment_reaction_button.dart';
import '../../data/models/comment_model.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final List<CommentModel> replies;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onReply;

  const CommentTile({
    super.key,
    required this.comment,
    this.replies = const [],
    required this.onLike,
    required this.onDislike,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final isTopLevel = comment.isTopLevel;

    return Padding(
      padding: EdgeInsets.only(
        left: isTopLevel ? 16.w : 44.w,
        right: 16.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarWidget(
                size: AvatarWidgetSize.small,
                imageUrl: comment.avatarUrl,
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.username,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    2.verticalSpace,
                    Text(
                      comment.text,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                    6.verticalSpace,
                    Row(
                      children: [
                        CommentReactionButton(
                          icon: Icons.thumb_up_outlined,
                          activeIcon: Icons.thumb_up,
                          activeColor: AppColors.textPrimary,
                          inactiveColor: AppColors.textSecondary,
                          count: comment.likesCount,
                          isActive: comment.isLiked,
                          onTap: onLike,
                        ),
                        12.horizontalSpace,
                        CommentReactionButton(
                          icon: Icons.thumb_down_outlined,
                          activeIcon: Icons.thumb_down,
                          activeColor: AppColors.textPrimary,
                          inactiveColor: AppColors.textSecondary,
                          count: comment.dislikesCount,
                          isActive: comment.isDisliked,
                          onTap: onDislike,
                        ),
                        12.horizontalSpace,
                        GestureDetector(
                          onTap: onReply,
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            'Reply',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (replies.isNotEmpty) ...[
            8.verticalSpace,
            ...replies.map((reply) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: CommentTile(
                    comment: reply,
                    onLike: onLike,
                    onDislike: onDislike,
                    onReply: onReply,
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
