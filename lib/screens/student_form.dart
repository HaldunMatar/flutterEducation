import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:education/model/setting.dart';
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
import 'list_student.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb1;

import 'dart:io' as io;

class StudenForm extends StatefulWidget {
  static const routeName = '/StudenForm';

  const StudenForm({Key? key}) : super(key: key);

  @override
  State<StudenForm> createState() => _StudenFormState();
}

class _StudenFormState extends State<StudenForm> {
  Student? editeStudent;
  Grade? grade;
  io.File _file = io.File("zz");

  late Uint8List? webImagereadAsBytes = Uint8List(8);
  io.File? _imageFile;
  late Image image;
  late Image imageweb;
  XFile? pickedImagexfile;
  TextEditingController dateinput = TextEditingController();
  int? gradeid;
  List<Grade> itemsGrade = [];

  Grade? DropdownButtonGrade;
  var _isLoading = false;

  var _initValues = {
    'id': '',
    'TC': '888',
    'firstName': 'Haldun',
    'lastName': 'matar',
    'father': 'ahamd',
    'mother': 'hanaa',
    'email': 'sfsd@fsdf.com',
    'birthDate': '2022-10-21',
    'grade': '3',
    'imageuri': '',
  };

  late Students students;
  Future<void> getGradeList() async {
    await Provider.of<Grades>(context, listen: false).getGradeListByPage(0, 50);

    itemsGrade = Provider.of<Grades>(context, listen: false).listGrade;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> takeImage(String inputSource) async {
    final picker = ImagePicker();

    try {
      if (!kIsWeb) {
        final ImagePicker _picker = ImagePicker();

        pickedImagexfile = await _picker.pickImage(source: ImageSource.gallery);

        if (null != pickedImagexfile) {
          var selectefile = io.File(pickedImagexfile!.path);
          setState(() {
            _imageFile = selectefile;
          });
        }

        /*pickedImagexfile = await picker.pickImage(
            source: inputSource == 'camera'
                ? ImageSource.camera
                : ImageSource.gallery);*/

      } else {
        final ImagePicker _picker = ImagePicker();

        pickedImagexfile = await _picker.pickImage(source: ImageSource.gallery);

        if (null != pickedImagexfile) {
          var f = await pickedImagexfile?.readAsBytes();
          setState(() {
            webImagereadAsBytes = f;
            _imageFile = io.File('a');
          });
        }
      }
      /*
      image = Image.file(io.File(pickedImagexfile!.path));

      _imageFile = io.File(pickedImagexfile!.path);
      path.basename(pickedImagexfile!.path);
      editeStudent?.image = _imageFile;

      
      setState(() {
      
        _imageFile = io.File(pickedImagexfile!.path);
        editeStudent?.image = _imageFile;
       
        editeStudent?.imageuri = path.basename(pickedImagexfile!.path);
      });*/
    } on Exception catch (error) {
      print(" you do do not take image correctly  $error.toString() ");
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate();

    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();

    print(editeStudent);
    if (editeStudent != null) {
      print(editeStudent);
      // Android-specific code

      if (Platform.isAndroid) {
        editeStudent?.imageuri =
            Setting.basicUrl + '\\uploads\\' + path.basename(_imageFile!.path);
        editeStudent?.image = _imageFile;
      }
      // print('begin  uploads ');
      if (kIsWeb) {
        //   print('addStudentweb   uploads ');
        // await Provider.of<Students>(context, listen: false).addStudentweb(
        //     editeStudent!, webImagereadAsBytes, imageweb, pickedImage);
      } else {
        print("save savesavesavesave");
        print(editeStudent?.image);
        print("save savesavesavesave");
        print('father edite object ${editeStudent?.TC}');

        await Provider.of<Students>(context, listen: false)
            .addStudent(editeStudent!);
      }
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'ERROR',
        desc: 'Student has not  inserted.',
        btnOkOnPress: () {
          //Navigator.pop(context);

          // Navigator.of(context).pushReplacementNamed(StudentListView.routeName);
        },
      ).show();
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Success',
      desc: 'New Student has inserted.',
      btnOkOnPress: () {
        //Navigator.pop(context);

        //  Navigator.of(context).pushReplacementNamed(StudentListView.routeName);
      },
    ).show();
  }

  var studentId;
  bool _init = true;
  Future<void> _findById(BuildContext context, String? studentid) async {
    print('_findById_findById_findById_findById');
    // await getGradeList();
    await Provider.of<Grades>(context, listen: false).getGradeListByPage(0, 50);

    itemsGrade = Provider.of<Grades>(context, listen: false).listGrade;

    if (studentId != null) {
      print('Provider.of<Students>(context, listen: false).findById');
      await Provider.of<Students>(context, listen: false).findById(studentid!);

      editeStudent =
          Provider.of<Students>(context, listen: false).currentStudent;
      _initValues['id'] = (editeStudent?.id.toString() ?? 0.toString());
      _initValues['firstName'] = editeStudent?.firstName ?? '';
      _initValues['TC'] = editeStudent?.TC.toString() ?? '';
      _initValues['lastName'] = editeStudent?.lastName ?? '';
      _initValues['father'] = editeStudent?.father ?? '';
      _initValues['mother'] = editeStudent?.mother ?? '';
      _initValues['email'] = editeStudent?.email ?? '';
      _initValues['birthDate'] = editeStudent?.brithDate == null
          ? ''
          : DateFormat('yyyy-MM-dd').format(editeStudent!.brithDate!);
      _initValues['grade'] = editeStudent?.grade.toString() ?? '';
      _initValues['birthDate'] = editeStudent?.brithDate == null
          ? ''
          : DateFormat('yyyy-MM-dd').format(editeStudent!.brithDate!);
    }
  }

  Future<void> didChangeDependencies() async {
    studentId = ModalRoute.of(context)?.settings.arguments as String?;
    if (studentId == null) {
      editeStudent = Student.init();
    }
    super.didChangeDependencies();
  }

  final _formKey = GlobalKey<FormState>();
  void dispose() {
    dateinput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //   students = Provider.of<Students>(context, listen: true);
    print(' build    $studentId');
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
        body: FutureBuilder(
          future: _findById(context, studentId),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: EdgeInsets.all(16.5),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          readOnly: true,
                          initialValue: _initValues['id'],
                          decoration: InputDecoration(
                              label: Center(child: Text(' ID '))),
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            if (value != null || value!.isNotEmpty) {}
                            // editeStudent?.id = int.parse(value);
                            //  print('onField onSaved  ID  ');
                          },
                          onFieldSubmitted: (value) {
                            //  print('onFieldSubmitted ID');
                          },
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          initialValue: _initValues['firstName'],
                          decoration:
                              InputDecoration(label: Text('First Name ')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter First Name ';
                            }
                            // print('onField validator   First Name  ');
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            if (value != null || value!.isNotEmpty) {
                              editeStudent?.firstName = value;
                            }

                            //('onField onSaved  First Name  ');
                          },
                          onFieldSubmitted: (value) {
                            //  print('onFieldSubmitted First Name');
                          },
                          keyboardType: TextInputType.text,
                        ),
                        TextFormField(
                          initialValue: _initValues['lastName'],
                          decoration:
                              InputDecoration(label: Text('Last Name ')),
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
                              editeStudent?.lastName = value;
                            }

                            print('onField onSaved  Last Name  ');
                          },
                          onFieldSubmitted: (value) {
                            // print('onFieldSubmitted Last Name');
                          },
                          keyboardType: TextInputType.text,
                        ),
                        TextFormField(
                          initialValue: _initValues['father'],
                          decoration:
                              InputDecoration(label: Text('fathr Name ')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fathr Name ';
                            }
                            //  print('onField validator   fathr Name  ');
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            if (value != null || value!.isNotEmpty) {
                              editeStudent?.father = value;
                            }
                          },
                          onFieldSubmitted: (value) {
                            // print('onFieldSubmitted fathr Name');
                          },
                          keyboardType: TextInputType.text,
                        ),
                        TextFormField(
                          initialValue: _initValues['lastName'],
                          decoration:
                              InputDecoration(label: Text('Mother Name ')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Mother Name ';
                            }
                            // print('onField validator   Mother Name  ');
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            if (value != null || value!.isNotEmpty) {
                              editeStudent?.mother = value;
                            }

                            // print('onField onSaved  Mother Name  ');
                          },
                          onFieldSubmitted: (value) {
                            //  print('onFieldSubmitted Mother Name');
                          },
                          keyboardType: TextInputType.text,
                        ),
                        TextFormField(
                          initialValue: _initValues['TC'],
                          decoration: InputDecoration(label: Text(' TC ')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter TC ';
                            }
                            //  print('onField validator   TC  ');
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            if (value != null || value!.isNotEmpty) {
                              editeStudent?.TC = int.parse(value);
                            }

                            //print('onField onSaved  TC  ');
                          },
                          onFieldSubmitted: (value) {
                            // print('onFieldSubmitted TC');
                          },
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: dateinput,
                          textInputAction: TextInputAction.next,
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
                              setState(() {
                                dateinput.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
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
                              editeStudent?.brithDate =
                                  DateTime.parse(newValue);
                            }
                          },
                          onFieldSubmitted: (value) {
                            //    print('onFieldSubmitted');
                            //  print('updatedDt ' + value);
                          },
                          keyboardType: TextInputType.datetime,
                        ),
                        TextFormField(
                          initialValue: _initValues['email'],
                          decoration: InputDecoration(label: Text('Email ')),
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            if (value != null) {
                              editeStudent?.email = value;
                            }
                          },
                          onFieldSubmitted: (value) {
                            //  print('onFieldSubmitted');
                          },
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) =>
                              val == null || val.isEmpty || isEmail(val)
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    gradient: LinearGradient(
                                        colors: [Colors.green, Colors.orange],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    clipBehavior: Clip.hardEdge,
                                    child: studentId == null
                                        ? kIsWeb
                                            ? Image.memory(
                                                webImagereadAsBytes!,
                                                fit: BoxFit.fill,
                                              )
                                            : _imageFile != null
                                                ? Image.file(
                                                    _imageFile!,
                                                    fit: BoxFit.fill,
                                                    // width: 75,
                                                    // height: 75,
                                                  )
                                                : null
                                        : Image.network(
                                            'http://${Setting.basicUrl}/downloadFile/$studentId.jpg',
                                            fit: BoxFit.fill,
                                          )
                                    /* : (studentId != null)
                                            ? Image.network(
                                                'http://${Setting.basicUrl}/downloadFile/$studentId.jpg',
                                                fit: BoxFit.fill,
                                              )
                                            : Image.network(
                                                'http://${Setting.basicUrl}/downloadFile/person.png',
                                                fit: BoxFit.fill,
                                              ),*/
                                    ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  takeImage(Theme.of(context).platform ==
                                          TargetPlatform.android
                                      ? 'camera'
                                      : 'gallery');
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.red[400],
                                )),
                          ],
                        ),
                        DropdownButton<Grade>(
                            value: studentId != null
                                ? itemsGrade.firstWhere((element) =>
                                    element.id ==
                                    int.parse(_initValues['grade']!))
                                : null,
                            icon: const Icon(Icons.arrow_downward,
                                color: Colors.red),
                            elevation: 16,
                            underline: Container(
                              height: 2,
                              color: Colors.green,
                            ),
                            items: itemsGrade
                                .map<DropdownMenuItem<Grade>>((Grade value) {
                              return DropdownMenuItem<Grade>(
                                value: value,
                                child: Text(value.nameAr),
                              );
                            }).toList(),
                            itemHeight: 50,
                            onChanged: (value) {
                              setState(() {
                                DropdownButtonGrade = value;
                                editeStudent?.grade = value?.id;
                              });
                            })
                      ],
                    ),
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

  void println(String firstName) {}
}
