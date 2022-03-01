import 'dart:convert';
import 'dart:io';

import 'package:education/model/setting.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'package:education/model/student.dart';
import 'package:intl/intl.dart';

import 'dart:convert' as convert;

class Students with ChangeNotifier {
  late Student currentStudent;

  List<Student> _listStudent = [];

  List<Student> get listStudent => _listStudent;

  Students() {
    // fetchStudents();
  }
  Future<List<Student>> serachStudent(String stringSearch) async {
    // _listStudent = [];
    var url = Uri.http(Setting.basicUrl, '/students/allstudents/');
    List<Student>? res;
    try {
      print('length is');
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        const Utf8Codec utf8 = Utf8Codec();
        final jsonResponRes =
            convert.jsonDecode(responRes.body) as List<dynamic>;

        var itemCount = jsonResponRes.length;
        print('length is  $itemCount');

        var listquestion = jsonResponRes.map<dynamic>((e) => e).toList();
        print('list length ${jsonResponRes[5].toString()}');
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

    List<Student>? res;
    try {
      //
      // print('length is');
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        const Utf8Codec utf8 = Utf8Codec();
        final jsonResponRes =
            convert.jsonDecode(responRes.body) as List<dynamic>;

        var itemCount = jsonResponRes.length;
        print('length is  $itemCount');

        var listquestion = jsonResponRes.map<dynamic>((e) => e).toList();
        // print('list length ${jsonResponRes[5].toString()}');
        jsonResponRes.forEach((element) {
          _listStudent.add(Student(
              id: element['id'],
              lastName: element['firstName'],
              email: element['firstName'],
              firstName: element['firstName'],
              brithDate: element['brithDate']));
          //   print(element['id']);
          //  print(element['firstName']);
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

  Future<List<Student>> getStudentListByPage(
      int pagkey, int num, String? searchString) async {
    var url = Uri.http(Setting.basicUrl,
        '/students/studentspage/ ${pagkey.toString()}/ ${num.toString()}/${searchString}');
    print(url.toString());
    _listStudent = [];

    List<Student>? res;
    try {
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        const Utf8Codec utf8 = Utf8Codec();
        final jsonResponRes = convert
            .jsonDecode(utf8.decode(responRes.bodyBytes)) as List<dynamic>;

        var itemCount = jsonResponRes.length;
        print('length is  $itemCount');

        // var listquestion = jsonResponRes.map<dynamic>((e) => e).toList();
        //  print('list length ${jsonResponRes[5].toString()}');
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

          print(element['id'].toString() +
              ' firstName =  ${element['firstName']} ');
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

  addStudent(Student editeStudent) async {
    print('addStudent');
    final url = Uri.http(Setting.basicUrl, '/students/new/');
    String? formattedDate;
    String? date;

    if (editeStudent.brithDate == null) {
      date = null;
    } else {
      date = DateFormat('yyyy-MM-dd').format(editeStudent.brithDate!);
    }

    print(date.toString());
    try {
      print(' before addStudent');
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
        }),
      );

      print(response.body);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /*Upload(File img) async {
    var uri = Uri.parse('');

    var request = new http.MultipartRequest("POST", uri);
    request.files.add(new http.MultipartFile.fromBytes(
        "file", img.readAsBytesSync(),
        filename: "Photo.jpg", contentType: new MediaType("image", "jpg")));

    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }*/

// Upload camera photo to server
  Future uploadImage(File image) async {
    print('Image uploaded!');
    final uri =
        Uri.parse('http://' + Setting.basicUrl + "/students/storeImage");
    var request = http.MultipartRequest('POST', uri);
    print('Image uploaded!');
    var takenPicture = await http.MultipartFile.fromPath("image", image.path);
    request.files.add(takenPicture);
    print('Image uploaded!');

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded!');
    } else {
      print('Image not uploaded');
    }
  }
}
