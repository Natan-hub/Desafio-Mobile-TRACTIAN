//Modelo de dados para uma localização

class Company {
  final String id;
  final String name;

  Company({
    required this.id,
    required this.name,
  });

  // Método de fábrica para criar um Company a partir de um JSON
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
    );
  }

  // Método para transformar um Company em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
