import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  var _name = '';
  var _email = '';
  var _phoneNumber = '';
  var _password = '';
  var _status = 'lecture';
  var _isSigningUp = false;

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSigningUp = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https(
          'shopping-68480-default-rtdb.asia-southeast1.firebasedatabase.app',
          'user.json');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _name,
            'email': _email,
            'phoneNumber': _phoneNumber,
            'password': _password,
            'status': _status,
          },
        ),
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        _showConfirmationDialog();
      } else {
        print('Error: ${response.body}');
      }
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: $_name'),
              Text('Email: $_email'),
              Text('Phone Number: $_phoneNumber'),
              Text('Password: $_password'),
              Text('Status: $_status'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessDialog();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Sign up successful!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Example: Ali bin Abu',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Example@gmail.com',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'email is required.';
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
                  labelText: 'Phone Number',
                  hintText: '0123456789 no dash (-)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'phone number is required.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'suggested strong password',
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
              DropdownButtonFormField(
                value: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value.toString();
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'lecture',
                    child: Text('Lecture'),
                  ),
                  DropdownMenuItem(
                    value: 'student',
                    child: Text('Student'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Status',
                  hintText: 'Select your status',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isSigningUp ? null : _signup,
                child: _isSigningUp
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    : Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 1, 131, 77),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
