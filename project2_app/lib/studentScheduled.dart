import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class StudentScheduled extends StatefulWidget {
  @override
  _StudentScheduledState createState() => _StudentScheduledState();
}

class _StudentScheduledState extends State<StudentScheduled> {
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
              'id': key, // Add the unique identifier for each course
              ...value, // Spread the existing values
            });
          });

          coursesList.sort((a, b) {
            final dayComparison = a['day'].compareTo(b['day']);
            if (dayComparison != 0) {
              return dayComparison;
            }
            return a['time'].compareTo(b['time']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 131, 77),
        title: Text('Student Scheduled'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'All Courses:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${courses[index]['day']} - ${courses[index]['time']} - ${courses[index]['place']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Code: ${courses[index]['code']}'),
                        Text('Name: ${courses[index]['name']}'),
                        Text('Lecture: ${courses[index]['lecture']}'),
                      ],
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
