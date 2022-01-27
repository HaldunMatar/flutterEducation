import 'dart:convert';

import 'package:education/model/grade.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'package:education/providers/student.dart';

import 'dart:convert' as convert;

import '../main.dart';

class Students with ChangeNotifier {
  late Student currentStudent;
  static const basicUrl = '10.0.2.2:8080';

  List<Student> _listStudent = [];
  List<Grade> _listGrade = [];

  List<Student> get listStudent => _listStudent;

  Students() {
    // fetchStudents();
  }

  Future<List<Student>?>? fetchStudents() async {
    _listStudent = [];
    var url = Uri.http(basicUrl, '/students/allstudents/');
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
          ));
          print(element['id']);
          print(element['firstName']);
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

  Future<List<Student>> getStudentListByPage(int pagkey, int num) async {
    var url = Uri.http(basicUrl,
        '/students/studentspage/ ${pagkey.toString()}/ ${num.toString()}');
    print(url.toString());
    _listStudent = [];

    List<Student>? res;
    try {
      print('length issssssssssssssssssssssssssss');
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        const Utf8Codec utf8 = Utf8Codec();
        final jsonResponRes = convert
            .jsonDecode(utf8.decode(responRes.bodyBytes)) as List<dynamic>;

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
          ));
          print(element['id']);
          print(element['firstName']);
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

  Future<List<Grade>> getGradeListByPage(int pageKey, int pageSize) async {
    var url = Uri.http(basicUrl, '/grades/gradespage/$pageKey/$pageSize');
    print('length Grade Grade Grade Grade Grade Grade ');
    print(url.toString());
    _listGrade = [];

    List<Grade>? res;
    try {
      print('length is');
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        const Utf8Codec utf8 = Utf8Codec();
        final jsonResponRes = convert
            .jsonDecode(utf8.decode(responRes.bodyBytes)) as List<dynamic>;

        var itemCount = jsonResponRes.length;
        print('length is  $itemCount');

        var listquestion = jsonResponRes.map<dynamic>((e) => e).toList();
        print('length is listquestion   ${listquestion.length}');
        print('list length ${jsonResponRes[1].toString()}');
        int i = 0;
        listquestion.forEach((element) {
          i = i + 1;
          print('iiiiiiiiiiiiii   ${i}');
          _listGrade.add(Grade(
            id: element['id'],
            nameAr: element['nameAr'],
            nameEn: 'hhhh',
            nameTr: 'hhhh',
          ));
          // print(element['id'].toString());
          // print(element['nameEn']);
        });
      } else {
        print('there is Error  in request with state${responRes.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      // throw (error);
    }
    notifyListeners();
    return _listGrade;
  }

  addStudent(Student editeStudent) async {
    final url = Uri.http(basicUrl, '/students/new/');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'firstName': editeStudent.firstName,
          'lastName': editeStudent.lastName,
          'email': editeStudent.email,
        }),
      );
      print(response.body);
      print(json.encode({
        'firstName': editeStudent.firstName,
        'lastName': editeStudent.lastName,
        'email': editeStudent.email,
      }));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
