/// Author: Hillary Mutai
/// profile: https://github.com/hillarymutaik
import 'dart:async';

import 'package:flutter/material.dart';

import 'air_duka_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AirdukaScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'airduka',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Airduka',
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '.com',
                      style: TextStyle(
                          color: Colors.deepOrange.shade300,
                          fontFamily: 'Airduka',
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
