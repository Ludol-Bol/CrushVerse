import 'package:cruch/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    test('fromMap создает корректный UserModel из Map', () {
      final now = DateTime.now();
      final map = {
        'email': 'test@example.com',
        'nickname': 'testuser',
        'created_at': Timestamp.fromDate(now),
      };

      final user = UserModel.fromMap(map, documentId: 'user123');

      expect(user.id, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.nickname, 'testuser');
      expect(user.createdAt.year, now.year);
      expect(user.createdAt.month, now.month);
      expect(user.createdAt.day, now.day);
    });

    test('toMap создает корректный Map из UserModel', () {
      final now = DateTime.now();
      final user = UserModel(
        id: 'user123',
        email: 'test@example.com',
        nickname: 'testuser',
        createdAt: now,
      );

      final map = user.toMap(includeId: true);

      expect(map['id'], 'user123');
      expect(map['email'], 'test@example.com');
      expect(map['nickname'], 'testuser');
      expect(map['created_at'], isA<Timestamp>());
    });

    test('toMap включает passwordHash когда передан', () {
      final user = UserModel(
        id: 'user123',
        email: 'test@example.com',
        nickname: 'testuser',
        createdAt: DateTime.now(),
      );

      final map = user.toMap(passwordHash: 'hashed_password');

      expect(map['password_hash'], 'hashed_password');
    });

    test('copyWith создает копию с измененными полями', () {
      final user = UserModel(
        id: 'user123',
        email: 'test@example.com',
        nickname: 'testuser',
        createdAt: DateTime.now(),
      );

      final updatedUser = user.copyWith(nickname: 'newuser');

      expect(updatedUser.id, 'user123');
      expect(updatedUser.email, 'test@example.com');
      expect(updatedUser.nickname, 'newuser');
      expect(updatedUser.createdAt, user.createdAt);
    });
  });
}

