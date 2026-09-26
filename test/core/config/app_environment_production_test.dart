import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/core/config/app_environment.dart';

void main() {
  test(
    'debug and profile builds reject production configuration',
    () => expect(AppConfiguration.fromDartDefines, throwsStateError),
    skip: const String.fromEnvironment('APP_ENV') != 'production',
  );
}
