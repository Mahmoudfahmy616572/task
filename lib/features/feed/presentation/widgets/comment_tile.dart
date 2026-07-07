import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/comment_reaction_button.dart';
import '../../data/models/comment_model.dart';

String _formatTimestamp(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
  if (diff.inDays < 7) return 'منذ ${diff.inDays} ي';
  return '${date.day}/${date.month}/${date.year}';
}

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final List<CommentModel> replies;
  final int avatarIndex;
  final ValueChanged<int> onLike;
  final ValueChanged<int> onDislike;
  final VoidCallback onReply;
  final ValueChanged<int>? onDelete;
  final String currentUsername;

  const CommentTile({
    super.key,
    required this.comment,
    this.replies = const [],
    this.avatarIndex = 0,
    required this.onLike,
    required this.onDislike,
    required this.onReply,
    this.onDelete,
    this.currentUsername = 'johndoe',
  });

  @override
  Widget build(BuildContext context) {
    final isTopLevel = comment.isTopLevel;
    final isFirst = avatarIndex % 2 == 0;

    return Padding(
      padding: EdgeInsets.only(
        left: isTopLevel ? 16.w : 44.w,
        right: 16.w,
        bottom: 14.h,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0.5,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        color: const Color(0xFFFFFFFF),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: Directionality.of(context),
                children: [
                  Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFirst
                          ? AppColors.avatarGreen
                          : AppColors.avatarPink,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.username,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.userName,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        6.verticalSpace,
                        Text(
                          comment.text,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            Text(
                              _formatTimestamp(comment.createdAt),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.timestampGray,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            12.horizontalSpace,
                            if (comment.likesCount > 0)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '❤️',
                                    style: TextStyle(fontSize: 11.sp),
                                  ),
                                  3.horizontalSpace,
                                  Text(
                                    '${comment.likesCount}',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppColors.timestampGray,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            12.horizontalSpace,
                            GestureDetector(
                              onTap: onReply,
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                'رد',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.gradientEnd,
                                ),
                              ),
                            ),
                            if (comment.username == currentUsername && onDelete != null) ...[
                              8.horizontalSpace,
                              GestureDetector(
                                onTap: () => onDelete!(comment.id!),
                                behavior: HitTestBehavior.opaque,
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 15.sp,
                                  color: AppColors.timestampGray,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      CommentReactionButton(
                        icon: Icons.thumb_up_outlined,
                        activeIcon: Icons.thumb_up,
                        activeColor: AppColors.textPrimary,
                        inactiveColor: AppColors.timestampGray,
                        count: comment.likesCount,
                        isActive: comment.isLiked,
                        onTap: () => onLike(comment.id!),
                      ),
                      4.verticalSpace,
                      CommentReactionButton(
                        icon: Icons.thumb_down_outlined,
                        activeIcon: Icons.thumb_down,
                        activeColor: AppColors.textPrimary,
                        inactiveColor: AppColors.timestampGray,
                        count: comment.dislikesCount,
                        isActive: comment.isDisliked,
                        onTap: () => onDislike(comment.id!),
                      ),
                    ],
                  ),
                ],
              ),
              if (replies.isNotEmpty) ...[
                10.verticalSpace,
                ...replies.map((reply) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: CommentTile(
                        comment: reply,
                        avatarIndex: avatarIndex + 1,
                        onLike: onLike,
                        onDislike: onDislike,
                        onReply: onReply,
                        onDelete: onDelete,
                        currentUsername: currentUsername,
                      ),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
