import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarWidget extends StatelessWidget {
  final double size;
  final String imageUrl;
  final VoidCallback? onTap;

  const AvatarWidget({
    super.key,
    required this.size,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: AssetImage(imageUrl),
      ),
    );
  }
}

class AvatarWidgetSize {
  AvatarWidgetSize._();

  static double get small => 32.r;
  static double get medium => 40.r;
  static double get large => 48.r;
}
