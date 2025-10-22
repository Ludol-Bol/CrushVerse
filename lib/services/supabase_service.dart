import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Получение экземпляра Supabase клиента
  static SupabaseClient get client => Supabase.instance.client;
  
  // Получение текущего пользователя
  static User? get currentUser => client.auth.currentUser;
  
  // Проверка, авторизован ли пользователь
  static bool get isAuthenticated => currentUser != null;
  
  // МЕТОДЫ АУТЕНТИФИКАЦИИ
  
  /// Регистрация пользователя с email и паролем
  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }
  
  /// Вход с email и паролем
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  /// Вход через Google
  static Future<bool> signInWithGoogle() async {
    return await client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.cruch://login-callback/',
    );
  }
  
  /// Выход из аккаунта
  static Future<void> signOut() async {
    await client.auth.signOut();
  }
  
  /// Сброс пароля
  static Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }
  
  // МЕТОДЫ РАБОТЫ С БАЗОЙ ДАННЫХ
  
  /// Получить данные из таблицы
  /// Пример: getData('users', filter: {'id': userId})
  static Future<List<Map<String, dynamic>>> getData(
    String table, {
    Map<String, dynamic>? filter,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    dynamic query = client.from(table).select();
    
    // Применение фильтров
    if (filter != null) {
      filter.forEach((key, value) {
        query = query.eq(key, value);
      });
    }
    
    // Сортировка
    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }
    
    // Лимит
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return await query;
  }
  
  /// Вставить данные в таблицу
  static Future<List<Map<String, dynamic>>> insertData(
    String table,
    Map<String, dynamic> data,
  ) async {
    return await client.from(table).insert(data).select();
  }
  
  /// Обновить данные в таблице
  static Future<List<Map<String, dynamic>>> updateData(
    String table,
    Map<String, dynamic> data,
    Map<String, dynamic> filter,
  ) async {
    var query = client.from(table).update(data);
    
    filter.forEach((key, value) {
      query = query.eq(key, value);
    });
    
    return await query.select();
  }
  
  /// Удалить данные из таблицы
  static Future<void> deleteData(
    String table,
    Map<String, dynamic> filter,
  ) async {
    var query = client.from(table).delete();
    
    filter.forEach((key, value) {
      query = query.eq(key, value);
    });
    
    await query;
  }
  
  // МЕТОДЫ РАБОТЫ С STORAGE (хранилище файлов)
  
  /// Загрузить файл
  static Future<String> uploadFile(
    String bucket,
    String path,
    Uint8List fileBytes,
  ) async {
    await client.storage.from(bucket).uploadBinary(path, fileBytes);
    return client.storage.from(bucket).getPublicUrl(path);
  }
  
  /// Получить публичный URL файла
  static String getPublicUrl(String bucket, String path) {
    return client.storage.from(bucket).getPublicUrl(path);
  }
  
  /// Удалить файл
  static Future<void> deleteFile(String bucket, String path) async {
    await client.storage.from(bucket).remove([path]);
  }
  
  // REALTIME ПОДПИСКИ
  
  /// Подписаться на изменения в таблице
  static RealtimeChannel subscribeToTable(
    String table,
    void Function(PostgresChangePayload payload) callback,
  ) {
    return client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          callback: callback,
        )
        .subscribe();
  }
}

