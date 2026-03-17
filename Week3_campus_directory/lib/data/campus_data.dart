import '../models/department.dart';

class CampusData {
  static const List<Department> departments = [
    Department(
      name: 'Computer Science',
      subtitle: 'Department of Computing Sciences',
      description:
          'The Computer Science department at Valley View University focuses on software engineering, mobile development, data science, and artificial intelligence. Students gain hands-on experience with modern tools and real-world projects.',
    ),
    Department(
      name: 'Engineering',
      subtitle: 'School of Engineering',
      description:
          'The Engineering department provides practical and theory-based training across major engineering fields. Students work on design, problem-solving, and innovation to build industry-ready skills.',
    ),
    Department(
      name: 'Business Administration',
      subtitle: 'School of Business',
      description:
          'The Business Administration department equips students with skills in management, entrepreneurship, accounting, finance, and marketing. Students learn leadership and decision-making for real business situations.',
    ),
  ];
}
