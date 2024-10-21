import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/asset.dart';
import '../models/location.dart';
import '../models/tree_node.dart';

class AssetViewModel extends ChangeNotifier {
  final ApiService apiService;
  AssetViewModel({required this.apiService});

  List<TreeNode> _nodes = [];
  List<TreeNode> _filteredNodes = [];
  String? _loadedCompanyId;

  List<TreeNode> get nodes =>
      _filteredNodes.isNotEmpty ? _filteredNodes : _nodes;

  Future<void> loadNodes(String companyId) async {
    if (_loadedCompanyId == companyId) return;

    _nodes.clear();
    _filteredNodes.clear();

    try {
      final data = await apiService.fetchAssetsAndLocations(companyId);
      List<Asset> assets = data['assets'];
      List<Location> locations = data['locations'];

      _nodes = _buildHierarchy(assets, locations);
      _loadedCompanyId = companyId;
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar ativos: $e');
    }
  }

  List<TreeNode> _buildHierarchy(List<Asset> assets, List<Location> locations) {
    Map<String, TreeNode> nodeMap = {};
    for (var location in locations) {
      nodeMap[location.id] = TreeNode.fromLocation(location);
    }
    for (var asset in assets) {
      nodeMap[asset.id] = TreeNode.fromAsset(asset);
    }

    for (var node in nodeMap.values) {
      if (node.parentId != null && nodeMap.containsKey(node.parentId)) {
        nodeMap[node.parentId]!.children.add(node);
      }
    }

    return nodeMap.values.where((node) => node.parentId == null).toList();
  }

  void filterBySensorType(String sensorType) {
    _filteredNodes = _nodes
        .where((node) =>
            node.nodeType == NodeType.component &&
            node.sensorType == sensorType)
        .toList();
    notifyListeners();
  }

  void search(String query) {
    _filteredNodes = _nodes
        .where((node) => node.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void clearFilters() {
    _filteredNodes.clear();
    notifyListeners();
  }
}
