import 'package:asset_tree_app/models/location.dart';
import 'package:asset_tree_app/models/tree_node.dart';
import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../services/api_service.dart';

class AssetViewModel extends ChangeNotifier {
  final ApiService apiService;

  AssetViewModel({required this.apiService});

  List<TreeNode> _nodes = [];
  List<TreeNode> get nodes =>
      _filteredNodes.isNotEmpty ? _filteredNodes : _nodes;

  List<TreeNode> _filteredNodes = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _loadedCompanyId;

  // Carrega ativos e localizações e constrói a árvore
  Future<void> loadNodes(String companyId) async {
    if (_loadedCompanyId == companyId) return;

    _setLoading(true);
    _clearNodes();

    try {
      final data = await apiService.fetchAssetsAndLocations(companyId);
      List<Asset> assets = data['assets'];
      List<Location> locations = data['locations'];

      _nodes = _buildHierarchy(assets, locations);
      _loadedCompanyId = companyId;
    } catch (e) {
      print('Erro ao carregar ativos e localizações: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Função para limpar os dados
  void _clearNodes() {
    _nodes.clear();
    _filteredNodes.clear();
    _loadedCompanyId = null;
  }

  // Função para controlar o estado de carregamento
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Constrói a hierarquia combinada de ativos e localizações
  List<TreeNode> _buildHierarchy(List<Asset> assets, List<Location> locations) {
    Map<String, TreeNode> nodeMap = {};

    // Adiciona todas as localizações ao mapa
    for (var location in locations) {
      nodeMap[location.id] = TreeNode.fromLocation(location);
    }

    // Adiciona todos os ativos ao mapa
    for (var asset in assets) {
      nodeMap[asset.id] = TreeNode.fromAsset(asset);
    }

    // Constrói a hierarquia de nós com base nos pais
    for (var node in nodeMap.values) {
      if (node.parentId != null && nodeMap.containsKey(node.parentId)) {
        nodeMap[node.parentId]!.children.add(node);
      }
    }

    // Retorna os nós de nível superior (sem parentId)
    return nodeMap.values.where((node) => node.parentId == null).toList();
  }

  // Filtra nós com base no tipo de sensor
  void filterBySensorType(String sensorType) {
    _filteredNodes = _filterNodesBySensorType(_nodes, sensorType);
    notifyListeners(); // Notifica a UI após aplicar o filtro
  }

  // Função auxiliar para aplicar o filtro de sensor recursivamente
  List<TreeNode> _filterNodesBySensorType(
      List<TreeNode> nodes, String sensorType) {
    List<TreeNode> filtered = [];

    for (var node in nodes) {
      if (node.nodeType == NodeType.component &&
          node.sensorType == sensorType) {
        filtered.add(node); // Adiciona se o tipo de sensor corresponder
      } else if (node.children.isNotEmpty) {
        // Filtra os filhos recursivamente
        var filteredChildren =
            _filterNodesBySensorType(node.children, sensorType);
        if (filteredChildren.isNotEmpty) {
          // Inclui o nó atual se tiver filhos correspondentes
          filtered.add(TreeNode(
            id: node.id,
            name: node.name,
            parentId: node.parentId,
            nodeType: node.nodeType,
            sensorType: node.sensorType,
            status: node.status,
            children: filteredChildren,
          ));
        }
      }
    }
    return filtered;
  }

  // Pesquisa nós com base no nome
  void search(String query) {
    _filteredNodes = _searchNodes(_nodes, query.toLowerCase());
    notifyListeners(); // Notifica a UI após aplicar a busca
  }

  // Função auxiliar para realizar busca nos nós recursivamente
  List<TreeNode> _searchNodes(List<TreeNode> nodes, String query) {
    List<TreeNode> filtered = [];

    for (var node in nodes) {
      if (node.name.toLowerCase().contains(query)) {
        filtered.add(node); // Adiciona o nó se o nome corresponder à consulta
      } else if (node.children.isNotEmpty) {
        // Busca nos filhos recursivamente
        var filteredChildren = _searchNodes(node.children, query);
        if (filteredChildren.isNotEmpty) {
          filtered.add(TreeNode(
            id: node.id,
            name: node.name,
            parentId: node.parentId,
            nodeType: node.nodeType,
            sensorType: node.sensorType,
            status: node.status,
            children: filteredChildren,
          ));
        }
      }
    }
    return filtered;
  }

  // Limpa os filtros aplicados
  void clearFilters() {
    _filteredNodes.clear(); // Limpa a lista de nós filtrados
    notifyListeners(); // Notifica a UI para re-renderizar
  }
}
