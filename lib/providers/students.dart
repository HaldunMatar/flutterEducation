import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'package:education/providers/student.dart';

import 'dart:convert' as convert;

class Students with ChangeNotifier {
  late Student currentStudent;
  static const basicUrl = '10.0.2.2:8080';

  List<Student> _listStudent = [];
  List<Student> get listStudent => _listStudent;

  Students() {
    fetchStudents();
  }

  Future<List<Student>?>? fetchStudents() async {
    var url = Uri.http(basicUrl, '/students/allstudents/');
    List<Student>? res;
    try {
      print('length is');
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        final jsonResponRes =
            convert.jsonDecode(responRes.body) as List<dynamic>;

        var itemCount = jsonResponRes.length;
        print('length is  $itemCount');

        var listquestionId =
            jsonResponRes.map<dynamic>((e) => e['id']).toList();
        print('list length ${listquestionId[5]}');
        /*   jsonResponRes.forEach((element) {
          listQuestionId.add(element['id'])
          print(element['id']);
        }
        );*/
      } else {
        print('there is errr in request with state${responRes.statusCode}');
      }
    } catch (error) {
      print(error.toString());
      // throw (error);
    }

    return res;
  }
}
