import 'package:asset_tree_app/routes/routes.dart';
import 'package:asset_tree_app/view/widgets/shared/logo.dart';
import 'package:asset_tree_app/utils/colors.dart';
import 'package:asset_tree_app/viewmodel/company_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa o CompanyViewModel e carrega as empresas
    final companyViewModel = Provider.of<CompanyViewModel>(context);

    // Carrega as empresas se ainda não foram carregadas
    if (companyViewModel.companies.isEmpty) {
      companyViewModel.loadCompanies();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Logo(0.25),
        centerTitle: true,
        backgroundColor: azulPadrao,
      ),
      body: Consumer<CompanyViewModel>(
        builder: (context, companyViewModel, child) {
          if (companyViewModel.companies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: companyViewModel.companies.length,
            itemBuilder: (context, index) {
              final company = companyViewModel.companies[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.business, color: Colors.white),
                    title: Text(
                      company.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    tileColor: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.assetPage,
                        arguments: {
                          'companyId': company.id,
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
