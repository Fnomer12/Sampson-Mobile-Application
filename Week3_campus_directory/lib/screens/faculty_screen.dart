import 'package:flutter/material.dart';

class FacultyScreen extends StatelessWidget {
  const FacultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faculty = List.generate(
      6,
      (index) => {
        'name': 'Lecturer ${index + 1}',
        'dept': index.isEven ? 'Computer Science' : 'Engineering',
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Directory'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: faculty.length,
        itemBuilder: (context, index) {
          final item = faculty[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(item['name']!),
              subtitle: Text('${item['dept']} Department'),
            ),
          );
        },
      ),
    );
  }
}
