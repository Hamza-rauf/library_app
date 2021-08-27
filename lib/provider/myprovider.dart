import 'package:flutter/material.dart';

class MyProvider with ChangeNotifier {
  bool isEditingText = false;
  String name = "";
  int index = 0;
   TextEditingController editingController = TextEditingController();
}
