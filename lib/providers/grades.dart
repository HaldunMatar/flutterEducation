import 'dart:convert';

import 'package:education/model/setting.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:convert' as convert;

import '../model/grade.dart';

class Grades with ChangeNotifier {
  List<Grade> listGrade = [];

  // List<Grade> itemsGrade = [];

  Future<List<Grade>> getGradeListByPage(int pageKey, int pageSize) async {
    var url =
        Uri.http(Setting.basicUrl, '/grades/gradespage/$pageKey/$pageSize');
    // print('length Grade Grade Grade Grade Grade Grade ');
    print(url.toString());
    // _listGrade = [];

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
          //  print('iiiiiiiiiiiiii   ${i}');
          listGrade.add(Grade(
            id: element['id'],
            nameAr: element['nameAr'],
            nameEn: element['nameEn'],
            nameTr: element['nameTr'],
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
    return listGrade;
  }
}
