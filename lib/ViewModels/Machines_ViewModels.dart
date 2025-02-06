import 'package:elmawssir/Models/Machines_Model.dart';
import 'package:flutter/material.dart';

class MachinesViewModel extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  bool _isScrolledToBottom = false;

  // Mapping entre les IDs de lignes et leurs URLs
  final Map<int, String> lineUrls = {
    6: 'http://localhost:3001',
    7: 'http://localhost:3002',
    9: 'http://localhost:3003',
    10: 'http://localhost:3004',
    11: 'http://localhost:3005',
  };

  // Liste des machines
  List<Machine> _machines = [];

  MachinesViewModel() {
    _initializeMachines();
  }

  void _initializeMachines() {
    _machines = [
      Machine(id: 6, name: 'Ligne 6', imagePath: 'assets/images/mach.png', url: lineUrls[6]!),
      Machine(id: 7, name: 'Ligne 7', imagePath: 'assets/images/mach.png', url: lineUrls[7]!),
      Machine(id: 9, name: 'Ligne 9', imagePath: 'assets/images/mach.png', url: lineUrls[9]!),
      Machine(id: 10, name: 'Ligne 10', imagePath: 'assets/images/mach.png', url: lineUrls[10]!),
      Machine(id: 11, name: 'Ligne 11', imagePath: 'assets/images/mach.png', url: lineUrls[11]!),
    ];
    notifyListeners();
  }

  List<Machine> get machines => _machines;
  bool get isScrolledToBottom => _isScrolledToBottom;

  void toggleScrollDirection() {
    if (scrollController.hasClients) {
      if (_isScrolledToBottom) {
        scrollController.animateTo(
          0.0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      } else {
        final position = scrollController.position.maxScrollExtent;
        scrollController.animateTo(
          position,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }

      _isScrolledToBottom = !_isScrolledToBottom;
      notifyListeners();
    }
  }
}
