import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'package:education/providers/student.dart';

import 'dart:convert' as convert;

import '../main.dart';

class Students with ChangeNotifier {
  late Student currentStudent;
  static const basicUrl = '10.0.2.2:8080';

  List<Student> _listStudent = [];
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

  Future<List<CharacterSummary>?>? getStudentList(
      int pageKey, int _pageSize) async {
    return [
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
      CharacterSummary('Musab'),
    ];
  }
}
