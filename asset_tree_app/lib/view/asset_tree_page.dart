//Página da arvore de ativos

import 'package:asset_tree_app/view/widgets/shared/logo.dart';
import 'package:asset_tree_app/utils/colors.dart';
import 'package:asset_tree_app/view/widgets/asset_tree.dart';
import 'package:asset_tree_app/viewmodel/asset_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssetPage extends StatefulWidget {
  final String companyId;

  const AssetPage({super.key, required this.companyId});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  bool isEnergySelected =
      false; // Controla o estado de seleção do chip "Sensor de Energia"
  bool isCriticalSelected =
      false; // Controla o estado de seleção do chip "Crítico"

  @override
  Widget build(BuildContext context) {
    final assetViewModel = Provider.of<AssetViewModel>(context);

    // Usar addPostFrameCallback para garantir que notifyListeners() seja chamado depois do build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      assetViewModel.loadNodes(widget.companyId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Logo(0.25),
        centerTitle: true,
        backgroundColor: azulPadrao,
      ),
      body: Consumer<AssetViewModel>(
        builder: (context, assetViewModel, child) {
          if (assetViewModel.nodes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      assetViewModel.search(value);
                    } else {
                      assetViewModel.clearFilters();
                    }
                  },
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        avatar: const Icon(Icons.clear_rounded),
                        label: const Text('Limpar'),
                        onSelected: (bool selected) {
                          assetViewModel.clearFilters();
                          setState(() {
                            isCriticalSelected = false;
                            isEnergySelected = false;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      FilterChip(
                        avatar: const Icon(Icons.energy_savings_leaf_outlined),
                        label: Text(
                          'Sensor de Energia',
                          style: TextStyle(
                            color:
                                isEnergySelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected:
                            isEnergySelected, // Define se o chip está selecionado
                        selectedColor: azulPadrao, // Cor quando selecionado
                        onSelected: (bool selected) {
                          setState(() {
                            isEnergySelected =
                                selected; // Altera o estado de seleção
                            if (selected) {
                              assetViewModel.filterBySensorType('energy');
                            } else {
                              assetViewModel.clearFilters();
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      FilterChip(
                        avatar: const Icon(Icons.error_outline_rounded),
                        label: Text(
                          'Crítico',
                          style: TextStyle(
                            color: isCriticalSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected:
                            isCriticalSelected, // Define se o chip está selecionado
                        selectedColor: azulPadrao, // Cor quando selecionado

                        onSelected: (bool selected) {
                          setState(() {
                            isCriticalSelected =
                                selected; // Altera o estado de seleção
                            if (selected) {
                              assetViewModel.filterBySensorType('alert');
                            } else {
                              assetViewModel.clearFilters();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                height: 20,
              ),
              Expanded(
                child: Consumer<AssetViewModel>(
                  builder: (context, assetViewModel, child) {
                    if (assetViewModel.nodes.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return AssetTree(nodes: assetViewModel.nodes);
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
