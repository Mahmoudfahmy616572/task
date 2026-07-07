import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';

class FullscreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullscreenImagePage({super.key, required this.imageUrl});

  Future<void> _download(BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/shared_image.jpg');
      final bytes = await File(imageUrl).readAsBytes();
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAF8),
        iconTheme: IconThemeData(color: AppColors.userName),
        title: Text(
          '',
          style: TextStyle(color: AppColors.userName),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded, size: 22.sp, color: AppColors.gradientEnd),
            onPressed: () => _download(context),
          ),
          8.horizontalSpace,
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              maxScale: 5.0,
              child: Center(
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
