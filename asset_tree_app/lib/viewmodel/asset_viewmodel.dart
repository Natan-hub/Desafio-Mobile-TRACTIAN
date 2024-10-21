// Lógica para gerenciar os ativos
import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../services/api_service.dart';

class AssetViewModel extends ChangeNotifier {
  final ApiService apiService;

  AssetViewModel({required this.apiService});

  List<Asset> _assets = [];
  List<Asset> get assets => _assets;

  List<Asset> _filteredAssets = [];
  List<Asset> get filteredAssets =>
      _filteredAssets.isNotEmpty ? _filteredAssets : _assets;

  // Carrega os ativos da API e organiza a hierarquia
  Future<void> loadAssets(String companyId) async {
    try {
      List<Asset> allAssets = await apiService.fetchAssets(companyId);
      _assets = _buildAssetHierarchy(allAssets);
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar ativos: $e');
    }
  }

  // Função para construir a hierarquia de ativos
  List<Asset> _buildAssetHierarchy(List<Asset> assets) {
    Map<String, Asset> assetMap = {for (var asset in assets) asset.id: asset};

    for (var asset in assets) {
      if (asset.parentId != null && assetMap.containsKey(asset.parentId)) {
        assetMap[asset.parentId]?.children.add(asset);
      }
    }
    return assetMap.values.where((asset) => asset.parentId == null).toList();
  }

  // Aplica o filtro para mostrar apenas sensores de energia
  void filterBySensorType(String sensorType) {
    _filteredAssets =
        _assets.where((asset) => asset.sensorType == sensorType).toList();
    notifyListeners();
  }

  // Aplica o filtro para mostrar ativos com status crítico
  void filterByStatus(String status) {
    _filteredAssets = _assets.where((asset) => asset.status == status).toList();
    notifyListeners();
  }

  // Limpa os filtros
  void clearFilters() {
    _filteredAssets.clear();
    notifyListeners();
  }
}
