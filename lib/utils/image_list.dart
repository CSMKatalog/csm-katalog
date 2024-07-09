import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageList with ChangeNotifier {
  final List<Uint8List> imageList = [];

  void addImage(Uint8List image) {
    imageList.add(image);
    notifyListeners();
  }

  void deleteImage(int index) {
    imageList.removeAt(index);
    notifyListeners();
  }
}