import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/post_model.dart';
import 'post_header.dart';
import 'post_image.dart';
import 'post_text.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostHeader(
          username: post.username,
          subtitle: post.subtitle,
        ),
        12.verticalSpace,
        PostTextWidget(text: post.text),
        16.verticalSpace,
        PostImage(imageUrl: post.imageUrl),
      ],
    );
  }
}
