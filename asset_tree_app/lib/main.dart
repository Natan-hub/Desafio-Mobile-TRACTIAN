import 'package:asset_tree_app/routes/pages.dart';
import 'package:asset_tree_app/services/api_service.dart';
import 'package:asset_tree_app/services/trie_service.dart';
import 'package:asset_tree_app/view/home_page.dart';
import 'package:asset_tree_app/viewmodel/asset_viewmodel.dart';
import 'package:asset_tree_app/viewmodel/company_viewmodel.dart';
import 'package:asset_tree_app/viewmodel/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider para AssetViewModel
        ChangeNotifierProvider(
          create: (context) => AssetViewModel(apiService: ApiService()),
        ),
        // Provider para SearchViewModel
        ChangeNotifierProvider(
          create: (context) => SearchViewModel(trie: Trie()),
        ),
        ChangeNotifierProvider(
          create: (context) => CompanyViewModel(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Asset Tree App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        onGenerateRoute: Pages.generateRoute,
        home: const HomePage(),
      ),
    );
  }
}
