//Modelo de dados para uma localização

class Location {
  final String id;
  final String name;
  final String? parentId;

  Location({
    required this.id,
    required this.name,
    this.parentId,
  });

  // Método de fábrica para criar um Location a partir de um JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
    );
  }

  // Método para transformar um Location em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
    };
  }
}
