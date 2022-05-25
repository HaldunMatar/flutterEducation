import 'dart:convert';
import 'dart:io';

import 'package:education/model/setting.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'package:education/model/student.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path1;

import 'dart:convert' as convert;

import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';

import 'package:async/async.dart';
import 'package:path/path.dart';

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

    try {
      print('length is');
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        final jsonResponRes =
            convert.jsonDecode(responRes.body) as List<dynamic>;

        var itemCount = jsonResponRes.length;
        print('length is  $itemCount');

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

    try {
      //
      // print('length is');
      var responRes = await http.get(url);

      if (responRes.statusCode == 200) {
        final jsonResponRes =
            convert.jsonDecode(responRes.body) as List<dynamic>;

        var itemCount = jsonResponRes.length;
        print('length is  $itemCount');

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
    Map<String, String> queryParameters = {
      "searchString": searchString == null ? "" : searchString
    };

    var url = Uri.http(
        Setting.basicUrl,
        '/students/studentspage/ ${pagkey.toString()}/ ${num.toString()}',
        queryParameters);
    print(url.toString());
    _listStudent = [];

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

  addStudent(Student editeStudent, File image, Image imageupload) async {
    // print('addStudent');
    final url = Uri.http(Setting.basicUrl, '/students/new/');

    String? date;

    if (editeStudent.brithDate == null) {
      date = null;
    } else {
      date = DateFormat('yyyy-MM-dd').format(editeStudent.brithDate!);
    }

    print(date.toString());
    try {
      print(' before addStudent');
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
      print(editeStudent.toString());
      print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        print(parsed);
        try {
          image != null
              ? await uploadImage(image, parsed['id'].toString(), imageupload)
              : null;
        } on Exception catch (error) {
          print(" Image can not sore o server $error.toString() ");
        }
      } else
        throw Exception('Ithere is problem  in  request or response ');

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

// Upload camera photo to server
  Future uploadImage(File image, String parse, Image imageupload) async {
    uploadtest(image, imageupload);
/*
    final url = Uri.http(Setting.basicUrl, "/students/uploadFile");
    var request = http.MultipartRequest('POST', url);
    //print(parse);
    //print(image);

    print('Original path: ${image.path}');

    // String dir = path1.dirname(image.path);
    // String newPath = path1.join(dir, '$parse.jpg');

    // print('NewPath: ${newPath}');
    // print(image.path);
    // image.renameSync(newPath);
    //  File newImage = await image.copy(newPath);

    // await image.rename(newPath);
    //  print(newImage.path);
    //  var takenPicture =
    //    await http.MultipartFile.fromPath("file", newImage.path.toString());
    //await http.MultipartFile.fromPath("file", image.path.toString());
    //  request.files.add(takenPicture);

    //***************************
    // */

    var stream = new http.ByteStream(DelegatingStream(image.openRead()));

    stream.cast();
    Uint8List imageBytes;

    //var f = await image.readAsBytes();
    print(
        'Image 88888888888888888888888888888888888888888888888888888888888888888888888888888888!');
    // int length = f.length;

    var multipartFile = new http.MultipartFile('files', stream, 10,
        filename: 'hhhhhhhhhhhhhh', contentType: MediaType('image', 'png'));
    print('Image 9999999999999999999999999999999!');
    request.files.add(multipartFile);

    //**************************
    // */

    print('Image uploaded!');

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image  Student is uploaded!');
    } else {
      print('Image Student  not uploaded');
    }*/
  }

  uploadtest(File imageFile, Image imageupload) async {
    print(
        'uploadtestuploadtestuploadtestuploadtestuploadtestuploadtestuploadtestuploadtest');
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    //var length = await imageFile.length();

    // string to uri

    var uri = Uri.parse('${Setting.basicUrl} /students/uploadFile');
    print('sssssssssssssssssssssssssssss');

    print(uri);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    // multipart that takes file
    //   var multipartFile = new http.MultipartFile('file', stream, 200,
    //   filename: 'dddddddddddddddddddddddddd');

    request.files.add(http.MultipartFile.fromBytes(
        'picture', File(imageFile!.path).readAsBytesSync(),
        filename: '2222222'));
    print('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
    // add file to multipart
    //  request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);
    print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
