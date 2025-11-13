import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EconomyPage extends StatefulWidget {
  const EconomyPage({super.key});

  @override
  State<EconomyPage> createState() => _EconomyPageState();
}

class _EconomyPageState extends State<EconomyPage> {
  List<Map<String, dynamic>> aboutList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.131.72.150:8081/api/economy'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          setState(() {
            aboutList = List<Map<String, dynamic>>.from(jsonData['data']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "API returned success=false";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Exception: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Economic Dashboard",
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
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "ASEAN Economic Highlights (2025)",
              style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 104, 102, 102)),
            ),
          ),
        ],
      ),
    );
  }
}
