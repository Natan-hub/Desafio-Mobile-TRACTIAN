//Lida com as chamadas de API

import 'dart:convert';
import 'package:asset_tree_app/models/company.dart';
import 'package:asset_tree_app/models/location.dart';
import 'package:asset_tree_app/utils/colors.dart';
import 'package:http/http.dart' as http;
import '../models/asset.dart';

class ApiService {
  // Busca todas as empresas
  Future<List<Company>> fetchCompanies() async {
    final response = await http.get(Uri.parse('${BaseUrl.url}/companies'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Company.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }

  // Busca todos os ativos de uma empresa
  Future<List<Asset>> fetchAssets(String companyId) async {
    final response =
        await http.get(Uri.parse('${BaseUrl.url}/companies/$companyId/assets'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Asset.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load assets');
    }
  }

  // Busca todas as localizações de uma empresa
  Future<List<Location>> fetchLocations(String companyId) async {
    final response = await http
        .get(Uri.parse('${BaseUrl.url}/companies/$companyId/locations'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }
}
