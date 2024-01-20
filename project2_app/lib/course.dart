class Course {
  final String code;
  final String name;
  final String lecture;
  final CourseClass courseClass;
  final String? applicantName;
  final String? applicantEmail;
  final String? applicantPhone;
  final String? finalExamInfo;

  Course({
    required this.code,
    required this.name,
    required this.lecture,
    required this.courseClass,
    this.applicantName,
    this.applicantEmail,
    this.applicantPhone,
    this.finalExamInfo,
  });
}

class CourseClass {
  final String day;
  final String time;
  final String place;

  CourseClass({
    required this.day,
    required this.time,
    required this.place,
  });
}
