import 'package:flutter_test/flutter_test.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/models.dart';

void main() {
  group('ResetPassword Request & Response Model Tests', () {
    test('ResetPasswordRequestModel serialization and deserialization', () {
      final json = {
        'token': 'test-token-123',
        'newPassword': 'NewStrongPass123!',
        'confirmPassword': 'NewStrongPass123!',
      };

      final model = ResetPasswordRequestModel.fromJson(json);
      expect(model.token, 'test-token-123');
      expect(model.newPassword, 'NewStrongPass123!');
      expect(model.confirmPassword, 'NewStrongPass123!');

      final serialized = model.toJson();
      expect(serialized['token'], 'test-token-123');
      expect(serialized['newPassword'], 'NewStrongPass123!');
      expect(serialized['confirmPassword'], 'NewStrongPass123!');
    });

    test('ResetPasswordResponseModel serialization and deserialization', () {
      final json = {
        'success': true,
        'message': 'User registered successfully',
        'data': <String, dynamic>{},
      };

      final model = ResetPasswordResponseModel.fromJson(json);
      expect(model.success, isTrue);
      expect(model.message, 'User registered successfully');
      expect(model.data, isA<Map<String, dynamic>>());

      final serialized = model.toJson();
      expect(serialized['success'], isTrue);
      expect(serialized['message'], 'User registered successfully');
      expect(serialized['data'], isEmpty);
    });
  });
}

