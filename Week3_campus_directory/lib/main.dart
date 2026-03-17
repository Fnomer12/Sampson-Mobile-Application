import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/departments_screen.dart';
import 'screens/department_detail.dart';
import 'screens/faculty_screen.dart';

void main() {
  runApp(const CampusDirectoryApp());
}

class CampusDirectoryApp extends StatelessWidget {
  const CampusDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VVU Campus Directory',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/departments': (context) => const DepartmentsScreen(),
        '/faculty': (context) => const FacultyScreen(),

        // Detail route with arguments
        '/department-detail': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

          return DepartmentDetailScreen(
            departmentName: args['name'] as String,
            departmentDescription: args['description'] as String,
          );
        },
      },
    );
  }
}
