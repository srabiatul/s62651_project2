import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LectureView extends StatefulWidget {
  final Map<String, dynamic> course;

  LectureView({required this.course});

  @override
  _LectureViewState createState() => _LectureViewState();
}

class _LectureViewState extends State<LectureView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController finalExamController = TextEditingController();

  Future<void> updateFinalExamInfo(String finalExamInfo) async {
    final url = Uri.https(
      'course-24b09-default-rtdb.asia-southeast1.firebasedatabase.app',
      'applycourse/${widget.course['id']}.json',
    );

    try {
      await http.patch(
        url,
        body: '{"finalExamInfo": "$finalExamInfo"}',
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Final exam information updated successfully.'),
            actions: <Widget>[
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
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error updating final exam information: $error'),
            actions: <Widget>[
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${widget.course['name']}'),
              Text('Code: ${widget.course['code']}'),
              Text('Lecture: ${widget.course['lecture']}'),
              Text('Day: ${widget.course['day']}'),
              Text('Time: ${widget.course['time']}'),
              Text('Place: ${widget.course['place']}'),
              if (widget.course.containsKey('applicantName'))
                Text('applicantName: ${widget.course['applicantName']}'),
              if (widget.course.containsKey('applicantEmail'))
                Text('applicantEmail: ${widget.course['applicantEmail']}'),
              if (widget.course.containsKey('applicantPhone'))
                Text('applicantPhone: ${widget.course['applicantPhone']}'),
              SizedBox(height: 16.0),
              ExpansionTile(
                collapsedBackgroundColor: Color.fromARGB(166, 1, 131, 77),
                backgroundColor: Color.fromARGB(54, 1, 131, 77),
                textColor: Color.fromARGB(255, 89, 154, 151),
                title: Text(
                  'Final Exam Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  'Enter the final exam information below:',
                  style: TextStyle(color: Colors.black),
                ),
                children: [
                  TextFormField(
                    controller: finalExamController,
                    decoration:
                        InputDecoration(labelText: 'Final Exam Information'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter final exam information';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String finalExamInfo = finalExamController.text;
                        updateFinalExamInfo(finalExamInfo);
                      }
                    },
                    child: Text('Submit Final Exam Information'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
