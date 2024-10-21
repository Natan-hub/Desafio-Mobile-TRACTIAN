// company_view_model.dart
import 'package:flutter/material.dart';
import '../models/company.dart';
import '../services/api_service.dart';

class CompanyViewModel extends ChangeNotifier {
  final ApiService apiService;

  CompanyViewModel({required this.apiService});

  List<Company> _companies = [];
  List<Company> get companies => _companies;

  // Carrega todas as empresas da API
  Future<void> loadCompanies() async {
    try {
      _companies = await apiService.fetchCompanies();
      notifyListeners(); // Notifica a UI que os dados mudaram
    } catch (e) {
      print('Erro ao carregar empresas: $e');
    }
  }
}
