import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'lectureHome.dart';
import 'lectureView.dart';

class LectureStudentInfo extends StatefulWidget {
  @override
  _LectureStudentInfoState createState() => _LectureStudentInfoState();
}

class _LectureStudentInfoState extends State<LectureStudentInfo> {
  List<Map<String, dynamic>> courses = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              ...value,
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
    final url = Uri.https(
      'course-24b09-default-rtdb.asia-southeast1.firebasedatabase.app',
      'applycourse/$courseId.json',
    );

    try {
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text(
                'Are you sure you want to remove this student from the course?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        final response = await http.delete(url);

        if (response.statusCode >= 400) {
          print('Failed to delete course. Status code: ${response.statusCode}');
        } else {
          setState(() {
            courses.removeWhere((course) => course['id'] == courseId);
          });

          showDialog(
            context: _scaffoldKey.currentContext!,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Course successfully removed!'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 242, 255, 199),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 131, 77),
        title: Text('Student information'),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 242, 255, 199),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 1, 131, 77),
              ),
              child: Text(
                'Option:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LectureHome()),
                  );
                }),
            ListTile(
              title: Text('Student information'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LectureStudentInfo()),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (Route<dynamic> route) => false);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'My Student:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LectureView(course: courses[index]),
                        ),
                      );
                    },
                    onDoubleTap: () {
                      _removeCourse(courses[index]['id']);
                    },
                    child: ListTile(
                      title: Text(
                        'Applicant Name: ${courses[index]['applicantName']} \n'
                        'Applicant Email: ${courses[index]['applicantEmail']} \n'
                        'Final Exam Info: ${courses[index]['finalExamInfo']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Code: ${courses[index]['code']} \n'
                        'Name: ${courses[index]['name']} \n'
                        'Lecture: ${courses[index]['lecture']}',
                      ),
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
