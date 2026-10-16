class Disease {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final List<String> symptoms;
  final List<String> symptomsAr;
  final List<String> treatments;
  final List<String> treatmentsAr;
  final String severity; // low, medium, high
  final String category;
  final String iconEmoji;

  Disease({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.symptoms,
    required this.symptomsAr,
    required this.treatments,
    required this.treatmentsAr,
    required this.severity,
    required this.category,
    required this.iconEmoji,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      symptomsAr: List<String>.from(json['symptomsAr'] ?? []),
      treatments: List<String>.from(json['treatments'] ?? []),
      treatmentsAr: List<String>.from(json['treatmentsAr'] ?? []),
      severity: json['severity'] ?? 'medium',
      category: json['category'] ?? '',
      iconEmoji: json['iconEmoji'] ?? '🏥',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'symptoms': symptoms,
      'symptomsAr': symptomsAr,
      'treatments': treatments,
      'treatmentsAr': treatmentsAr,
      'severity': severity,
      'category': category,
      'iconEmoji': iconEmoji,
    };
  }
}
