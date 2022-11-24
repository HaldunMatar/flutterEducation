import 'package:education/providers/grades.dart';
import 'package:education/providers/students.dart';
import 'package:education/screens/list_student.dart';
import 'package:education/screens/student_form.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'screens/list_grade.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider.value(value: Grades()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Education System',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(secondary: Color.fromARGB(255, 70, 244, 54)),
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
