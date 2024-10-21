import 'package:asset_tree_app/models/tree_node.dart';
import 'package:flutter/material.dart';

class AssetTree extends StatelessWidget {
  final List<TreeNode> nodes;

  const AssetTree({super.key, required this.nodes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        final node = nodes[index];
        return _buildTreeNode(node);
      },
    );
  }

  Widget _buildTreeNode(TreeNode node) {
    return ExpansionTile(
      leading: _buildIcon(node),
      title: Text(node.name),
      children: node.children.isNotEmpty
          ? node.children.map((child) => _buildTreeNode(child)).toList()
          : [],
    );
  }

  Widget _buildIcon(TreeNode node) {
    switch (node.nodeType) {
      case NodeType.location:
        return const Icon(Icons.location_on, color: Colors.orange);
      case NodeType.asset:
        return const Icon(Icons.business, color: Colors.blue);
      case NodeType.component:
        if (node.sensorType == 'energy') {
          return const Icon(Icons.electric_bolt, color: Colors.green);
        } else if (node.sensorType == 'vibration') {
          return const Icon(Icons.vibration, color: Colors.red);
        } else {
          return const Icon(Icons.extension, color: Colors.grey);
        }
      default:
        return const Icon(Icons.device_unknown);
    }
  }
}
