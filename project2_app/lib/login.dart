import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'StudentHome.dart';
import 'LectureHome.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _isLoggingIn = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoggingIn = true;
      });
      _formKey.currentState!.save();

      final url = Uri.https(
        'shopping-68480-default-rtdb.asia-southeast1.firebasedatabase.app',
        'user.json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? users = json.decode(response.body);

        if (users != null) {
          bool isAuthenticated = users.values.any((user) =>
              user['email'] == _email && user['password'] == _password);

          if (isAuthenticated) {
            String userStatus = users.values.firstWhere(
              (user) =>
                  user['email'] == _email && user['password'] == _password,
              orElse: () => {'status': 'unknown'},
            )['status'];

            if (userStatus == 'student') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => StudentHome()),
              );
            } else if (userStatus == 'lecture') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LectureHome()),
              );
            } else {
              _showErrorDialog('Unknown user status');
            }
          } else {
            _showErrorDialog('Invalid email or password');
          }
        } else {
          _showErrorDialog('Failed to parse user data');
        }
      } else {
        print('Error: ${response.body}');
        _showErrorDialog('Failed to login. Please try again.');
      }

      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 131, 77),
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.diversity_1,
                size: 180.0, color: Color.fromARGB(255, 1, 131, 77)),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Example@gmail.com',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Your password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _isLoggingIn ? null : _login,
                    child: _isLoggingIn
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 1, 131, 77),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 1, 131, 77),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
