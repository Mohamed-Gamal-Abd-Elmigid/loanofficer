import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/admin/admin_gate.dart';
import 'package:loanofficer/core/components/app_loading.dart';
import 'package:loanofficer/core/components/dismiss_keyboard.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_design.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FmcSession.instance.restore();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtilPlus.enableScale(
      enableWH: () => !kIsWeb,
      enableText: () => !kIsWeb,
    );
    return ScreenUtilPlusInit(
      designSize: appDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      enableScaleWH: () => !kIsWeb,
      enableScaleText: () => !kIsWeb,
      builder: (context, child) {
        return MaterialApp(
          title: kIsWeb ? 'لوحة الإدارة' : 'Loan Officer',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: AppFonts.dinNextArabic,
            scaffoldBackgroundColor: AppColors.white,
            appBarTheme: AppBarTheme(
              centerTitle: false,
              elevation: 0,
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.navy,
              titleTextStyle: AppTypography.appBar(),
            ),
          ),
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, page) {
            return AppLoadingOverlay(
              child: DismissKeyboard(child: page ?? const SizedBox.shrink()),
            );
          },
          home: child,
        );
      },
      child: kIsWeb ? const AdminGate() : const SplashScreen(),
    );
  }
}
