import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/model/filemodel.dart';

class HomeController extends GetxController {
  bool isEditingText = false;
  String name = "";
  int index = 0;
  List<FileModel> fileListProvider = [];
  TextEditingController editingController = TextEditingController();
  void updateList() {
    fileListProvider.forEach((element) {
      if (element.index == index) {
        {
          element.group = editingController.text[0].toUpperCase();
          element.fileName = editingController.text;
          isEditingText = false;
          // editingController.clear();
        }
      }
    });
    update();
  }

  bool loaderState = false;
  changeLoaderState(bool updatedValue) {
    loaderState = updatedValue;
    update();
  }
}
