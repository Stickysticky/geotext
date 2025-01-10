import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/auth.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});