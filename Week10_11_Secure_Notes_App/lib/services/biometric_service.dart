import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    return _localAuth.canCheckBiometrics;
  }

  Future<bool> authenticate() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Unlock your notes',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return authenticated;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    return _localAuth.getAvailableBiometrics();
  }
}