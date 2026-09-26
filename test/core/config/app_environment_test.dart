import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/core/config/app_environment.dart';

void main() {
  test('development defaults to a local API endpoint', () {
    final config = AppConfiguration.fromDartDefines();

    expect(config.environment, AppEnvironment.development);
    expect(config.apiBaseUrl.toString(), 'http://localhost:3000/v1');
  });
}
