import 'package:flutter/material.dart';
import '../models/portfolio_data.dart';
import '../widgets/header_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/education_section.dart';
import '../widgets/projects_section.dart';

class PortfolioScreen extends StatelessWidget {
  final PortfolioData data;

  const PortfolioScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Professional Portfolio"),
        elevation: 4,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            final left = Column(
              children: [
                HeaderSection(name: data.name, title: data.title),
                const SizedBox(height: 16),
                AboutSection(bio: data.bio),
                const SizedBox(height: 16),
                SkillsSection(skills: data.skills),
              ],
            );

            final right = Column(
              children: [
                EducationSection(education: data.education),
                const SizedBox(height: 16),
                ProjectsSection(projects: data.projects),
              ],
            );

            if (!isTablet) {
              // Mobile: single column
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  left,
                  const SizedBox(height: 16),
                  right,
                ],
              );
            }

            // Tablet: two columns
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: ListView(children: [left])),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: ListView(children: [right])),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
