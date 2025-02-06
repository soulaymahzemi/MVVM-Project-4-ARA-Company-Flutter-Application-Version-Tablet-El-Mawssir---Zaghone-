import 'dart:convert';

import 'package:elmawssir/Models/Declaration_Model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeclarationViewModel extends ChangeNotifier{
  final String baseUrl;
  List<DeclarationModel> dataNc = [];
  String? selectedCause;
  TextEditingController quantityController = TextEditingController();
  DeclarationViewModel(this.baseUrl);
  
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/nc'));
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonData = json.decode(response.body);
      dataNc = jsonData.map((item) => DeclarationModel.fromJson(item)).toList();
      notifyListeners();
    }
  }
  Future<void> submitForm() async {
    if (selectedCause != null && quantityController.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse('$baseUrl/nc'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Type': selectedCause,
          'Quantite': int.parse(quantityController.text),
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        selectedCause = null;
        quantityController.clear();
        await fetchData();
      }
    }
  }

  Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/nc/$id'));
    if (response.statusCode == 200) {
      dataNc.removeWhere((item) => item.id == id);
      notifyListeners();
    }
  }
}

  