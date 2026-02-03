// StudentManagementApp

import 'package:flutter/material.dart';

void main() {
  runApp(const StudentManagementApp());
}

// ===================== APP ROOT =====================
class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade700),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
      ),
      home: const DashboardScreen(),
    );
  }
}

// ===================== MODEL =====================
class Student {
  final String id;
  String name;
  String course;

  Student({
    required this.id,
    required this.name,
    required this.course,
  });
}

// ===================== DASHBOARD SCREEN =====================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Student> students = [
    Student(id: '1', name: 'Juan Dela Cruz', course: 'BS Information Systems'),
    Student(id: '2', name: 'Maria Santos', course: 'BS Computer Science'),
    Student(id: '3', name: 'Alex Reyes', course: 'BSIT'),
  ];

  int selectedIndex = 0; // Sidebar selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: selectedIndex == 0
                  ? DashboardContent(
                      students: students,
                      onAdd: addStudent,
                      onEdit: editStudent,
                      onDelete: deleteStudent,
                    )
                  : selectedIndex == 1
                      ? StudentsPage(
                          students: students,
                          onAdd: addStudent,
                          onEdit: editStudent,
                          onDelete: deleteStudent,
                        )
                      : const Center(
                          child: Text('Settings Page'),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  void addStudent() async {
    final newStudent = await showStudentDialog(context);
    if (newStudent != null) {
      setState(() {
        students.add(newStudent);
      });
    }
  }

  void editStudent(Student student) async {
    final updatedStudent = await showStudentDialog(context, student: student);
    if (updatedStudent != null) {
      setState(() {
        student.name = updatedStudent.name;
        student.course = updatedStudent.course;
      });
    }
  }

  void deleteStudent(Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                students.remove(student);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ===================== DIALOG FOR ADD/EDIT =====================
  Future<Student?> showStudentDialog(BuildContext context, {Student? student}) {
    final nameController = TextEditingController(text: student?.name ?? '');
    final courseController = TextEditingController(text: student?.course ?? '');

    return showDialog<Student>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(student == null ? 'Add Student' : 'Edit Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(labelText: 'Course'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = student?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
              final newStudent = Student(
                id: id,
                name: nameController.text.trim(),
                course: courseController.text.trim(),
              );
              Navigator.pop(ctx, newStudent);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ===================== DASHBOARD CONTENT =====================
class DashboardContent extends StatelessWidget {
  final List<Student> students;
  final VoidCallback onAdd;
  final Function(Student) onEdit;
  final Function(Student) onDelete;

  const DashboardContent({
    super.key,
    required this.students,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(),
        const SizedBox(height: 24),
        statsRow(students.length),
        const SizedBox(height: 24),
        Expanded(child: studentSection()),
      ],
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Maligayang Araw!', style: TextStyle(fontSize: 14)),
            SizedBox(height: 4),
            Text('Student Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.person, color: Colors.blue),
        ),
      ],
    );
  }

  Widget statsRow(int totalStudents) {
    return Row(
      children: [
        statCard('Total Students', totalStudents.toString(), Colors.blue),
        statCard('Courses', '3', Colors.indigo),
        statCard('Records', totalStudents.toString(), Colors.lightBlue),
      ],
    );
  }

  Widget statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Text(value,
                style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget studentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Student Records',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: students.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(Icons.school, color: Colors.blue),
                ),
                title: Text(student.name),
                subtitle: Text(student.course),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => onEdit(student),
                      icon: const Icon(Icons.edit, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () => onDelete(student),
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ===================== STUDENTS PAGE =====================
class StudentsPage extends StatelessWidget {
  final List<Student> students;
  final VoidCallback onAdd;
  final Function(Student) onEdit;
  final Function(Student) onDelete;

  const StudentsPage({
    super.key,
    required this.students,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('All Students',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: students.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(Icons.school, color: Colors.blue),
                ),
                title: Text(student.name),
                subtitle: Text(student.course),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => onEdit(student),
                      icon: const Icon(Icons.edit, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () => onDelete(student),
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ===================== SIDEBAR =====================
class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          IconButton(
            onPressed: () => onItemSelected(0),
            icon: Icon(Icons.dashboard,
                color: selectedIndex == 0 ? Colors.white : Colors.white70),
          ),
          const SizedBox(height: 24),
          IconButton(
            onPressed: () => onItemSelected(1),
            icon: Icon(Icons.people,
                color: selectedIndex == 1 ? Colors.white : Colors.white70),
          ),
          const SizedBox(height: 24),
          IconButton(
            onPressed: () => onItemSelected(2),
            icon: Icon(Icons.settings,
                color: selectedIndex == 2 ? Colors.white : Colors.white70),
          ),
        ],
      ),
    );
  }
}
