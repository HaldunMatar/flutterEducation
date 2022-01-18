import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'package:education/providers/student.dart';

import 'dart:convert' as convert;

class Grade {
  int? id;
  String nameAr;
  String nameEn;
  String nameTr;

  Grade(
      {this.id,
      required this.nameAr,
      required this.nameEn,
      required this.nameTr});
}
