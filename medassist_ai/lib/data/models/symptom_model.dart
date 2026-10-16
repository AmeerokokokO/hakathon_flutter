class Symptom {
  final String id;
  final String name;
  final String nameAr;
  final String category;
  final String categoryAr;
  final String severity; // mild, moderate, severe
  final String iconEmoji;
  final String description;
  final String descriptionAr;

  Symptom({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.category,
    required this.categoryAr,
    required this.severity,
    required this.iconEmoji,
    required this.description,
    required this.descriptionAr,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      category: json['category'] ?? '',
      categoryAr: json['categoryAr'] ?? '',
      severity: json['severity'] ?? 'mild',
      iconEmoji: json['iconEmoji'] ?? '💊',
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'category': category,
      'categoryAr': categoryAr,
      'severity': severity,
      'iconEmoji': iconEmoji,
      'description': description,
      'descriptionAr': descriptionAr,
    };
  }
}
