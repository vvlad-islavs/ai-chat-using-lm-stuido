class AiModel {
  final String id;
  final String object;
  final String ownedBy;

  AiModel({required this.id, required this.object, required this.ownedBy});

  factory AiModel.fromJson(Map<String, dynamic> json) =>
      AiModel(id: json['id'], object: json['object'], ownedBy: json['owned_by']);
}
