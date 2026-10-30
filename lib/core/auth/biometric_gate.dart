import 'package:flutter/services.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:local_auth/local_auth.dart';

class BiometricGate {
  BiometricGate({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  Future<bool> authenticate() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) {
        throw AuthApiException('الجهاز لا يدعم البصمة أو Face ID');
      }
      final canCheck = await _auth.canCheckBiometrics;
      final enrolled = await _auth.getAvailableBiometrics();
      if (!canCheck && enrolled.isEmpty) {
        throw AuthApiException(
          'فعّل البصمة أو Face ID من إعدادات الجهاز أولاً',
        );
      }
      return await _auth.authenticate(
        localizedReason: 'استخدم البصمة أو Face ID لتسجيل الدخول',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on AuthApiException {
      rethrow;
    } on MissingPluginException {
      throw AuthApiException('أعد تشغيل التطبيق بالكامل لتفعيل البصمة');
    } on PlatformException catch (error) {
      switch (error.code) {
        case 'NotAvailable':
        case 'NotEnrolled':
        case 'PasscodeNotSet':
          throw AuthApiException(
            'فعّل البصمة أو Face ID من إعدادات الجهاز أولاً',
          );
        case 'LockedOut':
        case 'PermanentlyLockedOut':
          throw AuthApiException('تم إيقاف البصمة مؤقتاً، حاول لاحقاً');
        default:
          return false;
      }
    }
  }
}
