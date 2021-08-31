import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:library_app/controller/home_controller.dart';

class TextEditAble extends StatefulWidget {
  String title;
  int index;
  TextEditAble(this.title, this.index);
  @override
  _TextEditAbleState createState() => _TextEditAbleState();
}

class _TextEditAbleState extends State<TextEditAble> {
  @override
  void initState() {
    Get.find<HomeController>().name = widget.title;

    super.initState();
  }

  var focusNode;
  void getData() {
    focusNode = FocusNode(onKey: (node, event) {
      if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
        if (Get.find<HomeController>().editingController.text.isNotEmpty) {
          Get.find<HomeController>().updateList();
        } else {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please fill the text")));
          });
        }
      } else if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
        if (Get.find<HomeController>().editingController.text.isNotEmpty) {
          Get.find<HomeController>().updateList();
        } else {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please fill the text")));
          });
        }
      }
      return KeyEventResult.ignored;
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    Get.find<HomeController>().editingController = TextEditingController();

    if (Get.find<HomeController>().isEditingText) {
      return TextFormField(
        focusNode: focusNode,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.search,
        autofocus: true,
        controller: Get.find<HomeController>().editingController,
      );
    }
    return GetBuilder(
      init: HomeController(),
      builder: (HomeController _homeController) => InkWell(
          onDoubleTap: () {
            setState(() {
              _homeController.isEditingText = true;
              _homeController.index = widget.index;
            });
          },
          child: Text(
            _homeController.name,
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          )),
    );
  }
}
