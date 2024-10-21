//Lógica de busca

import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../services/trie_service.dart';

class SearchViewModel extends ChangeNotifier {
  final Trie trie;

  SearchViewModel({required this.trie});

  List<Asset> _searchResults = [];
  List<Asset> get searchResults => _searchResults;

  // Atualiza os resultados da busca
  void search(String query) {
    _searchResults = trie.search(query);
    notifyListeners(); // Notifica a UI para atualizar
  }

  // Insere ativos na Trie para habilitar a busca
  void insertAssets(List<Asset> assets) {
    for (var asset in assets) {
      trie.insert(asset);
    }
  }
}
