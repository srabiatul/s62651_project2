import '/course.dart';

List<Course> availableCourses = [
  Course(
    code: 'CSE123',
    name: 'Introduction to Computer Science',
    lecture: 'Dr. Rosmayati',
    courseClass:
        CourseClass(day: 'Monday', time: '9:00 AM - 10:30 AM', place: 'Webex'),
  ),
  Course(
    code: 'CSM201',
    name: 'Cyber Security',
    lecture: 'Sir Aalim',
    courseClass: CourseClass(
        day: 'Wednesday', time: '11:00 AM - 12:30 PM', place: 'Google meet'),
  ),
];
