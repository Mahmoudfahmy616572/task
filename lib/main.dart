import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/localization/locale_cubit.dart';
import 'core/localization/locale_state.dart';
import 'core/theme/app_theme.dart';
import 'features/feed/data/repositories/comment_repository.dart';
import 'features/feed/data/repositories/post_repository.dart';
import 'features/feed/presentation/cubit/feed_cubit.dart';
import 'features/feed/presentation/pages/feed_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final postRepository = PostRepository();
  final commentRepository = CommentRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<FeedCubit>(
          create: (_) => FeedCubit(
            postRepository: postRepository,
            commentRepository: commentRepository,
          )..loadFeed(),
        ),
        BlocProvider<LocaleCubit>(
          create: (_) => LocaleCubit(),
        ),
      ],
      child: const TaskApp(),
    ),
  );
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return MaterialApp(
              title: 'Social Feed',
              debugShowCheckedModeBanner: false,
              locale: Locale(localeState.locale),
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: AppTheme.light,
              home: Directionality(
                textDirection:
                    localeState.isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: child!,
              ),
            );
          },
        );
      },
      child: FeedPage(),
    );
  }
}
