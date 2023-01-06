import 'package:education/screens/list_grade.dart';
import 'package:education/screens/list_student.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Main Action'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Form Stucent'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Student List View'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(StudentListView.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.room),
            title: Text('Grade List View'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(GradeListView.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              // Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
