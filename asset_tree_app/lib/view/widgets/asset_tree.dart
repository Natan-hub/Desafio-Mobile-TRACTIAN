//Widget que renderiza a arvore de ativos

// lib/view/widgets/asset_tree.dart
import 'package:asset_tree_app/models/asset.dart';
import 'package:flutter/material.dart';

// lib/view/widgets/asset_tree.dart

class AssetTree extends StatelessWidget {
  final List<Asset> assets;

  const AssetTree({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return _buildTreeNode(asset);
      },
    );
  }

  Widget _buildTreeNode(Asset asset) {
    return ExpansionTile(
      leading: _buildIcon(asset),
      title: Text(asset.name),
      children: asset.children.isNotEmpty
          ? asset.children.map((child) => _buildTreeNode(child)).toList()
          : [],
    );
  }

  // Função para definir o ícone correto com base no tipo do ativo e status
  Widget _buildIcon(Asset asset) {
    if (asset.sensorType == 'energy') {
      return const Icon(Icons.electric_bolt, color: Colors.green);
    } else if (asset.sensorType == 'vibration') {
      return const Icon(Icons.vibration, color: Colors.blue);
    } else if (asset.status == 'alert') {
      return const Icon(Icons.error_outline, color: Colors.red);
    } else {
      return const Icon(Icons.business, color: Colors.blue);
    }
  }
}
