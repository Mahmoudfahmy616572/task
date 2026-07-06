import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCommentInput() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _commentInputKey.currentState?.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.dismissKeyboard(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          final isArabic = localeState.isArabic;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              surfaceTintColor: AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 48.h,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 22.sp,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: _scrollToCommentInput,
                ),
                4.horizontalSpace,
                IconButton(
                  icon: Icon(
                    Icons.language_rounded,
                    size: 22.sp,
                    color: AppColors.textPrimary,
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
                            child: Text(AppLocalizations.get('retry', isArabic ? 'ar' : 'en')),
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
                    scrollController: _scrollController,
                    isArabic: isArabic,
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
  final ScrollController scrollController;
  final bool isArabic;

  const _FeedContent({
    required this.state,
    required this.commentInputKey,
    required this.scrollController,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FeedCubit>();
    final post = state.post;
    final comments = state.comments;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
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
                ...comments.map((comment) {
                  return _AnimatedCommentTile(
                    key: ValueKey(comment.id),
                    comment: comment,
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
          hintText: AppLocalizations.get('addComment', isArabic ? 'ar' : 'en'),
          onSend: (text) => cubit.addComment(text),
        ),
      ],
    );
  }
}

class _AnimatedCommentTile extends StatefulWidget {
  final CommentModel comment;

  const _AnimatedCommentTile({
    super.key,
    required this.comment,
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
            username: widget.comment.username,
            text: widget.comment.text,
            avatarUrl: widget.comment.avatarUrl,
          ),
        ),
      ),
    );
  }
}
