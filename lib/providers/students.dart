import 'dart:convert';

import 'dart:io' as io;
import 'package:education/model/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:education/model/student.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path1;

import 'dart:convert' as convert;

import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';

import 'package:async/async.dart';
import 'package:path/path.dart';

class Students with ChangeNotifier {
  Student? get currentStudent1 => currentStudent;
  Student? currentStudent;
  List<Student> _listStudent = [];
  List<Student> get listStudent => _listStudent;
  // Student? _editeStudent = null;

  Students() {
    // fetchStudents();
  }

  Future<List<Student>> serachStudent(String stringSearch) async {
    // _listStudent = [];
    var url = Uri.http(Setting.basicUrl, '/students/allstudents/');

    try {
      // print('length is');
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        final jsonResponRes =
            convert.jsonDecode(responRes.body) as List<dynamic>;

        var itemCount = jsonResponRes.length;
        // print('length is  $itemCount');

        // print('list length ${jsonResponRes[5].toString()}');
        jsonResponRes.forEach((element) {
          _listStudent.add(Student(
              id: element['id'],
              lastName: element['firstName'],
              email: element['firstName'],
              firstName: element['firstName'],
              brithDate: element['brithDate']));
          // print(element['id']);
          // print(element['firstName']);
        });
      } else {
        print('there is Error  in request with state${responRes.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      // throw (error);
    }

    _listStudent = [];
    notifyListeners();
    return _listStudent;
  }

  Future<List<Student>> fetchStudents() async {
    _listStudent = [];
    var url = Uri.http(Setting.basicUrl, '/students/allstudents/');

    try {
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        final jsonResponRes =
            convert.jsonDecode(responRes.body) as List<dynamic>;

        var itemCount = jsonResponRes.length;

        jsonResponRes.forEach((element) {
          _listStudent.add(Student(
              id: element['id'],
              lastName: element['firstName'],
              email: element['firstName'],
              firstName: element['firstName'],
              brithDate: element['brithDate']));
        });
      } else {
        print('there is Error  in request with state${responRes.statusCode}');
      }
    } catch (error) {
      print(error.toString());
    }
    return _listStudent;
  }

  Future<List<Student>> getStudentListByPage(
      int pagkey, int num, String? searchString) async {
    Map<String, String> queryParameters = {
      "searchString": searchString == null ? "" : searchString
    };

    var url = Uri.http(
        Setting.basicUrl,
        '/students/studentspage/ ${pagkey.toString()}/ ${num.toString()}',
        queryParameters);
    _listStudent = [];

    try {
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        const Utf8Codec utf8 = Utf8Codec();
        final jsonResponRes = convert
            .jsonDecode(utf8.decode(responRes.bodyBytes)) as List<dynamic>;

        var itemCount = jsonResponRes.length;
        jsonResponRes.forEach((element) {
          String date = element['brithDate'] ?? ' ';
          var finaldate;
          try {
            finaldate = DateTime.parse(date).toString();
          } catch (error) {
            finaldate = null;
          }

          _listStudent.add(Student(
              id: element['id'],
              lastName: element['firstName'],
              email: element['firstName'],
              firstName: element['firstName'],
              brithDate: finaldate));

          // print(element['id'].toString() +
          //    ' firstName =  ${element['firstName']} ');
        });
      } else {
        print('there is Error  in request with state${responRes.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      // throw (error);
    }

    return _listStudent;
  }

  addStudent(Student editeStudent, io.File image, Image imageupload,
      XFile? pickedImage) async {
    final url = Uri.http(Setting.basicUrl, '/students/new/');

    String? date;

    if (editeStudent.brithDate == null) {
      date = null;
    } else {
      date = DateFormat('yyyy-MM-dd').format(editeStudent.brithDate!);
    }

    print(date.toString());
    try {
      //  print(' before addStudent');
      //  print(editeStudent.);

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
        },
        body: json.encode({
          'firstName': editeStudent.firstName,
          'lastName': editeStudent.lastName,
          'email': editeStudent.email,
          "birthDate": date,
          "grade": editeStudent.grade,
          //  "grade": 4,
          "imageuri": editeStudent.imageuri,
        }),
      );
      // print(editeStudent.toString());

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        //  print(parsed);
        try {
          image != null
              ? await uploadImage(
                  image, parsed['id'].toString(), imageupload, pickedImage)
              : null;
        } on Exception catch (error) {
          print(" Image can not store o server $error.toString() ");
        }
      } else
        throw Exception('Ithere is problem  in  request or response ');

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future uploadImage(io.File image, String parseid, Image imageupload,
      XFile? pickedImage) async {
    final url = Uri.http(Setting.basicUrl, "/students/uploadFile");
    var request = http.MultipartRequest('POST', url);

    //  print(image.path.toString());
    var takenPicture =
        await http.MultipartFile.fromPath("file", image.path.toString());
    request.fields.addAll({'fileid': parseid});
    request.files.add(takenPicture);
    // print('afrer  takenPicture   belote ');

    var response = await request.send();
    if (response.statusCode == 200) {
      // print('Image  Student is uploadedImage  Student is uploaded!');
    } else {
      //  print('Image Student  not uploaded');
    }
  }

  Future findById(String studentId) async {
    var url = Uri.http(Setting.basicUrl, '/students/get/$studentId');
    // print('length Grade Grade Grade Grade Grade Grade ');
    // print(' findById  ${url.toString()}');
    try {
      var responRes = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
        },
      );

      if (responRes.statusCode == 200) {
        const Utf8Codec utf8 = Utf8Codec();
        final jsonResponRes =
            convert.jsonDecode(utf8.decode(responRes.bodyBytes));
        currentStudent = Student(
            id: jsonResponRes['id'],
            firstName: jsonResponRes['firstName'],
            lastName: jsonResponRes['lastName'],
            email: jsonResponRes['email'],
            grade: jsonResponRes['grade'],
            brithDate: DateTime.parse(jsonResponRes['birthDate'])
                .add(Duration(days: 1)));
      } else {
        //  print(responRes.body);
      }
    } catch (error) {
      print(error.toString());
      // throw (error);
    }
    notifyListeners();
    // return currentStudent;
  }
}
