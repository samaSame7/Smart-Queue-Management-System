class ServiceItem {
  final String id;
  final String name;
  final String description;
  final List<String> requirements;

  const ServiceItem({
    required this.id,
    required this.name,
    required this.description,
    required this.requirements,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? json['desc'] ?? '').toString(),
      requirements: (json['requirements'] as List? ?? [])
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList(),
    );
  }
}
