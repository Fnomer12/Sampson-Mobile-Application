import 'package:flutter/material.dart';

import '../data/campus_data.dart';
import '../models/department.dart';

class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  void _openDepartmentDetail(BuildContext context, Department dept) {
    Navigator.pushNamed(
      context,
      '/department-detail',
      arguments: {
        'name': dept.name,
        'description': dept.description,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final departments = CampusData.departments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: departments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final dept = departments[index];

          IconData icon;
          if (dept.name == 'Computer Science') {
            icon = Icons.computer;
          } else if (dept.name == 'Engineering') {
            icon = Icons.engineering;
          } else {
            icon = Icons.business;
          }

          return Card(
            child: ListTile(
              leading: Icon(icon),
              title: Text(dept.name),
              subtitle: Text(dept.subtitle),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _openDepartmentDetail(context, dept),
            ),
          );
        },
      ),
    );
  }
}
