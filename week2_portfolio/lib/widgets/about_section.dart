import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final String bio;

  const AboutSection({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About Me",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              bio,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
