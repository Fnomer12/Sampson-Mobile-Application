import 'package:flutter/material.dart';

class SkillsSection extends StatelessWidget {
  final List<String> skills;

  const SkillsSection({super.key, required this.skills});

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
              "Skills",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: skills
                  .map(
                    (s) => Chip(
                      label: Text(s),
                      avatar: const Icon(Icons.check_circle, size: 18),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
