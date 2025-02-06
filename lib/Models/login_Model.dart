class LoginModel {
  String matricule;
  String motDePasse;

  LoginModel({required this.matricule, required this.motDePasse});

  bool isValid() {
    return matricule.isNotEmpty && motDePasse.isNotEmpty;
  }
}
