/// Модель пользователя для приложения
class UserModel {
  final String id;
  final String email;
  final String nickname;
  final String? icon;
  final DateTime? birthDate;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.icon,
    this.birthDate,
    required this.createdAt,
  });

  /// Создание модели из Map (например, из Supabase)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      nickname: map['nickname'] as String,
      icon: map['icon'] as String?,
      birthDate: map['birth_date'] != null 
          ? DateTime.parse(map['birth_date'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Преобразование модели в Map (для Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'icon': icon,
      'birth_date': birthDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Создание копии модели с измененными полями
  UserModel copyWith({
    String? id,
    String? email,
    String? nickname,
    String? icon,
    DateTime? birthDate,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      icon: icon ?? this.icon,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
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
