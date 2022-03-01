import 'dart:io';
import 'package:education/providers/grades.dart';
import 'package:intl/intl.dart';
import 'package:education/model/app_drawer.dart';
import 'package:education/model/student.dart';
import 'package:education/providers/students.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:validators/validators.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../model/grade.dart';

class StudenForm extends StatefulWidget {
  static const routeName = '/StudenForm';

  const StudenForm({Key? key}) : super(key: key);

  @override
  State<StudenForm> createState() => _StudenFormState();
}

class _StudenFormState extends State<StudenForm> {
  Student? _editeStudent = new Student(
      firstName: "dd",
      lastName: 'dfdfhd',
      email: 'ghjgf',
      brithDate: DateTime.now());
  File? _imageFile;
  TextEditingController dateinput = TextEditingController();

  List<Grade> itemsGrade = [];

  var DropdownButtonGrade = null;
  //Future<List<String>> items = await getGateList();
  // ignore: unused_element

  Future<void> getGradeList() async {
    itemsGrade = await Provider.of<Grades>(context, listen: false)
        .getGradeListByPage(0, 50);

    // items = newItems.map((e) => e.nameAr).toList();
  }

  @override
  void initState() {
    // getGateList();
    getGradeList();
    super.initState();
  }

  // ignore: unused_element
  Future<void> uploadImage(String inputSource) async {
    final picker = ImagePicker();
    PickedFile pickedImage;
    try {
      XFile? pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery);

      final String fileName = path.basename(pickedImage!.path);
      // _imageFile = File(pickedImage.path);

      setState(() {
        _imageFile = File(pickedImage.path);
        print(_imageFile);
      });

      await Provider.of<Students>(context, listen: false)
          .uploadImage(_imageFile!);

      /*
      final String url = await Provider.of<Products>(context, listen: false)
          .storeIamge(imageFile);

      _imageUrlController.text = url;

      setState(() {});

      // Refresh the UI
    */

    } on Exception catch (error) {
      print(error);
    }
  }

  //**************************************** */

  Future<void> _saveForm() async {
    /* _editeStudent = new Student(
        firstName: "dd",
        lastName: 'dfdfhd',
        email: 'ghjgf',
        brithDate: DateTime.now());*/

    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }

    _formKey.currentState?.save();
    if (_editeStudent != null) {
      _editeStudent?.grade = 10;
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
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration:
                      InputDecoration(label: Center(child: Text(' ID '))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter DI ';
                    }
                    print('onField validator   ID  ');
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    if (value != null || value!.isNotEmpty) {
                      /*_editeStudent = Student(
                          firstName: value,
                          lastName: _editeStudent!.lastName,
                          email: _editeStudent!.email.toString(),
                          brithDate: _editeStudent!.brithDate);*/
                    }

                    print('onField onSaved  ID  ');
                  },
                  onFieldSubmitted: (value) {
                    print('onFieldSubmitted ID');
                  },
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: InputDecoration(label: Text('First Name ')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter First Name ';
                    }
                    print('onField validator   First Name  ');
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    if (value != null || value!.isNotEmpty) {
                      _editeStudent = Student(
                          firstName: value,
                          lastName: _editeStudent!.lastName,
                          email: _editeStudent!.email.toString(),
                          brithDate: _editeStudent!.brithDate);
                    }

                    print('onField onSaved  First Name  ');
                  },
                  onFieldSubmitted: (value) {
                    print('onFieldSubmitted First Name');
                  },
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  decoration: InputDecoration(label: Text('Last Name ')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Last Name ';
                    }
                    // print('onField validator   Last Name  ');
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    if (value != null || value!.isNotEmpty) {
                      _editeStudent = Student(
                          firstName: value,
                          lastName: _editeStudent!.lastName,
                          email: _editeStudent!.email.toString(),
                          brithDate: _editeStudent!.brithDate);
                    }

                    print('onField onSaved  Last Name  ');
                  },
                  onFieldSubmitted: (value) {
                    print('onFieldSubmitted Last Name');
                  },
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  decoration: InputDecoration(label: Text('fathr Name ')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter fathr Name ';
                    }
                    print('onField validator   fathr Name  ');
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    if (value != null || value!.isNotEmpty) {
                      /*_editeStudent = Student(
                          firstName: value,
                          lastName: _editeStudent!.lastName,
                          email: _editeStudent!.email.toString(),
                          brithDate: _editeStudent!.brithDate);*/
                    }

                    print('onField onSaved  fathr Name  ');
                  },
                  onFieldSubmitted: (value) {
                    print('onFieldSubmitted fathr Name');
                  },
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  decoration: InputDecoration(label: Text('Mother Name ')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Mother Name ';
                    }
                    print('onField validator   Mother Name  ');
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    if (value != null || value!.isNotEmpty) {
                      /*_editeStudent = Student(
                          firstName: value,
                          lastName: _editeStudent!.lastName,
                          email: _editeStudent!.email.toString(),
                          brithDate: _editeStudent!.brithDate);*/
                    }

                    print('onField onSaved  Mother Name  ');
                  },
                  onFieldSubmitted: (value) {
                    print('onFieldSubmitted Mother Name');
                  },
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  decoration: InputDecoration(label: Text(' TC ')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter TC ';
                    }
                    print('onField validator   TC  ');
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    if (value != null || value!.isNotEmpty) {
                      /*_editeStudent = Student(
                          firstName: value,
                          lastName: _editeStudent!.lastName,
                          email: _editeStudent!.email.toString(),
                          brithDate: _editeStudent!.brithDate);*/
                    }

                    print('onField onSaved  TC  ');
                  },
                  onFieldSubmitted: (value) {
                    print('onFieldSubmitted TC');
                  },
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: dateinput,
                  // decoration: InputDecoration(label: Text('Brith Date ')),
                  textInputAction: TextInputAction.next,
                  // controller: dateinput, //editing controller of this TextField
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.red,
                      ), //icon of text field
                      labelText: "Enter Date" //label text of field
                      ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        dateinput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Brith Date ';
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    // print('updatedDt ' + newValue!);
                    if (newValue != null && newValue != '') {
                      _editeStudent = Student(
                        brithDate: DateTime.parse(newValue),
                        firstName: _editeStudent!.firstName,
                        lastName: _editeStudent!.lastName,
                        email: _editeStudent!.email,
                      );
                    }
                  },
                  onFieldSubmitted: (value) {
                    print('onFieldSubmitted');
                    print('updatedDt ' + value);
                  },
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  decoration: InputDecoration(label: Text('Email ')),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    if (value != null) {
                      _editeStudent = Student(
                          firstName: _editeStudent!.firstName,
                          lastName: _editeStudent!.lastName,
                          email: value,
                          brithDate: _editeStudent!.brithDate);
                    }
                  },
                  onFieldSubmitted: (value) {
                    print('onFieldSubmitted');
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val == null || val.isEmpty || isEmail(val)
                      ? null
                      : "Invalid Email",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          gradient: LinearGradient(
                              colors: [Colors.green, Colors.orange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          clipBehavior: Clip.hardEdge,
                          child: _imageFile != null
                              ? kIsWeb
                                  ? Image.network(
                                      _imageFile!.path,
                                      fit: BoxFit.fill,
                                      // width: 75,
                                      // height: 75,
                                    )
                                  : Image.file(
                                      _imageFile!,
                                      fit: BoxFit.fill,
                                      // width: 75,
                                      // height: 75,
                                    )
                              : null),
                    )),
                    IconButton(
                        onPressed: () async {
                          uploadImage('camera');
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.red[400],
                        )),
                  ],
                ),
                DropdownButton<Grade>(
                    value: DropdownButtonGrade,
                    icon: const Icon(Icons.arrow_downward, color: Colors.red),
                    elevation: 16,
                    // style: const TextStyle(color: Color.fromARGB(255, 5, 1, 0)),
                    underline: Container(
                      height: 2,
                      color: Colors.green,
                    ),
                    items:
                        itemsGrade.map<DropdownMenuItem<Grade>>((Grade value) {
                      print('itemsGrade =  $itemsGrade.length');
                      return DropdownMenuItem<Grade>(
                        value: value,
                        child: Text(value.nameAr),
                      );
                    }).toList(),
                    itemHeight: 50,
                    onChanged: (value) {
                      setState(() {
                        DropdownButtonGrade = value;

                        _editeStudent = Student(
                            firstName: _editeStudent!.firstName,
                            lastName: _editeStudent!.lastName,
                            email: _editeStudent!.email,
                            brithDate: _editeStudent!.brithDate,
                            grade: value?.id);
                      });
                    })
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
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
          onTap: (index) {},
        ));
  }
}

/*
String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return null;
  }*/


