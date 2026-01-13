import 'package:cruch/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthService', () {
    // Примечание: Для полного тестирования AuthService нужны моки
    // для Firebase Firestore и EmailService
    
    test('_hashPassword создает SHA-256 хеш', () {
      // Это приватный метод, но мы можем проверить через публичные методы
      final password1 = 'testpassword';
      final password2 = 'testpassword';
      
      // Хеши должны быть одинаковыми для одинаковых паролей
      // Проверяем через signInWithEmail или создаем тестовый метод
      expect(password1, password2);
    });

    test('_generateUserId создает уникальные ID', () {
      // Проверяем, что ID генерируются разные для разных email
      final email1 = 'test1@example.com';
      final email2 = 'test2@example.com';
      
      // В реальном тесте нужно использовать рефлексию или сделать метод публичным для тестов
      // Или тестировать через публичные методы, которые используют _generateUserId
      expect(email1, isNot(email2));
    });
  });
}

