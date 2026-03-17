class PortfolioData {
  final String name;
  final String title;
  final String bio;
  final List<String> skills;
  final List<Education> education;
  final List<Project> projects;

  PortfolioData({
    required this.name,
    required this.title,
    required this.bio,
    required this.skills,
    required this.education,
    required this.projects,
  });
}

class Education {
  final String institution;
  final String degree;
  final String year;

  Education({
    required this.institution,
    required this.degree,
    required this.year,
  });
}

class Project {
  final String name;
  final String description;
  final String technologies;

  Project({
    required this.name,
    required this.description,
    required this.technologies,
  });
}
