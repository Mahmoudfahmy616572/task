import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/animated_like_button.dart';

class ActionRow extends StatelessWidget {
  final bool isLiked;
  final bool isLiking;
  final int likesCount;
  final int commentsCount;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;

  const ActionRow({
    super.key,
    required this.isLiked,
    required this.isLiking,
    required this.likesCount,
    required this.commentsCount,
    required this.onLikeTap,
    required this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          AnimatedLikeButton(
            isLiked: isLiked,
            isLiking: isLiking,
            count: likesCount,
            onTap: onLikeTap,
          ),
          24.horizontalSpace,
          GestureDetector(
            onTap: onCommentTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 22.sp,
                  color: AppColors.textSecondary,
                ),
                6.horizontalSpace,
                Text(
                  '$commentsCount',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
