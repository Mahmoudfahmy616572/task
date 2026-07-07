import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/string_extensions.dart';

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

  void clear() {
    _controller.clear();
    _hasText = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.replyingToUsername != null)
            Container(
              color: AppColors.inputBackground,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(
                    Icons.reply_rounded,
                    size: 14.sp,
                    color: AppColors.gradientEnd,
                  ),
                  6.horizontalSpace,
                  Expanded(
                    child: Text(
                      'الرد على @${widget.replyingToUsername}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gradientEnd,
                      ),
                    ),
                  ),
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
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFE0B2),
                  ),
                  child: Icon(
                    Icons.face_rounded,
                    size: 20.sp,
                    color: const Color(0xFFFF9800),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.send,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 12.h,
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
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    ),
                  ),
                  child: IconButton(
                    onPressed:
                        _hasText && !widget.isSubmitting ? _onSend : null,
                    icon: widget.isSubmitting
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Icon(
                            Icons.arrow_upward_rounded,
                            size: 20.sp,
                            color: _hasText
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.5),
                          ),
                    style: IconButton.styleFrom(
                      minimumSize: Size(42.r, 42.r),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const CircleBorder(),
                    ),
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
