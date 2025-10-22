import 'package:cruch/models/user_model.dart';
import 'package:cruch/services/supabase_service.dart';

/// Репозиторий для работы с пользователями
class UserRepository {
  
  /// Получить пользователя по ID
  static Future<UserModel?> getUserById(String userId) async {
    try {
      final users = await SupabaseService.getData(
        'users',
        filter: {'id': userId},
        limit: 1,
      );
      
      if (users.isNotEmpty) {
        return UserModel.fromMap(users.first);
      }
      return null;
    } catch (e) {
      print('UserRepository: Ошибка получения пользователя по ID: $e');
      return null;
    }
  }

  /// Получить пользователя по email
  static Future<UserModel?> getUserByEmail(String email) async {
    try {
      final users = await SupabaseService.getData(
        'users',
        filter: {'email': email},
        limit: 1,
      );
      
      if (users.isNotEmpty) {
        return UserModel.fromMap(users.first);
      }
      return null;
    } catch (e) {
      print('UserRepository: Ошибка получения пользователя по email: $e');
      return null;
    }
  }

  /// Получить пользователя по никнейму
  static Future<UserModel?> getUserByNickname(String nickname) async {
    try {
      final users = await SupabaseService.getData(
        'users',
        filter: {'nickname': nickname},
        limit: 1,
      );
      
      if (users.isNotEmpty) {
        return UserModel.fromMap(users.first);
      }
      return null;
    } catch (e) {
      print('UserRepository: Ошибка получения пользователя по никнейму: $e');
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
      final users = await SupabaseService.getData(
        'users',
        limit: limit,
        orderBy: orderBy,
        ascending: ascending,
      );
      
      return users.map((user) => UserModel.fromMap(user)).toList();
    } catch (e) {
      print('UserRepository: Ошибка получения всех пользователей: $e');
      return [];
    }
  }

  /// Обновить данные пользователя
  static Future<UserModel?> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      final updatedUsers = await SupabaseService.updateData(
        'users',
        updates,
        {'id': userId},
      );
      
      if (updatedUsers.isNotEmpty) {
        return UserModel.fromMap(updatedUsers.first);
      }
      return null;
    } catch (e) {
      print('UserRepository: Ошибка обновления пользователя: $e');
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
    return await updateUser(userId, {'birth_date': birthDate.toIso8601String()});
  }

  /// Удалить пользователя
  static Future<bool> deleteUser(String userId) async {
    try {
      await SupabaseService.deleteData('users', {'id': userId});
      return true;
    } catch (e) {
      print('UserRepository: Ошибка удаления пользователя: $e');
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
      // Используем ILIKE для поиска без учета регистра
      final users = await SupabaseService.client
          .from('users')
          .select()
          .ilike('nickname', '%$query%')
          .limit(20);
      
      return users.map((user) => UserModel.fromMap(user)).toList();
    } catch (e) {
      print('UserRepository: Ошибка поиска пользователей: $e');
      return [];
    }
  }
}
