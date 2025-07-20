enum Role {
  user(jsonName: 'user', viewName: 'Вы'),
  system(jsonName: 'system', viewName: 'Система'),
  assistant(jsonName: 'assistant', viewName: 'Бот');

  /// Имя используемое для форматирования в JSON.
  final String jsonName;

  /// Имя используемое для отображения в приложении.
  final String viewName;

  const Role({required this.jsonName, required this.viewName});

  /// Преобразует jsonName в Role
  static Role fromJsonName(String name) {
    return Role.values.firstWhere(
      (value) => value.jsonName == name,
      orElse: () => Role.user,
    );
  }
}
