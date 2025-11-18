/// Model de Usuário
class UserModel {
  final String? id;
  final String nome;
  final String email;
  final String? telefone;
  final String? avatarUrl;
  final DateTime? createdAt;

  UserModel({
    this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.avatarUrl,
    this.createdAt,
  });

  // Converter de JSON para UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      nome: json['nome'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? json['phone'],
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'] ?? json['avatar'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
    );
  }

  // Converter de UserModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Criar cópia com modificações
  UserModel copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, nome: $nome, email: $email)';
  }
}
