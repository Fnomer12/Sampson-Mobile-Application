import 'package:flutter/material.dart';
import '../models/portfolio_data.dart';

class EducationSection extends StatelessWidget {
  final List<Education> education;

  const EducationSection({super.key, required this.education});

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
              "Academic History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: education.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final e = education[index];
                return ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(e.institution),
                  subtitle: Text("${e.degree}\n${e.year}"),
                  isThreeLine: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
