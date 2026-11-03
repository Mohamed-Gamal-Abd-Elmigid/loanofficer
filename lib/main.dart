import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:cupertino_ui/cupertino_ui.dart' as cupertino_ui;
import 'package:material_ui/material_ui.dart' as material_ui;
import 'package:loanofficer/presenter/admin_gate/scene/admin_gate_scene.dart';
import 'package:loanofficer/core/auth/session_guard.dart';
import 'package:loanofficer/core/components/app_loading.dart';
import 'package:loanofficer/core/components/dismiss_keyboard.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_design.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/splash/scene/splash_scene.dart';

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
          navigatorKey: appNavigatorKey,
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
            // bottom_picker: material_ui sheet + cupertino_ui date wheels.
            material_ui.GlobalMaterialLocalizations.delegate,
            cupertino_ui.GlobalCupertinoLocalizations.delegate,
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
      child: kIsWeb ? const AdminGateScene() : const SplashScene(),
    );
  }
}
