// ignore_for_file: unnecessary_import, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'dart:async';

class AdsPage extends StatefulWidget {
  const AdsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdsPageState createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Map<String, dynamic>> adOffers;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.0,
    )..forward();

    adOffers = [
      {
        "title": "Epic Game Promo",
        "points": 50,
        "completed": false,
        "icon": Icons.gamepad_rounded,
        "color": Colors.deepPurple,
        "description": "Dive into an immersive gaming world!",
        "duration": "60 sec",
      },
      {
        "title": "Tech Innovator Showcase",
        "points": 75,
        "completed": false,
        "icon": Icons.devices_rounded,
        "color": Colors.teal,
        "description": "Discover cutting-edge technology!",
        "duration": "45 sec",
      },
      {
        "title": "Lifestyle Revolution",
        "points": 100,
        "completed": false,
        "icon": Icons.stars_rounded,
        "color": Colors.orange,
        "description": "Transform your everyday experience!",
        "duration": "90 sec",
      },
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _watchAd(int index) {
    if (adOffers[index]['completed']) return; // Prevent re-watching

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            int countdown = int.parse(
              adOffers[index]['duration'].split(' ')[0],
            );
            // ignore: unused_local_variable
            Timer? timer;

            void startTimer() {
              timer = Timer.periodic(Duration(seconds: 1), (timer) {
                if (countdown > 1) {
                  setModalState(() => countdown--);
                } else {
                  timer.cancel();
                  setState(() => adOffers[index]['completed'] = true);
                  Navigator.pop(context);
                }
              });
            }

            startTimer();

            return Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    adOffers[index]['color'].withOpacity(0.8),
                    adOffers[index]['color'].withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(adOffers[index]['icon'], size: 100, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'Watching ${adOffers[index]['title']}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Time Left: $countdown sec',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Ad Adventures',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GlassmorphicContainer(
              width: double.infinity,
              height: 150,
              borderRadius: 20,
              blur: 20,
              alignment: Alignment.bottomCenter,
              border: 2,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  // ignore: duplicate_ignore
                  // ignore: deprecated_member_use
                  Color(0xFFffffff).withOpacity(0.2),
                  Color(0xFFFFFFFF).withOpacity(0.1),
                ],
                stops: [0.1, 1],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Potential Points',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      '${adOffers.fold<int>(0, (sum, ad) => sum + (ad['points'] as int))}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: adOffers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _watchAd(index),
                    child: Opacity(
                      opacity: adOffers[index]['completed'] ? 0.5 : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: adOffers[index]['color'],
                        ),
                        child: Center(
                          child: Text(
                            adOffers[index]['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
