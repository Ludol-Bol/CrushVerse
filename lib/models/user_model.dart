import 'package:cloud_firestore/cloud_firestore.dart';

/// Модель пользователя для приложения
class UserModel {
  final String id;
  final String email;
  final String nickname;
  final String? icon;
  final DateTime? birthDate;
  final DateTime createdAt;
  final String? passwordHash; // Хеш пароля (только для чтения из БД, не сохраняется обратно)

  UserModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.icon,
    this.birthDate,
    required this.createdAt,
    this.passwordHash,
  });

  /// Создание модели из Map (для Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    // Поддержка как Firestore Timestamp, так и строк ISO8601
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.parse(value);
      }
      return null;
    }

    return UserModel(
      id: documentId ?? map['id'] as String? ?? '',
      email: map['email'] as String,
      nickname: map['nickname'] as String,
      icon: map['icon'] as String?,
      birthDate: parseDate(map['birth_date']),
      createdAt: parseDate(map['created_at']) ?? DateTime.now(),
      passwordHash: map['password_hash'] as String?,
    );
  }

  /// Преобразование модели в Map (для Firestore)
  Map<String, dynamic> toMap({bool includeId = false, String? passwordHash}) {
    final map = <String, dynamic>{
      'email': email,
      'nickname': nickname,
      'icon': icon,
      'birth_date': birthDate != null 
          ? Timestamp.fromDate(birthDate!)
          : null,
      'created_at': Timestamp.fromDate(createdAt),
    };
    
    // Добавляем хеш пароля только если он передан
    if (passwordHash != null) {
      map['password_hash'] = passwordHash;
    }
    
    if (includeId) {
      map['id'] = id;
    }
    
    return map;
  }

  /// Создание копии модели с измененными полями
  UserModel copyWith({
    String? id,
    String? email,
    String? nickname,
    String? icon,
    DateTime? birthDate,
    DateTime? createdAt,
    String? passwordHash,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      icon: icon ?? this.icon,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, nickname: $nickname, icon: $icon, birthDate: $birthDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.nickname == nickname &&
        other.icon == icon &&
        other.birthDate == birthDate &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        nickname.hashCode ^
        icon.hashCode ^
        birthDate.hashCode ^
        createdAt.hashCode;
  }
}
