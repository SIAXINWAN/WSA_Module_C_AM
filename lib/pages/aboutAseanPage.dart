import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AboutAseanPage extends StatefulWidget {
  const AboutAseanPage({super.key});

  @override
  State<AboutAseanPage> createState() => _AboutAseanPageState();
}

class _AboutAseanPageState extends State<AboutAseanPage> {
  List<Map<String, dynamic>> aboutList = [];
  bool isLoading = true;
  String? errorMessage;
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8081/api/about'));

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
          "About ASEAN",
          style: TextStyle(
            color: const Color.fromARGB(255, 39, 103, 214),
            fontSize: 25,
            fontFamily: 'Roboto',
            decoration: TextDecoration.underline,
            decorationColor: const Color.fromARGB(255, 39, 103, 214),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: aboutList.length,
                  itemBuilder: (context, index) {
                    final item = aboutList[index];
                    final isExpanded = expandedIndex == index;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            expandedIndex = isExpanded ? null : index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 39, 103, 214),
                              width: 2.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Header
                              Container(
                                height: 100,
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: TextStyle(fontSize: 28),
                                    ),
                                    Icon(isExpanded ? Icons.remove : Icons.add)
                                  ],
                                ),
                              ),
                              // Expandable content
                              if (isExpanded)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    border: Border(
                                      top: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 39, 103, 214),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        item['image_url'] ?? '',
                                        height: 200,
                                        width: 300,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['title'],
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['body'] ?? '',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
