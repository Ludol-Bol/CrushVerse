import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cruch/models/user_model.dart';

/// Репозиторий для работы с пользователями
class UserRepository {
  static const String _collectionName = 'users';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Получить пользователя по ID
  static Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!, documentId: doc.id);
    } catch (e) {
      return null;
    }
  }

  /// Получить пользователя по email
  static Future<UserModel?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) return null;
      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;
      return UserModel.fromMap(data, documentId: doc.id);
    } catch (e) {
      return null;
    }
  }

  /// Получить пользователя по никнейму
  static Future<UserModel?> getUserByNickname(String nickname) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) return null;
      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;
      return UserModel.fromMap(data, documentId: doc.id);
    } catch (e) {
      return null;
    }
  }

  /// Получить всех пользователей
  static Future<List<UserModel>> getAllUsers({
    int? limit,
    String? orderBy,
    bool ascending = true,
  }) async {
    try {
      Query query = _firestore.collection(_collectionName);
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: !ascending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            if (data == null) return null;
            return UserModel.fromMap(data, documentId: doc.id);
          })
          .whereType<UserModel>()
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Создать нового пользователя
  static Future<UserModel?> createUser(UserModel user, {String? passwordHash}) async {
    try {
      print('UserRepository: Начинаем создание пользователя');
      print('UserRepository: ID: ${user.id}');
      print('UserRepository: Email: ${user.email}');
      print('UserRepository: Nickname: ${user.nickname}');
      
      final userMap = user.toMap(includeId: false, passwordHash: passwordHash);
      print('UserRepository: Данные для сохранения: $userMap');
      print('UserRepository: Password hash присутствует: ${userMap.containsKey('password_hash')}');
      if (userMap.containsKey('password_hash')) {
        print('UserRepository: Password hash значение: ${userMap['password_hash']?.toString().substring(0, 20)}...');
      }
      
      print('UserRepository: Сохраняем в Firestore...');
      await _firestore
          .collection(_collectionName)
          .doc(user.id)
          .set(userMap);
      
      print('UserRepository: ✅ Пользователь успешно сохранен в Firestore');
      
      // Проверяем, что пользователь действительно создан
      final createdUser = await getUserById(user.id);
      if (createdUser == null) {
        print('UserRepository: ⚠️ Пользователь не найден после создания');
        return null;
      }
      
      print('UserRepository: ✅ Пользователь подтвержден в базе');
      return createdUser;
    } catch (e, stackTrace) {
      print('UserRepository: ❌ Ошибка при создании пользователя: $e');
      print('UserRepository: Stack trace: $stackTrace');
      return null;
    }
  }

  /// Обновить данные пользователя
  static Future<UserModel?> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(userId)
          .update(updates);
      
      return await getUserById(userId);
    } catch (e) {
      return null;
    }
  }

  /// Обновить никнейм пользователя
  static Future<UserModel?> updateUserNickname(String userId, String newNickname) async {
    return await updateUser(userId, {'nickname': newNickname});
  }

  /// Обновить иконку пользователя
  static Future<UserModel?> updateUserIcon(String userId, String iconUrl) async {
    return await updateUser(userId, {'icon': iconUrl});
  }

  /// Обновить дату рождения пользователя
  static Future<UserModel?> updateUserBirthDate(String userId, DateTime birthDate) async {
    return await updateUser(userId, {'birth_date': Timestamp.fromDate(birthDate)});
  }

  /// Обновить пароль пользователя
  static Future<UserModel?> updateUserPassword(String userId, String passwordHash) async {
    return await updateUser(userId, {'password_hash': passwordHash});
  }

  /// Удалить пользователя
  static Future<bool> deleteUser(String userId) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(userId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Проверить, существует ли пользователь с таким email
  static Future<bool> userExistsByEmail(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  /// Проверить, существует ли пользователь с таким никнеймом
  static Future<bool> userExistsByNickname(String nickname) async {
    final user = await getUserByNickname(nickname);
    return user != null;
  }

  /// Поиск пользователей по никнейму
  static Future<List<UserModel>> searchUsersByNickname(String query) async {
    try {
      // Firestore не поддерживает полнотекстовый поиск напрямую
      // Используем поиск по префиксу (начинается с)
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('nickname', isGreaterThanOrEqualTo: query)
          .where('nickname', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();
      
      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            if (data == null) return null;
            return UserModel.fromMap(data, documentId: doc.id);
          })
          .whereType<UserModel>()
          .toList();
    } catch (e) {
      return [];
    }
  }
}
