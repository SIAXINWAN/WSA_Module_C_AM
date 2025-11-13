import 'package:flutter/material.dart';
import 'package:functionality_tablet/widgets/sidebar.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.isEng});
  final bool isEng;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool showButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("lib/assets/asean_map.png"),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.5),
          BlendMode.darken,
        ),
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("lib/assets/asean_logo.png"),
          const SizedBox(height: 20),
          Text(
            "ASEAN Summit 2025",
            style: TextStyle(
                fontSize: 40,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w900,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          const SizedBox(height: 10),
          Text(
            "One Vision, One Identify, One Community",
            style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontFamily: 'Roboto',
                decoration: TextDecoration.none),
          ),
          SizedBox(height: 60),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: showButton ? 1.0 : 0.0,
            curve: Curves.easeIn,
            child: IgnorePointer(
              ignoring: !showButton,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PersistentSidebar(isEng: widget.isEng),
                    ),
                  );
                },
                icon: Icon(
                  Icons.arrow_downward_rounded,
                  color: Colors.white,
                  size: 70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
