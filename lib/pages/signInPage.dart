import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:functionality_tablet/modal/user.dart';
import 'package:functionality_tablet/pages/logInPage.dart';
import 'package:functionality_tablet/widgets/sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscure = true;
  bool loading = false;
  bool isEmailEmpty = false;
  bool isPasswordEmpty = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.addListener(() {
      setState(() {
        isEmailEmpty = emailController.text.isNotEmpty;
      });
    });
    passwordController.addListener(() {
      setState(() {
        isPasswordEmpty = passwordController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      final uri = Uri.parse('http://10.0.2.2:8081/api/users/signin');

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          Map<String, dynamic> userMap =
              Map<String, dynamic>.from(data["data"]["user"]);
          String token = data["data"]["auth_token"];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          if (!mounted) return;

          User user = User.fromJson(userMap, token);

          final sidebarState =
              context.findAncestorStateOfType<PersistentSidebarState>();
          sidebarState?.navigateToSubPage(LoginPage(user: user, token: token));
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["message"] ?? "Login failed.")),
          );
        }
      } else {
        String errorMessage;
        switch (response.statusCode) {
          case 401:
          case 403:
            errorMessage = "Unauthorized access. Check credentials.";
            break;
          case 404:
            errorMessage = "Server not found. Try again later.";
            break;
          case 500:
            errorMessage = "Internal server error. Try again later.";
            break;
          default:
            errorMessage = "Unexpected error: ${response.statusCode}";
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print("Error during login: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Network error. Check your connection."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(255, 205, 248, 156),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sign In',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      hintText: "Please insert your email",
                      suffix: isEmailEmpty
                          ? IconButton(
                              onPressed: () {
                                emailController.clear();
                              },
                              icon: Icon(Icons.clear))
                          : null,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter email';
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(v.trim()))
                        return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: "Please insert your password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                            obscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => obscure = !obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter password';
                      if (v.length < 6) return 'Min 6 characters';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    final sidebarState = context
                        .findAncestorStateOfType<PersistentSidebarState>();
                    sidebarState?.goBackToMainPage();
                  },
                  child: Text("Cancel"),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    login(context);
                  },
                  child: loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Sign In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
