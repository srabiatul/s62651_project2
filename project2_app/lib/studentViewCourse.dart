import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'course.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  CourseDetailScreen({required this.course});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void _applyForCourse(BuildContext context) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final url = Uri.https(
      'course-24b09-default-rtdb.asia-southeast1.firebasedatabase.app',
      'applycourse.json',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'code': widget.course.code,
          'name': widget.course.name,
          'lecture': widget.course.lecture,
          'day': widget.course.courseClass.day,
          'time': widget.course.courseClass.time,
          'place': widget.course.courseClass.place,
          'applicantName': nameController.text,
          'applicantEmail': emailController.text,
          'applicantPhone': phoneController.text,
        }),
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Successful'),
              content: Text('Course applied successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to apply for the course.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
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
        title: Text('Course Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Course Code: ${widget.course.code}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Name: ${widget.course.name}'),
            Text('Lecture: ${widget.course.lecture}'),
            SizedBox(height: 20),
            Text(
              'Class Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Day: ${widget.course.courseClass.day}'),
            Text('Time: ${widget.course.courseClass.time}'),
            Text('Place: ${widget.course.courseClass.place}'),
            SizedBox(height: 20),
            ExpansionTile(
              collapsedBackgroundColor: Color.fromARGB(166, 1, 131, 77),
              backgroundColor: Color.fromARGB(54, 1, 131, 77),
              textColor: Color.fromARGB(255, 89, 154, 151),
              title: Text(
                'Student Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                'Please make sure all information are correct before apply',
                style: TextStyle(color: Colors.black),
              ),
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _applyForCourse(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 1, 131, 77),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
