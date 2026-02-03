import 'package:flutter/material.dart';
import 'models/portfolio_data.dart';
import 'screens/portfolio_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioData = PortfolioData(
      name: "Your Full Name",
      title: "300 Level Computer Science Student",
      bio:
          "I am a Computer Science student with a passion for mobile app development and problem solving. "
          "I enjoy building Flutter apps, learning new technologies, and working on practical projects. "
          "My goal is to become a skilled software engineer and contribute to impactful products.",
      skills: [
        "Flutter",
        "Dart",
        "Firebase",
        "Git",
        "REST APIs",
        "UI Design",
      ],
      education: [
        Education(
          institution: "Valley View University",
          degree: "BSc. Computer Science",
          year: "2023 - Present",
        ),
      ],
      projects: [
        Project(
          name: "Portfolio App",
          description:
              "A responsive Flutter portfolio app with sections for profile, skills, education and projects.",
          technologies: "Flutter, Dart",
        ),
        Project(
          name: "Simple To-Do App",
          description:
              "A task manager app that allows users to add, delete and mark tasks as completed.",
          technologies: "Flutter, Dart",
        ),
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Professional Portfolio",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: PortfolioScreen(data: portfolioData),
    );
  }
}
