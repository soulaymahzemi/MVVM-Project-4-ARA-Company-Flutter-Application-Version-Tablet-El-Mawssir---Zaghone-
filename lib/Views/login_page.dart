import 'package:elmawssir/ViewModels/login_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            
            body: Center(
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                                'Bienvenu dans l\'ère digitale 4.0 avec ARAMES'),
                            const SizedBox(height: 20),
                            TextField(
                              controller: viewModel.matriculeController,
                              focusNode: FocusNode()
                                ..addListener(() {
                                  viewModel.onUsernameFocusChange(true);
                                }),
                              decoration: InputDecoration(
                                labelText: 'Identifiant *',
                                labelStyle: TextStyle(
                                    color: viewModel.usernameLabelColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.yellow, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: viewModel.motDePasseController,
                              focusNode: FocusNode()
                                ..addListener(() {
                                  viewModel.onPasswordFocusChange(true);
                                }),
                              decoration: InputDecoration(
                                labelText: 'Mot de passe *',
                                labelStyle: TextStyle(
                                    color: viewModel.passwordLabelColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.yellow, width: 2),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    viewModel.isPasswordVisible =
                                        !viewModel.isPasswordVisible;
                                  },
                                  icon: Icon(
                                    viewModel.isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              obscureText: !viewModel.isPasswordVisible,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Color(0xFFFEBD00),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0, vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () {
                                  viewModel.validateAndLogin(context);
                                },
                                child: const Text('Login'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
