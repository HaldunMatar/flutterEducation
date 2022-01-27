import 'package:education/providers/student.dart';
import 'package:education/providers/students.dart';
import 'package:education/screens/list_student.dart';
import 'package:education/screens/student_form.dart';
import 'package:education/screens/studentsScreen.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'screens/list_grade.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Students(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Education System',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => StudenForm(),
            StudentListView.routeName: (ctx) => StudentListView(),
            GradeListView.routeName: (ctx) => GradeListView(),
            StudenForm.routeName: (ctx) => StudenForm(),
          }),
    );
  }
}
