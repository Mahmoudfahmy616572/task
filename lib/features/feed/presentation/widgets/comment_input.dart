import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/widgets/avatar_widget.dart';

class CommentInput extends StatefulWidget {
  final bool isSubmitting;
  final ValueChanged<String> onSend;
  final String hintText;
  final String? replyingToUsername;
  final VoidCallback? onCancelReply;

  const CommentInput({
    super.key,
    required this.isSubmitting,
    required this.onSend,
    this.hintText = 'Add a comment...',
    this.replyingToUsername,
    this.onCancelReply,
  });

  @override
  CommentInputState createState() => CommentInputState();
}

class CommentInputState extends State<CommentInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(CommentInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isSubmitting && widget.isSubmitting) {
      _controller.clear();
      _hasText = false;
    }
    if (oldWidget.replyingToUsername != widget.replyingToUsername &&
        widget.replyingToUsername != null) {
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotNullOrWhiteSpace;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _onSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
  }

  void requestFocus() {
    _focusNode.requestFocus();
  }

  FocusNode get focusNode => _focusNode;

  void clear() {
    _controller.clear();
    _hasText = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyingToUsername != null)
          Container(
            color: AppColors.inputBackground,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              children: [
                Icon(
                  Icons.reply_rounded,
                  size: 14.sp,
                  color: AppColors.textSecondary,
                ),
                6.horizontalSpace,
                Text(
                  'Replying to @${widget.replyingToUsername}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onCancelReply,
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.close_rounded,
                    size: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
          child: Row(
            children: [
              AvatarWidget(
                size: AvatarWidgetSize.small,
                imageUrl: AppAssets.commentAvatar,
              ),
              10.horizontalSpace,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.send,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                    onSubmitted: _hasText ? (_) => _onSend() : null,
                  ),
                ),
              ),
              8.horizontalSpace,
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _hasText
                      ? AppColors.textPrimary
                      : AppColors.inputBackground,
                ),
                child: IconButton(
                  onPressed: _hasText && !widget.isSubmitting ? _onSend : null,
                  icon: widget.isSubmitting
                      ? SizedBox(
                          width: 18.r,
                          height: 18.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : Icon(
                          Icons.arrow_upward_rounded,
                          size: 20.sp,
                          color: _hasText
                              ? AppColors.white
                              : AppColors.textSecondary,
                        ),
                  style: IconButton.styleFrom(
                    minimumSize: Size(36.r, 36.r),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
