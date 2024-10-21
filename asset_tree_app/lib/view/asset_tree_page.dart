//Página da arvore de ativos

import 'package:asset_tree_app/view/widgets/shared/logo.dart';
import 'package:asset_tree_app/utils/colors.dart';
import 'package:asset_tree_app/view/widgets/asset_tree.dart';
import 'package:asset_tree_app/viewmodel/asset_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssetPage extends StatelessWidget {
  final String companyId;

  const AssetPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    final assetViewModel = Provider.of<AssetViewModel>(context);

    if (assetViewModel.assets.isEmpty) {
      assetViewModel.loadAssets(companyId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Logo(0.25),
        centerTitle: true,
        backgroundColor: azulPadrao,
      ),
      body: Consumer<AssetViewModel>(
        builder: (context, assetViewModel, child) {
          if (assetViewModel.assets.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar Ativo ou Local',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    FilterChip(
                      avatar: const Icon(Icons.energy_savings_leaf_outlined),
                      label: const Text('Sensor de Energia'),
                      onSelected: (bool selected) {
                        if (selected) {
                          assetViewModel.filterBySensorType('energy');
                        } else {
                          assetViewModel.clearFilters();
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    FilterChip(
                      avatar: const Icon(Icons.error_outline_rounded),
                      label: const Text('Crítico'),
                      onSelected: (bool selected) {
                        if (selected) {
                          assetViewModel.filterByStatus('alert');
                        } else {
                          assetViewModel.clearFilters();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
                height: 20,
              ),
              Expanded(
                child: AssetTree(assets: assetViewModel.filteredAssets),
              ),
            ],
          );
        },
      ),
    );
  }
}
