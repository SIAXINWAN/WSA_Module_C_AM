import 'package:flutter/material.dart';
import 'package:functionality_tablet/pages/signInPage.dart';
import 'package:functionality_tablet/widgets/sidebar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.isEng});
  final bool isEng;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: Icon(
                          Icons.person,
                          size: 60,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Join ASEAN Connect",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          "Sign in to save favourites and access personalized content"),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              )),
                          onPressed: () {
                            final sidebarState =
                                context.findAncestorStateOfType<
                                    PersistentSidebarState>();
                            sidebarState?.navigateToSubPage(SignInPage());
                          },
                          child: Text(
                            "[ Join Now ]",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
