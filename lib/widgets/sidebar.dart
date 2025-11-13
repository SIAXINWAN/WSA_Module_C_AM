import 'dart:math';

import 'package:flutter/material.dart';
import 'package:functionality_tablet/pages/aboutAseanPage.dart';
import 'package:functionality_tablet/pages/accountPage.dart';
import 'package:functionality_tablet/pages/economyPage.dart';
import 'package:functionality_tablet/pages/galleryPage.dart';
import 'package:functionality_tablet/pages/videosPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentSidebar extends StatefulWidget {
  const PersistentSidebar({super.key, required this.isEng});
  final bool isEng;

  @override
  State<PersistentSidebar> createState() => PersistentSidebarState();
}

class PersistentSidebarState extends State<PersistentSidebar> {
  int _selectedIndex = 0;
  late bool isEng;
  Widget? currentSubPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEng = widget.isEng;
    loadIsEng();
  }

  void loadIsEng() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getBool('eng');
    if (stored != null) {
      setState(() {
        isEng = stored;
      });
    }
  }

  final List<String> _titlesEn = [
    'About ASEAN',
    'Economy',
    'Gallery',
    'Videos',
    'Account',
  ];

  final List<String> _titlesBM = [
    'Tentang ASEAN',
    'Ekonomi',
    'Galeri',
    'Video',
    'Akaun Saya',
  ];

  List<Widget> get _pages => [
        AboutAseanPage(),
        EconomyPage(),
        GalleryPage(),
        VideoPage(),
        AccountPage(isEng: isEng),
      ];

  void navigateToSubPage(Widget page) {
    setState(() {
      currentSubPage = page;
    });
  }

  void goBackToMainPage() {
    setState(() {
      currentSubPage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 180,
            color: Colors.blue.shade50,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  "lib/assets/asean_logo.png",
                  height: 120,
                ),
                const SizedBox(height: 20),
                Text(
                  isEng ? "ASEAN Summit 2025" : "Sidang Kemuncak ASEAN 2025",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                for (int i = 0; i < _titlesEn.length; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = i;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        color: _selectedIndex == i
                            ? Colors.blue.shade100
                            : Colors.transparent,
                        child: Text(
                          isEng ? _titlesEn[i] : _titlesBM[i],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _selectedIndex == i
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _selectedIndex == i
                                ? Colors.blue.shade900
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 90,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          )),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final newValue = !isEng;
                        await prefs.setBool('eng', newValue);
                        setState(() {
                          isEng = newValue;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isEng ? Text("Language") : Text("Bahasa"),
                          isEng ? Text("EN") : Text("BM")
                        ],
                      )),
                )
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Stack(
              children: [
                _pages[_selectedIndex], 
                if (currentSubPage != null)
                  currentSubPage!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
