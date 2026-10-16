class HealthTip {
  final String id;
  final String title;
  final String titleAr;
  final String content;
  final String contentAr;
  final String category;
  final String categoryAr;
  final String iconEmoji;
  final DateTime date;

  HealthTip({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.content,
    required this.contentAr,
    required this.category,
    required this.categoryAr,
    required this.iconEmoji,
    required this.date,
  });

  factory HealthTip.fromJson(Map<String, dynamic> json) {
    return HealthTip(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      titleAr: json['titleAr'] ?? '',
      content: json['content'] ?? '',
      contentAr: json['contentAr'] ?? '',
      category: json['category'] ?? '',
      categoryAr: json['categoryAr'] ?? '',
      iconEmoji: json['iconEmoji'] ?? '💡',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleAr': titleAr,
      'content': content,
      'contentAr': contentAr,
      'category': category,
      'categoryAr': categoryAr,
      'iconEmoji': iconEmoji,
      'date': date.toIso8601String(),
    };
  }
}
