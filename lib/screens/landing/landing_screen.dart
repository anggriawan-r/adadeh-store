import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/landing/ultraboost.webp',
                  height: 500,
                  fit: BoxFit.cover,
                  alignment: const FractionalOffset(0.6, 1),
                ),
                Positioned(
                  bottom: 32,
                  left: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ULTRABOOST',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Text('EXPLORE MORE'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Image.asset(
                  'assets/landing/superbounce.webp',
                  height: 500,
                  fit: BoxFit.cover,
                  alignment: const FractionalOffset(0.6, 1),
                ),
                Positioned(
                  bottom: 32,
                  left: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SUPERBOUNCE',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Text('EXPLORE MORE'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
