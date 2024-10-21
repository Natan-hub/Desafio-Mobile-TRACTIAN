//Aqui representa o modelo de dados de um ativo

class Asset {
  final String id;
  final String name;
  final String? parentId;
  final String? locationId;
  final String? sensorType; // Adicionado para armazenar o tipo de sensor
  final String? status; // Adicionado para armazenar o status
  final List<Asset> children;

  Asset({
    required this.id,
    required this.name,
    this.parentId,
    this.locationId,
    this.sensorType,
    this.status,
    List<Asset>? children,
  }) : children = children ?? [];

  // Método de fábrica para criar um Asset a partir de um JSON
  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      locationId: json['locationId'],
      sensorType: json['sensorType'],
      status: json['status'],
    );
  }

  // Método para transformar um Asset em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
      'locationId': locationId,
      'sensorType': sensorType,
      'status': status,
    };
  }
}
