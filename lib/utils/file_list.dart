import 'dart:typed_data';
import 'package:flutter/material.dart';

class FileList with ChangeNotifier {
  final List<Uint8List> fileList = [];

  void addFile(Uint8List file) {
    fileList.add(file);
    notifyListeners();
  }

  void deleteFile(int index) {
    fileList.removeAt(index);
    notifyListeners();
  }
}