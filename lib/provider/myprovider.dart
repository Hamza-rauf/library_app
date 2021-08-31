// import 'package:flutter/material.dart';
// import 'package:library_app/model/filemodel.dart';
//
// class MyProvider with ChangeNotifier {
//   bool isEditingText = false;
//   String name = "";
//   int index = 0;
//   List<FileModel>? fileListProvider = [];
//   TextEditingController? editingController = TextEditingController();
//   void updateList() {
//     fileListProvider.forEach((element) {
//       if (element.index == index) {
//         {
//           element.group = editingController.text[0].toUpperCase();
//           element.fileName = editingController.text;
//           isEditingText = false;
//           // editingController.clear();
//         }
//       }
//     });
//
//     notifyListeners();
//   }
// }
