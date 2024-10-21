//Implementação da Trie para busca

// lib/services/trie_service.dart
import 'package:asset_tree_app/models/asset.dart';

class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEndOfWord = false; // Indica se este nó é o final de uma palavra
  Asset? asset; // Armazena o ativo associado à palavra
}

class Trie {
  TrieNode root = TrieNode();

  // Insere um ativo na Trie usando o nome do ativo
  void insert(Asset asset) {
    TrieNode node = root;
    String name = asset.name.toLowerCase();

    for (var char in name.split('')) {
      if (!node.children.containsKey(char)) {
        node.children[char] = TrieNode();
      }
      node = node.children[char]!;
    }

    node.isEndOfWord = true;
    node.asset = asset; // Associa o ativo ao nó final
  }

  // Busca ativos por um prefixo
  List<Asset> search(String prefix) {
    TrieNode node = root;
    String lowerPrefix = prefix.toLowerCase();

    for (var char in lowerPrefix.split('')) {
      if (!node.children.containsKey(char)) {
        return []; // Prefixo não encontrado
      }
      node = node.children[char]!;
    }

    return _collectAssets(
        node); // Coleta todos os ativos que começam com esse prefixo
  }

  // Função auxiliar para coletar ativos a partir de um nó
  List<Asset> _collectAssets(TrieNode node) {
    List<Asset> results = [];

    if (node.isEndOfWord && node.asset != null) {
      results.add(node.asset!);
    }

    for (var child in node.children.values) {
      results.addAll(_collectAssets(child));
    }

    return results;
  }
}
