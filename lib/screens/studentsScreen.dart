import 'package:education/providers/students.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({Key? key}) : super(key: key);
  Future<void> _refreshstudents(BuildContext context) async {
    await Provider.of<Students>(context, listen: false).fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refreshstudents(context),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshstudents(context),
                  child: Consumer<Students>(
                    builder: (ctx, students, _) => Material(
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (_, i) => ListTile(
                          leading: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.teal[900],
                          ),
                          title: Text("Full Name"),
                          subtitle: Text('Grade 12, Division 3 .'),
                          trailing: Icon(Icons.done, color: Colors.pink),
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
