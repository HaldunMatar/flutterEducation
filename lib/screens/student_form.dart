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
import 'package:uri_to_file/uri_to_file.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../model/grade.dart';
import 'dart:io' show Platform;

import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'dart:math';

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
  bool isImageLoaded = false;
  bool newimageupload = false;

  PlatformFile? objFile;

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
  Future<void> getGradeList() async {
    await Provider.of<Grades>(context, listen: false).getGradeListByPage(0, 50);

    itemsGrade = Provider.of<Grades>(context, listen: false).listGrade;
  }

  @override
  void initState() {
    super.initState();
  }

  void chooseFileUsingFilePicker() async {
    //-----pick file by file picker,

    var result = await FilePicker.platform.pickFiles(
      withReadStream:
          false, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
        //  print(
        //   "chooseFileUsingFilePickerchooseFileUsingFilePickerchooseFileUsingFilePicker");
        // print(result.files.first.bytes);

        webImagereadAsBytes = result.files.first.bytes;

        isImageLoaded = true;
      });
    }
  }

  Future<void> takeImage(String inputSource) async {
    final picker = ImagePicker();

    try {
      if (!kIsWeb) {
        final ImagePicker _picker = ImagePicker();

        newimageupload = true;

        pickedImagexfile = await _picker.pickImage(source: ImageSource.gallery);

        if (null != pickedImagexfile) {
          var selectefile = io.File(pickedImagexfile!.path);
          setState(() {
            _imageFile = selectefile;
          });
        }
      } else if (kIsWeb) {
        chooseFileUsingFilePicker();

        //   final ImagePicker _picker = ImagePicker();

        // pickedImagexfile = await _picker.pickImage(source: ImageSource.gallery);

        if (null != pickedImagexfile) {
          var f = await pickedImagexfile?.readAsBytes();
          setState(() {
            isImageLoaded = true;
            //webImagereadAsBytes = f;
            _imageFile = io.File('a');
          });
        }
      }
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
      // Android-specific code
      if (!kIsWeb) {
        if (editeStudent?.id != null) {
          if (!newimageupload)
            await urlToFile('/downloadFile/$studentId.jpg').then((value) {
              _imageFile = value;
            });
        }
        editeStudent?.imageuri =
            Setting.basicUrl + '\\uploads\\' + path.basename(_imageFile!.path);
        editeStudent?.image = _imageFile;
        // }
      }
      if (kIsWeb) {
        // print('assigned webImagereadAsBytes  to  editeStudent  ');
        // print(editeStudent?.firstName);

        editeStudent?.webImagereadAsBytes = webImagereadAsBytes;
        editeStudent?.objFile = objFile;
        //  print('webImagereadAsBytes?.length');
        // print(editeStudent?.webImagereadAsBytes?.length);
      }

      // print("save savesavesavesaveooooo");
      // print(editeStudent?.image);
      //  print("save savesavesavesave");
      // print('father edite object ${editeStudent?.father}');

      await Provider.of<Students>(context, listen: false)
          .addStudent(editeStudent!);
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
  Future<void> didChangeDependencies() async {
    //print('didChangeDependencies');
    studentId = ModalRoute.of(context)?.settings.arguments as String?;
    setState(() {
      _isLoading = false;
    });
    if (_init) {
      if (studentId != null) {
        print(studentId);
        _isLoading = true;
        await Provider.of<Students>(context, listen: false).findById(studentId);
        editeStudent =
            Provider.of<Students>(context, listen: false).currentStudent;
        await getGradeList();
        gradeid = editeStudent?.grade;
        try {
          DropdownButtonGrade =
              itemsGrade.firstWhere((element) => element.id == gradeid);
        } catch (e) {
          DropdownButtonGrade = null;
        }

        // remove this line
        dateinput.text = editeStudent?.brithDate == null
            ? ''
            : DateFormat('yyyy-MM-dd').format(editeStudent!.brithDate!);
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
        setState(() {
          _isLoading = false;
        });
      } else {
        editeStudent = new Student.init();
        _isLoading = true;
        await getGradeList();
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
                            editeStudent?.lastName = value;
                          }
                        },
                        onFieldSubmitted: (value) {
                          // print('onFieldSubmitted Last Name');
                        },
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        initialValue: _initValues['father'],
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
                          //  print('onField validator   Mother Name  ');
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          if (value != null || value!.isNotEmpty) {
                            editeStudent?.mother = value;
                          }

                          //    print('onField onSaved  Mother Name  ');
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
                          //  print('onField onSaved  tc tc  ');

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
                            //   print(
                            //   pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
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
                            editeStudent?.brithDate = DateTime.parse(newValue);
                          }
                          //   print('onField onSaved DateTime');
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
                                          ? objFile != null
                                              ? Image.memory(
                                                  webImagereadAsBytes!,
                                                  fit: BoxFit.fill,
                                                )
                                              : Center()
                                          : _imageFile != null
                                              ? Image.file(
                                                  _imageFile!,
                                                  fit: BoxFit.fill,
                                                  // width: 75,
                                                  // height: 75,
                                                )
                                              : null
                                      : isImageLoaded
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
                                takeImage('gallery');
                              }
                              /*   takeImage(Theme.of(context).platform ==
                                        TargetPlatform.android
                                    ? 'camera'
                                    : 'gallery');
                              }*/
                              ,
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.red[400],
                              )),
                        ],
                      ),
                      DropdownButton<Grade>(
                          value: DropdownButtonGrade,
                          /*gradeid != null
                              ? DropdownButtonGrade == null
                                  ? itemsGrade.length == 0 || gradeid == null
                                      ? null
                                      : itemsGrade.firstWhere(
                                          (element) => element.id == gradeid)
                                  : DropdownButtonGrade
                              : DropdownButtonGrade,*/
                          icon: const Icon(Icons.arrow_downward,
                              color: Colors.red),
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Colors.red,
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

Future<io.File> urlToFile(String imageUrl) async {
// generate random number.
  var rng = new Random();
// get temporary directory of device.
  io.Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
  String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
  io.File file =
      new io.File('$tempPath' + (rng.nextInt(100)).toString() + '.jpg');

// call http.get method and pass imageUrl into it to get response.

  final url = Uri.http(Setting.basicUrl, imageUrl);
  print('url.toString()');
  print(url.toString());
  http.Response response = await http.get(url);
  print(response.bodyBytes.length);
// write bodyBytes received in response to file.
  await file.writeAsBytes(response.bodyBytes);

// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
  return file;
}
