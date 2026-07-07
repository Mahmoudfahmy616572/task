import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/comment_model.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final List<CommentModel> replies;
  final int avatarIndex;
  final ValueChanged<int> onLike;
  final VoidCallback onReply;
  final ValueChanged<int>? onDelete;
  final String currentUsername;

  const CommentTile({
    super.key,
    required this.comment,
    this.replies = const [],
    this.avatarIndex = 0,
    required this.onLike,
    required this.onReply,
    this.onDelete,
    this.currentUsername = 'johndoe',
  });

  String _formatTimestamp(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return AppLocalizations.get('now', locale);
    if (diff.inMinutes < 60) {
      return AppLocalizations.get('minutesAgo', locale)
          .replaceFirst('%d', '${diff.inMinutes}');
    }
    if (diff.inHours < 24) {
      return AppLocalizations.get('hoursAgo', locale)
          .replaceFirst('%d', '${diff.inHours}');
    }
    if (diff.inDays < 7) {
      return AppLocalizations.get('daysAgo', locale)
          .replaceFirst('%d', '${diff.inDays}');
    }
    final fmt = DateFormat('d/M/yyyy', locale);
    return fmt.format(date);
  }

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
                              _formatTimestamp(context, comment.createdAt),
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
                                AppLocalizations.get(
                                  'reply', Localizations.localeOf(context).languageCode),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.gradientEnd,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (comment.username == currentUsername && onDelete != null)
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
                        ),
                      ],
                    ),
                  ),
                  AnimatedHeartButton(
                    isLiked: comment.isLiked,
                    count: comment.likesCount,
                    onChanged: (_) => onLike(comment.id!),
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

class AnimatedHeartButton extends StatefulWidget {
  final bool isLiked;
  final int count;
  final ValueChanged<bool> onChanged;

  const AnimatedHeartButton({
    super.key,
    required this.isLiked,
    required this.count,
    required this.onChanged,
  });

  @override
  State<AnimatedHeartButton> createState() => _AnimatedHeartButtonState();
}

class _AnimatedHeartButtonState extends State<AnimatedHeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _rotationAnim;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.9), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 55),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _rotationAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.05), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.05, end: -0.03), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -0.03, end: 0.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedHeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isLiked = widget.isLiked;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    _isLiked = !_isLiked;
    widget.onChanged(_isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnim.value,
          child: Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              size: 18.sp,
              color: _isLiked ? AppColors.gradientEnd : AppColors.timestampGray,
            ),
            3.verticalSpace,
            if (widget.count > 0)
              Text(
                '${widget.count}',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: _isLiked
                      ? AppColors.gradientEnd
                      : AppColors.timestampGray,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
