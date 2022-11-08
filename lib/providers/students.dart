import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;
import 'dart:html' as html;
import 'package:education/model/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:education/model/student.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb1;

import 'dart:convert' as convert;

class Students with ChangeNotifier {
  // Student? _editeStudent = null;

  Students() {
    // fetchStudents();
  }

  Student? currentStudent;
  bool deleteprocess = false;

  List<Student> _listStudent = [];

  Student? get currentStudent1 => currentStudent;

  List<Student> get listStudent => _listStudent;

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

        // print('list length ${jsonResponRes[5].toString()}');
        jsonResponRes.forEach((element) {
          _listStudent.add(Student(
              id: element['id'],
              lastName: element['firstName'],
              email: element['firstName'],
              TC: element['TC'],
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
              TC: element['TC'],
              father: element['father'],
              mother: element['mother'],
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

          print("id di id  id   $element['id']");

          _listStudent.add(Student(
              id: element['id'],
              lastName: element['firstName'],
              father: element['father'],
              mother: element['mother'],
              email: element['firstName'],
              TC: element['TC'],
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

  addStudent(Student editeStudent) async {
    print('addStudentaddStudentaddStudentaddStudentaddStudent');
    final url = Uri.http(Setting.basicUrl, '/students/new/');
    print('tc   ${editeStudent.id} ');
    String? date;

    if (editeStudent.brithDate == null) {
      date = null;
    } else {
      date = DateFormat('yyyy-MM-dd').format(editeStudent.brithDate!);
    }
    try {
      print('postpostpostpostpostpost');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
        },
        body: json.encode({
          'firstName': editeStudent.firstName,
          'father': editeStudent.father,
          'mother': editeStudent.mother,
          'lastName': editeStudent.lastName,
          'tc': editeStudent.TC,
          'email': editeStudent.email,
          "birthDate": date,
          "grade": editeStudent.grade,
          "imageuri": editeStudent.imageuri,
        }),
      );
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        print('200200200200200200200200200200200200200200200');
        print(editeStudent.TC);
        print(parsed);
        try {
          //if (!kIsWeb) {
          //  if (Platform.isAndroid) {

          if (!kIsWeb) {
            editeStudent.image != null
                ? await uploadImage(editeStudent.image, parsed['id'].toString())
                : null;
          } else if (kIsWeb) {
            editeStudent.webImagereadAsBytes != null
                ? await uploadImageweb(
                    editeStudent.webImagereadAsBytes, parsed['id'].toString())
                : null;
          }

          // }
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

  Future findById(String studentId) async {
    var url = Uri.http(Setting.basicUrl, '/students/get/$studentId');

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
            TC: jsonResponRes['tc'] != null
                ? int.parse(jsonResponRes['tc'])
                : null,
            father: jsonResponRes['father'],
            mother: jsonResponRes['mother'],
            email: jsonResponRes['email'],
            grade: jsonResponRes['grade'],
            brithDate: DateTime.parse(jsonResponRes['birthDate'])
                .add(Duration(days: 1)));
        print(
            'find findfindfindfindfindfindfindfindfindfindfindfindfindfindfindfindfind');
        print(jsonResponRes['tc']);
      } else {
        print(responRes.body);
      }
    } catch (error) {
      print(error.toString());
      // throw (error);
    }
    notifyListeners();
    // return currentStudent;
  }

  Future<void> deletestudent(int? id) async {
    deleteprocess = true;
    var url = Uri.http(Setting.basicUrl, '/students/delete/$id');
    print(url);
    var responRes = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
      },
    );
    deleteprocess = false;
    notifyListeners();
  }
}

Future uploadImageweb(Uint8List? webImagereadAsBytes, String string) async {
  print(" uploadImageweb uploadImageweb uploadImageweb uploadImageweb  ");
  final url = Uri.http(Setting.basicUrl, "/students/uploadFileFromWeb");
  var request = http.MultipartRequest('POST', url);

  List<int> slectedfile = webImagereadAsBytes!;
  var image = http.MultipartFile.fromBytes('file', slectedfile!);

  // request.fields.addAll({'fileid': string});
  request.files.add(image, ContentType('primaryType', 'subType'));
  print(webImagereadAsBytes?.length);
  var response = await request.send();
  print(Setting.basicUrl + "/students/uploadFileFromWeb");

  /*var fdd = await http.post(
    Uri.parse(Setting.basicUrl + "/students/uploadFileFromWeb"),
    //headers: <String, String>{
    //   'Content-Type': 'image/jpeg',
    // },
    body: webImagereadAsBytes,
  );*/

  /* if (response.statusCode == 200) {
    // print('Image  Student is uploadedImage  Student is uploaded!');
  } else {
    print('Image Student  not uploaded');
  }*/
}

Future uploadImage(
  io.File? image,
  String parseid,
) async {
  print('uploadImageuploadImageuploadImageuploadImage');
  final url = Uri.http(Setting.basicUrl, "/students/uploadFile");
  var request = http.MultipartRequest('POST', url);

  //  print(image.path.toString());
  var takenPicture = await http.MultipartFile.fromPath(
      "file", image == null ? '' : image.path.toString());
  request.fields.addAll({'fileid': parseid});
  request.files.add(takenPicture);
  // print('afrer  takenPicture   belote ');

  var response = await request.send();
  if (response.statusCode == 200) {
    // print('Image  Student is uploadedImage  Student is uploaded!');
  } else {
    print('Image Student  not uploaded');
  }
}
