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

import 'dart:io' as io;

class StudenForm extends StatefulWidget {
  static const routeName = '/StudenForm';

  const StudenForm({Key? key}) : super(key: key);

  @override
  State<StudenForm> createState() => _StudenFormState();
}

class _StudenFormState extends State<StudenForm> {
  Student? editeStudent;
  io.File _file = io.File("zz");

  Uint8List webImagereadAsBytes = Uint8List(10);
  io.File? _imageFile;
  late Image image;
  late Image imageweb;
  XFile? pickedImage;
  TextEditingController dateinput = TextEditingController();

  List<Grade> itemsGrade = [];

  Grade? DropdownButtonGrade;
  var _isLoading = false;

  var _initValues = {
    'id': '',
    'firstName': '',
    'lastName': '',
    'email': '',
    'birthDate': '',
    'grade': '',
    'imageuri': '',
    'birrthDate': ''
  };
  Future<void> getGradeList() async {
    await Provider.of<Grades>(context, listen: false).getGradeListByPage(0, 50);

    itemsGrade = Provider.of<Grades>(context, listen: false).listGrade;
    print('getGradeListByPage');
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> takeImage(String inputSource) async {
    final picker = ImagePicker();

    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery);

      webImagereadAsBytes = (await pickedImage?.readAsBytes())!;

      if (kIsWeb) {
        imageweb = Image.network(pickedImage!.path);
      } else {
        image = Image.file(io.File(pickedImage!.path));
      }
      _imageFile = io.File(pickedImage!.path);
      path.basename(pickedImage!.path);

      setState(() {
        if (kIsWeb) {
          webImagereadAsBytes = webImagereadAsBytes;
          _imageFile = io.File(pickedImage!.path);
        } else {
          _imageFile = io.File(pickedImage!.path);
        }
        //  print(pickedImage!.path);
        editeStudent?.imageuri = path.basename(pickedImage!.path);
        // print(editeStudent?.imageuri);
      });
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
    if (editeStudent != null) {
      editeStudent?.imageuri =
          Setting.basicUrl + '\\uploads\\' + path.basename(_imageFile!.path);
      print('begin  uploads ');
      if (kIsWeb) {
        print('addStudentweb   uploads ');
        // await Provider.of<Students>(context, listen: false).addStudentweb(
        //     editeStudent!, webImagereadAsBytes, imageweb, pickedImage);
      } else {
        await Provider.of<Students>(context, listen: false)
            .addStudent(editeStudent!, _imageFile!, image, pickedImage);
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

        Navigator.of(context).pushReplacementNamed(StudentListView.routeName);
      },
    ).show();
  }

  bool _init = true;
  Future<void> didChangeDependencies() async {
    // final studentId = ModalRoute.of(context)?.settings.arguments as String?;
    final studentId = '993';
    println(' didChangeDependencies studentId  $studentId ');
    setState(() {
      _isLoading = false;
    });
    // ignore: unnecessary_null_comparison
    if (_init) {
      if (studentId != null) {
        _isLoading = true;
        await Provider.of<Students>(context, listen: false).findById(studentId);
        editeStudent =
            Provider.of<Students>(context, listen: false).currentStudent;
        await getGradeList();
        await Provider.of<Grades>(context, listen: false).getGradeById(3);
        println('after find by id grade');
        println(Provider.of<Grades>(context, listen: false)
            .currentGrad!
            .id
            .toString());
        // DropdownButtonGrade =
        //     Provider.of<Grades>(context, listen: false).currentGrad!;

        setState(() {
          _isLoading = false;
        });
        _init = false;

        dateinput.text = editeStudent?.brithDate == null
            ? ''
            : DateFormat('yyyy-MM-dd').format(editeStudent!.brithDate!);

        _initValues['id'] = (editeStudent?.id.toString() ?? 0.toString());

        _initValues['firstName'] = editeStudent?.firstName ?? '';
        _initValues['lastName'] = editeStudent?.lastName ?? '';
        ;
        _initValues['email'] = editeStudent?.email ?? '';
        ;
        _initValues['birthDate'] = editeStudent?.brithDate == null
            ? ''
            : DateFormat('yyyy-MM-dd').format(editeStudent!.brithDate!);
        _initValues['grade'] = editeStudent?.grade.toString() ?? '';
        _initValues['birthDate'] = editeStudent?.brithDate == null
            ? ''
            : DateFormat('yyyy-MM-dd').format(editeStudent!.brithDate!);

        println('curent ${editeStudent!.brithDate.toString()}');
      } else {
        _isLoading = true;
        // await Provider.of<Students>(context, listen: false)
        //  .findById(993.toString());
        editeStudent =
            Provider.of<Students>(context, listen: false).currentStudent;
        await getGradeList();
        await Provider.of<Grades>(context, listen: false).getGradeById(3);
        DropdownButtonGrade =
            Provider.of<Grades>(context, listen: false).currentGrad;
        println('after find by id grade');
        println(Provider.of<Grades>(context, listen: false)
            .currentGrad!
            .id
            .toString());
        // DropdownButtonGrade =
        //     Provider.of<Grades>(context, listen: false).currentGrad!;

        setState(() {
          _isLoading = false;
        });
      }
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
        body: _isLoading
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
                        decoration:
                            InputDecoration(label: Center(child: Text(' ID '))),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          if (value != null || value!.isNotEmpty) {}

                          //  print('onField onSaved  ID  ');
                        },
                        onFieldSubmitted: (value) {
                          //  print('onFieldSubmitted ID');
                        },
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        initialValue: _initValues['firstName'],
                        decoration: InputDecoration(label: Text('First Name ')),
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
                            editeStudent = Student(
                                firstName: value,
                                lastName: editeStudent!.lastName,
                                email: editeStudent!.email.toString(),
                                grade: editeStudent!.grade,
                                brithDate: editeStudent!.brithDate);
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
                            editeStudent = Student(
                                firstName: editeStudent!.firstName,
                                lastName: value,
                                grade: editeStudent!.grade,
                                email: editeStudent!.email.toString(),
                                brithDate: editeStudent!.brithDate);
                          }

                          print('onField onSaved  Last Name  ');
                        },
                        onFieldSubmitted: (value) {
                          // print('onFieldSubmitted Last Name');
                        },
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        initialValue: _initValues['lastName'],
                        decoration: InputDecoration(label: Text('fathr Name ')),
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
                            /*editeStudent = Student(
                          firstName: value,
                          lastName: editeStudent!.lastName,
                          email: editeStudent!.email.toString(),
                          brithDate: editeStudent!.brithDate);*/
                          }

                          print('onField onSaved  fathr Name  ');
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
                          if (value != null || value!.isNotEmpty) {}

                          // print('onField onSaved  Mother Name  ');
                        },
                        onFieldSubmitted: (value) {
                          //  print('onFieldSubmitted Mother Name');
                        },
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        initialValue: _initValues['id'],
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
                            /*editeStudent = Student(
                          firstName: value,
                          lastName: editeStudent!.lastName,
                          email: editeStudent!.email.toString(),
                          brithDate: editeStudent!.brithDate);*/
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
                            editeStudent = Student(
                              brithDate: DateTime.parse(newValue),
                              firstName: editeStudent!.firstName,
                              lastName: editeStudent!.lastName,
                              email: editeStudent!.email,
                              grade: editeStudent!.grade,
                            );
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
                            editeStudent = Student(
                                firstName: editeStudent!.firstName,
                                lastName: editeStudent!.lastName,
                                grade: editeStudent!.grade,
                                email: value,
                                brithDate: editeStudent!.brithDate);
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
                                child: _imageFile != null
                                    ? kIsWeb
                                        ? Image.memory(
                                            webImagereadAsBytes,
                                            fit: BoxFit.fill,
                                          ) //
                                        : Image.file(
                                            _imageFile!,
                                            fit: BoxFit.fill,
                                            // width: 75,
                                            // height: 75,
                                          )
                                    : Image.network(
                                        'http://${Setting.basicUrl}/downloadFile/person.png',
                                        fit: BoxFit.fill,
                                      ),
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
                          value: itemsGrade.length == 0 ||
                                  DropdownButtonGrade == null
                              ? null
                              : itemsGrade.firstWhere((element) =>
                                  element.id == DropdownButtonGrade?.id),
                          icon: const Icon(Icons.arrow_downward,
                              color: Colors.red),
                          elevation: 16,
                          // style: const TextStyle(color: Color.fromARGB(255, 5, 1, 0)),
                          underline: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                          items: itemsGrade
                              .map<DropdownMenuItem<Grade>>((Grade value) {
                            //  print('itemsGrade is  =  $itemsGrade.length');
                            return DropdownMenuItem<Grade>(
                              value: value,
                              child: Text(value.nameAr),
                            );
                          }).toList(),
                          itemHeight: 50,
                          onChanged: (value) {
                            print('grad id  =  ${value?.nameAr}');
                            setState(() {
                              DropdownButtonGrade = value;
                              //    print('grad id  =  {$value.id}');
                              editeStudent = Student(
                                  firstName: editeStudent!.firstName,
                                  lastName: editeStudent!.lastName,
                                  email: editeStudent!.email,
                                  brithDate: editeStudent!.brithDate,
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

  void println(String firstName) {}
}
