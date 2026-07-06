import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentReactionButton extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final Color activeColor;
  final Color inactiveColor;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const CommentReactionButton({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.activeColor,
    required this.inactiveColor,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            size: 16.sp,
            color: isActive ? activeColor : inactiveColor,
          ),
          3.horizontalSpace,
          if (count > 0)
            Text(
              '$count',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
        ],
      ),
    );
  }
}
