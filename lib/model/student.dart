import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Student with ChangeNotifier {
  int? id;
  String firstName = '';
  String lastName = '';
  String email = '';
  String? father;
  String? mother;
  DateTime? brithDate;
  int? grade;

  String? imageuri;

  File? image;
  PlatformFile? objFile;
  Uint8List? webImagereadAsBytes = Uint8List(8);

  int? TC;

  Student(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.brithDate,
      this.TC,
      this.father,
      this.mother,
      this.grade,
      this.image});
  Student.init();
}
