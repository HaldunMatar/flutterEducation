import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;
import 'package:education/model/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:education/model/student.dart';
import 'package:intl/intl.dart';
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
      var response;
      if (editeStudent.id == null) {
        response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers":
                "Access-Control-Allow-Origin, Accept"
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
      } else {
        response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers":
                "Access-Control-Allow-Origin, Accept"
          },
          body: json.encode({
            'id': editeStudent.id,
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
      }
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
            //editeStudent.image != null
            //  ? await uploadImage(editeStudent.image, parsed['id'].toString())
            // : null;
          } else if (kIsWeb) {
            /*editeStudent.webImagereadAsBytes != null
                ? await uploadImageweb(
                    editeStudent.webImagereadAsBytes, parsed['id'].toString())
                : null;*/
            editeStudent.objFile != null
                ? uploadSelectedFile(
                    editeStudent.objFile, parsed['id'].toString())
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
        //  print(
        //   'find findfindfindfindfindfindfindfindfindfindfindfindfindfindfindfindfind');
        //  print(jsonResponRes['tc']);
      } else {
        // print(responRes.body);
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
    //print(url);
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

void uploadSelectedFile(PlatformFile? objFile, String idfile) async {
  //---Create http package multipart request object

  print('uploadSelectedFileuploadSelectedFileuploadSelectedFile');
  print(idfile);
  print(idfile.length);

  final request = http.MultipartRequest(
    "POST",
    Uri.parse("http://${Setting.basicUrl}/students/uploadFileFromWeb"),
  );
  //-----add other fields if needed
  request.fields["fileid"] = idfile;
  //-----add selected file with request
  //print('beforesendbeforesendbeforesendbeforesend');
  //print(objFile);
  /*request.files.add(new http.MultipartFile(
      "file", objFile!.readStream!, objFile.size,
      filename: objFile.name));*/
  request.files.add(new http.MultipartFile.fromBytes(
      "file", objFile!.bytes as List<int>,
      filename: objFile.name));

  //print(request.url.toString());
  //print('send from web ');
  var resp = await request.send();
  //------Read response
  //String result = await resp.stream.bytesToString();

  //-------Your response
  //print(result);
}

Future uploadImageweb(Uint8List? webImagereadAsBytes, String string) async {
  print(" uploadImageweb uploadImageweb uploadImageweb uploadImageweb  ");
  final url = Uri.http(Setting.basicUrl, "/students/uploadFileFromWeb");
  var request = http.MultipartRequest('POST', url);

  List<int> slectedfile = webImagereadAsBytes!;
}

Future uploadImage(
  io.File? image,
  String parseid,
) async {
  print('uploadImageuploadImageuploadImageuploadImage');
  final url = Uri.http(Setting.basicUrl, "/students/uploadFile");
  var request = http.MultipartRequest('POST', url);

  if (image == null)
    print('uploadImage  is nu ll ');
  else
    print('uploadImage  is not null  ');

  print('uploadImage ${image?.path.toString()}');
  var takenPicture = await http.MultipartFile.fromPath(
      "file", image == null ? '' : image.path.toString());
  request.fields.addAll({'fileid': parseid});
  request.files.add(takenPicture);
  // print('afrer  takenPicture   belote ');

  var response = await request.send();
  if (response.statusCode == 200) {
    print(
        ' uploadImage  Image  Student is uploadedImage  Student is uploaded!');
  } else {
    print(' uploadImage Image Student  not uploaded');
  }
}
