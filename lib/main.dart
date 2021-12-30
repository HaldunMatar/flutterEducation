import 'package:education/providers/students.dart';
import 'package:education/screens/studentsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      child: Consumer<Students>(
        builder: (ctx, students, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Education System',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              '/': (ctx) => StudentsScreen(),
            }),
      ),
    );
  }
}
