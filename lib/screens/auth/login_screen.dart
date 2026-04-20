import 'package:flutter/material.dart';
import 'package:spendwise_flutter/extensions/localization_extension.dart';
import 'package:spendwise_flutter/services/auth_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool isPasswordHidden = true;
  bool isLogin = true;
  bool isLoading = false;

  void _submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);

    if (emailError != null) {
      _showError(emailError);
      return;
    }

    if (passwordError != null) {
      _showError(passwordError);
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await authService.login(email, password);
      } else {
        await authService.register(email, password);
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    }
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  String? validateEmail(String email) {
    if (email.isEmpty) return "Email is required";

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return "Enter a valid email";
    }

    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return "Password is required";

    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F2937), Color(0xFF111827)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.account_balance_wallet, size: 60, color: Colors.white),
                  const SizedBox(height: 10),
                   Text(
                   context.l10n.appName,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText:context.l10n.email,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText: isPasswordHidden,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: context.l10n.password,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            suffixIcon: IconButton(
                              icon: Icon(isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  isPasswordHidden = !isPasswordHidden;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Color(0xFF6A11CB),
                              elevation: 5,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(color: Color(0xFF6A11CB), strokeWidth: 2),
                                  )
                                : Text(
                                    isLogin ? context.l10n.login : context.l10n.register,
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                              emailController.clear();
                              passwordController.clear();
                            });
                          },
                          child: Text(isLogin ? context.l10n.noAccount : context.l10n.haveAccount),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
