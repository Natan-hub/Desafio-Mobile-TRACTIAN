import 'package:asset_tree_app/models/asset.dart';
import 'package:asset_tree_app/models/location.dart';

class TreeNode {
  final String id;
  final String name;
  final String? parentId;
  final NodeType nodeType;
  final String? sensorType;
  final String? status;
  final List<TreeNode> children;

  TreeNode({
    required this.id,
    required this.name,
    this.parentId,
    required this.nodeType,
    this.sensorType,
    this.status,
    List<TreeNode>? children,
  }) : children = children ?? [];

  factory TreeNode.fromAsset(Asset asset) {
    return TreeNode(
      id: asset.id,
      name: asset.name,
      parentId: asset.parentId ?? asset.locationId,
      nodeType: asset.sensorType != null ? NodeType.component : NodeType.asset,
      sensorType: asset.sensorType,
      status: asset.status,
    );
  }

  factory TreeNode.fromLocation(Location location) {
    return TreeNode(
      id: location.id,
      name: location.name,
      parentId: location.parentId,
      nodeType: NodeType.location,
    );
  }
}

enum NodeType { location, asset, component }
