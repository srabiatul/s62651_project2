import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentEnrollment extends StatefulWidget {
  @override
  _StudentEnrollmentState createState() => _StudentEnrollmentState();
}

class _StudentEnrollmentState extends State<StudentEnrollment> {
  List<Map<String, dynamic>> courses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    final url = Uri.https(
      'course-24b09-default-rtdb.asia-southeast1.firebasedatabase.app',
      'applycourse.json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);
        if (data != null) {
          List<Map<String, dynamic>> coursesList = [];
          data.forEach((key, value) {
            coursesList.add({
              'id': key,
              'code': value['code'],
              'name': value['name'],
              'lecture': value['lecture'],
              'day': value['day'],
              'time': value['time'],
              'place': value['place'],
            });
          });

          setState(() {
            courses = coursesList;
          });
        }
      } else {
        print('Failed to fetch courses. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _removeCourse(String courseId) async {
    final confirmed = await _showConfirmationDialog();

    if (confirmed != null && confirmed) {
      final url = Uri.https(
        'course-24b09-default-rtdb.asia-southeast1.firebasedatabase.app',
        'applycourse/$courseId.json',
      );

      try {
        final response = await http.delete(url);

        if (response.statusCode >= 400) {
          print('Failed to delete course. Status code: ${response.statusCode}');
        } else {
          setState(() {
            courses.removeWhere((course) => course['id'] == courseId);
          });

          await _showSuccessDialog();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Course dropped successfully'),
            duration: Duration(seconds: 2),
          ));
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  Future<bool?> _showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to drop this course?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Course dropped successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    courses.sort((a, b) => a['code'].compareTo(b['code']));

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 255, 199),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 131, 77),
        title: Text('Student Enrollment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Courses:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Color.fromARGB(255, 1, 131, 77),
                    onDoubleTap: () {
                      _removeCourse(courses[index]['id']);
                    },
                    child: ListTile(
                      title: Text(
                        '${courses[index]['code']} - ${courses[index]['name']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Lecture: ${courses[index]['lecture']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
