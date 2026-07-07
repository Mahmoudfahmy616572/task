import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/localization/locale_state.dart';
import '../../data/models/comment_model.dart';
import '../cubit/feed_cubit.dart';
import '../cubit/feed_state.dart';
import '../widgets/action_row.dart';
import '../widgets/comment_input.dart';
import '../widgets/comment_tile.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final GlobalKey<CommentInputState> _commentInputKey =
      GlobalKey<CommentInputState>();
  CommentModel? _replyingTo;

  void _onReplyTap(CommentModel comment) {
    setState(() => _replyingTo = comment);
    _commentInputKey.currentState?.requestFocus();
  }

  void _cancelReply() {
    setState(() => _replyingTo = null);
    _commentInputKey.currentState?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.dismissKeyboard(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          final isArabic = localeState.isArabic;
          const gradientColors = [
            Color(0xFFFF7B54),
            Color(0xFFFF4D6D),
          ];
          return Scaffold(
            backgroundColor: const Color(0xFFFCFAF8),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: gradientColors,
                  ),
                ),
              ),
              toolbarHeight: 52.h,
              leading: Padding(
                padding: EdgeInsetsDirectional.only(start: 8.w),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
              title: Text(
                AppLocalizations.get('postTitle', isArabic ? 'ar' : 'en'),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.language_rounded,
                    size: 22.sp,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    context.read<LocaleCubit>().toggle();
                  },
                ),
                8.horizontalSpace,
              ],
            ),
            body: BlocBuilder<FeedCubit, FeedState>(
              builder: (context, state) {
                if (state is FeedLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is FeedError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48.sp,
                            color: AppColors.textSecondary,
                          ),
                          16.verticalSpace,
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          16.verticalSpace,
                          FilledButton.tonal(
                            onPressed: () {
                              context.read<FeedCubit>().loadFeed();
                            },
                            child: Text(AppLocalizations.get(
                                'retry', isArabic ? 'ar' : 'en')),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is FeedLoaded) {
                  return _FeedContent(
                    state: state,
                    commentInputKey: _commentInputKey,
                    isArabic: isArabic,
                    replyingTo: _replyingTo,
                    onReplyTap: _onReplyTap,
                    onCancelReply: _cancelReply,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}

class _FeedContent extends StatelessWidget {
  final FeedLoaded state;
  final GlobalKey<CommentInputState> commentInputKey;
  final bool isArabic;
  final CommentModel? replyingTo;
  final ValueChanged<CommentModel> onReplyTap;
  final VoidCallback onCancelReply;

  const _FeedContent({
    required this.state,
    required this.commentInputKey,
    required this.isArabic,
    required this.replyingTo,
    required this.onReplyTap,
    required this.onCancelReply,
  });

  List<CommentModel> _topLevelComments(List<CommentModel> all) {
    return all.where((c) => c.isTopLevel).toList();
  }

  List<CommentModel> _repliesOf(CommentModel comment, List<CommentModel> all) {
    return all.where((r) => r.parentId == comment.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FeedCubit>();
    final post = state.post;
    final allComments = state.comments;
    final topComments = _topLevelComments(allComments);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostCard(post: post),
                16.verticalSpace,
                ActionRow(
                  isLiked: post.isLiked,
                  isLiking: state.isLiking,
                  likesCount: post.likesCount,
                  commentsCount: post.commentsCount,
                  onLikeTap: () => cubit.toggleLike(),
                  onCommentTap: () {
                    commentInputKey.currentState?.requestFocus();
                  },
                  onShareTap: () {
                    Share.share(post.text);
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.divider,
                    indent: 16.w,
                    endIndent: 16.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 16.w,
                    bottom: 12.h,
                  ),
                  child: Text(
                    'التعليقات',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.sectionTitle,
                    ),
                  ),
                ),
                ...topComments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final comment = entry.value;
                  final replies = _repliesOf(comment, allComments);
                  return _AnimatedCommentTile(
                    key: ValueKey(comment.id),
                    comment: comment,
                    replies: replies,
                    avatarIndex: index,
                    onLike: () => cubit.toggleCommentLike(comment.id!),
                    onDislike: () => cubit.toggleCommentDislike(comment.id!),
                    onReply: () => onReplyTap(comment),
                  );
                }),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
        CommentInput(
          key: commentInputKey,
          isSubmitting: state.isSubmitting,
          hintText:
              AppLocalizations.get('addComment', isArabic ? 'ar' : 'en'),
          replyingToUsername: replyingTo?.username,
          onCancelReply: onCancelReply,
          onSend: (text) {
            cubit.addComment(
              text,
              parentId: replyingTo?.id,
            );
            onCancelReply();
          },
        ),
      ],
    );
  }
}

class _AnimatedCommentTile extends StatefulWidget {
  final CommentModel comment;
  final List<CommentModel> replies;
  final int avatarIndex;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onReply;

  const _AnimatedCommentTile({
    super.key,
    required this.comment,
    required this.replies,
    required this.avatarIndex,
    required this.onLike,
    required this.onDislike,
    required this.onReply,
  });

  @override
  State<_AnimatedCommentTile> createState() => _AnimatedCommentTileState();
}

class _AnimatedCommentTileState extends State<_AnimatedCommentTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: CommentTile(
            comment: widget.comment,
            replies: widget.replies,
            avatarIndex: widget.avatarIndex,
            onLike: widget.onLike,
            onDislike: widget.onDislike,
            onReply: widget.onReply,
          ),
        ),
      ),
    );
  }
}
