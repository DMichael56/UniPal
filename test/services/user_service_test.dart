
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/user_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('UserService', () {
    test('getUser returns a user', () async {
      final userService = UserService();
      final user = await userService.getUser();
      expect(user, isA<User>());
      expect(user.name, 'David Heil');
      expect(user.email, 'up2304778@myport.ac.uk');
    });
  });
}
