import 'package:asset_tree_app/routes/routes.dart';
import 'package:asset_tree_app/view/asset_tree_page.dart';
import 'package:asset_tree_app/view/home_page.dart';
import 'package:flutter/material.dart';

class Pages {
  static Route generateRoute(RouteSettings settings) {
    final routeName = settings.name;

    switch (routeName) {
      case Routes.init:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case Routes.assetPage:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final String companyId = arguments['companyId'];
        return MaterialPageRoute(
          builder: (context) => AssetPage(
            companyId: companyId,
          ),
        );

      default:
        return MaterialPageRoute(builder: (context) => const Placeholder());
    }
  }
}
