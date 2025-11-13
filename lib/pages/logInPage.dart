import 'package:flutter/material.dart';
import 'package:functionality_tablet/modal/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.user, required this.token});
  final User user;
  final String token;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "My Account",
          style: TextStyle(
            color: const Color.fromARGB(255, 39, 103, 214),
            fontSize: 25,
            fontFamily: 'Roboto',
            decoration: TextDecoration.underline,
            decorationColor: const Color.fromARGB(255, 39, 103, 214),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        widget.user.displayName,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.user.email,
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
