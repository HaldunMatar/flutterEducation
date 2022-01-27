import 'package:education/model/app_drawer.dart';
import 'package:education/providers/student.dart';
import 'package:education/providers/students.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudenForm extends StatefulWidget {
  static const routeName = '/StudenForm';

  const StudenForm({Key? key}) : super(key: key);

  @override
  State<StudenForm> createState() => _StudenFormState();
}

class _StudenFormState extends State<StudenForm> {
  Student? _editeStudent;

  Future<void> _saveForm() async {
    _editeStudent =
        new Student(firstName: "dd", lastName: 'dfdfhd', email: 'ghjgf');
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }

    _formKey.currentState?.save();
    if (_editeStudent != null) {
      await Provider.of<Students>(context, listen: false)
          .addStudent(_editeStudent!);
    } else {}
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('student Form'),
          actions: [
            IconButton(
                onPressed: () {
                  _saveForm();
                },
                icon: Icon(Icons.save)),
          ],
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: EdgeInsets.all(16.5),
          child: Form(
            key: _formKey,
            child: ListView(children: <Widget>[
              TextFormField(
                textInputAction: TextInputAction.next,
                validator: (value) {
                  print('validator');
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    _editeStudent = Student(
                      firstName: value,
                      lastName: _editeStudent!.lastName,
                      email: _editeStudent!.email.toString(),
                    );
                  }
                },
                onFieldSubmitted: (value) {
                  print('onFieldSubmitted');
                },
                decoration: InputDecoration(label: Text('First Name ')),
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                validator: (value) {
                  print('validator');
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    _editeStudent = Student(
                      firstName: _editeStudent!.firstName,
                      lastName: value,
                      email: _editeStudent!.email,
                    );
                  }
                },
                onFieldSubmitted: (value) {
                  print('onFieldSubmitted');
                },
                decoration: InputDecoration(label: Text('Last Name ')),
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                validator: (value) {
                  print('validator');
                  return null;
                },
                onSaved: (newValue) {
                  print('onSaved');
                },
                onFieldSubmitted: (value) {
                  print('onFieldSubmitted');
                },
                decoration: InputDecoration(label: Text('Brith Date ')),
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                validator: (value) {
                  print('validator');
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    _editeStudent = Student(
                      firstName: _editeStudent!.firstName,
                      lastName: _editeStudent!.lastName,
                      email: value,
                    );
                  }
                },
                onFieldSubmitted: (value) {
                  print('onFieldSubmitted');
                },
                decoration: InputDecoration(label: Text('Email ')),
                keyboardType: TextInputType.emailAddress,
              ),
            ]),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primaryVariant,
          //currentIndex: controller.currentIndex.value,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              icon: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.category,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              icon: Icon(
                Icons.category,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              icon: Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.settings,
                color: Colors.red,
              ),
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              label: '',
            ),
          ],
          onTap: (index) {
            // controller.currentIndex.value = index;
          },
        ));
  }
}
