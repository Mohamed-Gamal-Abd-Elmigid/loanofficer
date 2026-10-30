import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/theme/app_design.dart';
import 'package:loanofficer/main.dart';
import 'package:loanofficer/screens/forgot_password/create_password_screen.dart';
import 'package:loanofficer/screens/forgot_password/request_reset_screen.dart';
import 'package:loanofficer/screens/forgot_password/verify_email_screen.dart';
import 'package:loanofficer/core/api/api_text.dart';
import 'package:loanofficer/core/components/app_text_field.dart';
import 'package:loanofficer/core/validation/app_validators.dart';
import 'package:loanofficer/screens/forgot_password/password_rules.dart';
import 'package:loanofficer/screens/login_screen.dart';
import 'package:loanofficer/screens/main/financing_screen.dart';
import 'package:loanofficer/screens/main/home_screen.dart';
import 'package:loanofficer/screens/main/main_shell.dart';
import 'package:loanofficer/screens/main/more_screen.dart';
import 'package:loanofficer/splash/splash_screen.dart';

void main() {
  testWidgets('splash opens the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pump();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsWidgets);
  });

  testWidgets('tapping outside a field dismisses the keyboard', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 5));
    await tester.pump();

    await tester.tap(find.byType(TextField).first);
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.tap(find.text('تسجيل الدخول').first);
    await tester.pump();
    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('forgot password opens the reset request', (tester) async {
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: appDesignSize,
        builder: (context, child) =>
            MaterialApp(locale: const Locale('ar'), home: child),
        child: const LoginScreen(),
      ),
    );

    await tester.tap(find.text('نسيت كلمة المرور؟'));
    await tester.pumpAndSettle();

    expect(find.text('إعادة تعين كلمة المرور'), findsOneWidget);
    expect(find.text('استمرار'), findsOneWidget);
  });

  testWidgets('reset request fits a short screen', (tester) async {
    tester.view.physicalSize = const Size(430, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: appDesignSize,
        builder: (context, child) => MaterialApp(home: child),
        child: const RequestResetScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('استمرار'), findsOneWidget);
  });

  testWidgets('successful reset returns to the login screen', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: appDesignSize,
        builder: (context, child) => MaterialApp(home: child),
        child: const CreatePasswordScreen(),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Abcdef1!');
    await tester.enterText(find.byType(TextField).at(1), 'Abcdef1!');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'إعادة تعين'));
    await tester.pumpAndSettle();

    expect(find.text('حسنا..!'), findsOneWidget);

    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('حسنا..!'), findsNothing);
  });

  testWidgets('more screen keeps logout at the bottom', (tester) async {
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: appDesignSize,
        builder: (context, child) => MaterialApp(home: child),
        child: const Scaffold(body: MoreScreen()),
      ),
    );

    await tester.pump();
    expect(find.text('تسجيل الخروج'), findsOneWidget);
    expect(find.text('الاسم'), findsOneWidget);
    expect(find.text('رقم الموظف'), findsOneWidget);
    expect(find.text('الايميل'), findsOneWidget);
    final button = tester.getRect(find.text('تسجيل الخروج'));
    expect(
      button.bottom,
      greaterThan(
        tester.view.physicalSize.height / tester.view.devicePixelRatio * 0.7,
      ),
    );
  });

  testWidgets('main screen switches between its three pages', (tester) async {
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: appDesignSize,
        builder: (context, child) => MaterialApp(home: child),
        child: const MainShell(),
      ),
    );

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('الرئيسية'), findsOneWidget);

    await tester.tap(find.text('ط.تمويلية'));
    await tester.pump();
    expect(find.byType(FinancingScreen), findsOneWidget);
    expect(find.text('طلبات التمويلية'), findsOneWidget);
    expect(find.text('إنشاء طلب تمويل فردي'), findsOneWidget);
    expect(find.text('متابعة طلبات التمويل'), findsOneWidget);

    await tester.tap(find.text('المزيد'));
    await tester.pump();
    await tester.pump();
    expect(find.byType(MoreScreen), findsOneWidget);
    expect(find.text('تسجيل الخروج'), findsOneWidget);
    expect(find.text('الاسم'), findsOneWidget);
  });

  test('same password error is shown in arabic', () {
    expect(
      apiErrorMessage(
        AuthApiException(
          'New password should be different from the old password.',
        ),
      ),
      'كلمة المرور الجديدة يجب أن تختلف عن كلمة المرور القديمة.',
    );
  });

  test('api errors are read as arabic', () {
    expect(
      decodeApiText('Ø¨ÙØ§ÙØ§Øª Ø§ÙØ¯Ø®ÙÙ ØºÙØ± ØµØ­ÙØ­Ø©'),
      'بيانات الدخول غير صحيحة',
    );
    expect(decodeApiText('بيانات الدخول غير صحيحة'), 'بيانات الدخول غير صحيحة');
  });

  test('typing @ completes the tanmeyah domain', () {
    expect(
      AppValidators.completeTanmeyahEmail(previous: 'maged', current: 'maged@'),
      'maged@tanmeyah.com',
    );
    expect(
      AppValidators.completeTanmeyahEmail(previous: 'maged', current: '@maged'),
      'maged@tanmeyah.com',
    );
    expect(
      AppValidators.completeTanmeyahEmail(previous: '', current: '@'),
      '@tanmeyah.com',
    );
    expect(
      AppValidators.completeTanmeyahEmail(
        previous: '',
        current: 'maged@tanmeyah.com',
      ),
      isNull,
    );
    expect(
      AppValidators.completeTanmeyahEmail(
        previous: 'maged@tanmeyah.com',
        current: 'maged@tanmeyah.co',
      ),
      isNull,
    );
  });

  testWidgets('email field fills tanmeyah.com when @ is entered', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: appDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            locale: const Locale('ar'),
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(body: child),
            ),
          );
        },
        child: AppTextField(
          controller: controller,
          hint: 'example@tanmeyah.com',
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'maged@');
    await tester.pump();

    expect(controller.text, 'maged@tanmeyah.com');
  });

  testWidgets('tapping the otp snackbar fills the 5 digit pin', (tester) async {
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: appDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(locale: const Locale('ar'), home: child);
        },
        child: const VerifyEmailScreen(
          email: 'maged@tanmeyah.com',
          employeeId: '1',
          otp: '12345',
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('12345'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(5));

    await tester.tap(find.text('12345'));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, '12345');
    expect(find.text('0'), findsNothing);
  });

  test('email must be a tanmeyah address and phone must be 11 digits', () {
    expect(AppValidators.isTanmeyahEmail('example@tanmeyah.com'), isTrue);
    expect(AppValidators.isTanmeyahEmail('Name@Tanmeyah.com'), isTrue);
    expect(AppValidators.isTanmeyahEmail('name@gmail.com'), isFalse);
    expect(AppValidators.isTanmeyahEmail('example@tanmeyah.com.eg'), isFalse);
    expect(AppValidators.isPhoneNumber('01012345678'), isTrue);
    expect(AppValidators.isPhoneNumber('0101234567'), isFalse);
    expect(AppValidators.isPhoneNumber('010123456789'), isFalse);
  });

  test('password rules require length, mix, symbol, and a match', () {
    expect(isStrongPassword('Abcdef1!', 'Abcdef1!'), isTrue);
    expect(isStrongPassword('abcdef1!', 'abcdef1!'), isFalse);
    expect(isStrongPassword('Abcdef1!', 'Abcdef1'), isFalse);
    expect(passwordRuleMessage(''), isNull);
    expect(passwordRuleMessage('abc'), contains('8 أحرف'));
    expect(passwordRuleMessage('Abcdef1!'), isNull);
    expect(
      confirmPasswordMessage('Abcdef1!', 'Abcdef1'),
      contains('غير متطابقت'),
    );
    expect(confirmPasswordMessage('Abcdef1!', 'Abcdef1!'), isNull);
  });
}
