import 'package:elmawssir/Views/machines_pages.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  TextEditingController matriculeController = TextEditingController();
  TextEditingController motDePasseController = TextEditingController();
  bool _isPasswordVisible = false;
  Color _usernameLabelColor = Colors.grey;
  Color _passwordLabelColor = Colors.grey;

  bool get isPasswordVisible => _isPasswordVisible;
  Color get usernameLabelColor => _usernameLabelColor;
  Color get passwordLabelColor => _passwordLabelColor;

  set isPasswordVisible(bool value) {
    _isPasswordVisible = value;
    notifyListeners();
  }

  void validateAndLogin(BuildContext context) {
    String matricule = matriculeController.text.trim();
    String motDePasse = motDePasseController.text.trim();


    // Si tout est valide, navigue vers la page Machines
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MachinesPage()),
    );
  }

  void onUsernameFocusChange(bool hasFocus) {
    _usernameLabelColor = hasFocus ? Colors.yellow : Colors.grey;
    notifyListeners();
  }

  void onPasswordFocusChange(bool hasFocus) {
    _passwordLabelColor = hasFocus ? Colors.yellow : Colors.grey;
    notifyListeners();
  }
}
