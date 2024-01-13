import 'package:flutter/material.dart';
import 'course.dart';
import 'dummyCourse.dart';
import 'studentViewCourse.dart'; // Import course data source

class StudentAddCourse extends StatefulWidget {
  @override
  _StudentAddCourseState createState() => _StudentAddCourseState();
}

class _StudentAddCourseState extends State<StudentAddCourse> {
  late List<Course> filteredCourses;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCourses = availableCourses; // Initialize with all available courses
  }

  void filterCourses(String query) {
    setState(() {
      filteredCourses = availableCourses
          .where((course) =>
              course.code.toLowerCase().contains(query.toLowerCase()) ||
              course.name.toLowerCase().contains(query.toLowerCase()) ||
              course.lecture.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 131, 77),
        title: Text('Available Courses'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterCourses(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter course code, name, or lecturer',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                Course course = filteredCourses[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CourseDetailScreen(course: course),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(course.name),
                    subtitle: Text(course.lecture),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
