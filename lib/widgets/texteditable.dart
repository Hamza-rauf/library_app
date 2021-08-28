import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_app/provider/myprovider.dart';
import 'package:provider/provider.dart';

class TextEditAble extends StatefulWidget {
  String title;
  int index;
  TextEditAble(this.title, this.index);
  @override
  _TextEditAbleState createState() => _TextEditAbleState();
}

class _TextEditAbleState extends State<TextEditAble> {
  late MyProvider provider;
  @override
  void initState() {
    provider = Provider.of<MyProvider>(context, listen: false);
    provider.name = widget.title;

    super.initState();
  }

  var focusNode;
  void getData() {
    focusNode = FocusNode(onKey: (node, event) {
      if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
        if (provider.editingController.text.isNotEmpty) {
          provider.updateList();
        } else {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please fill the text")));
          });
        }
      } else if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
        if (provider.editingController.text.isNotEmpty) {
          provider.updateList();
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
    provider.editingController = TextEditingController();

    if (provider.isEditingText) {
      return TextFormField(
        focusNode: focusNode,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.search,
        autofocus: true,
        controller: provider.editingController,
      );
    }
    return InkWell(
        onDoubleTap: () {
          setState(() {
            provider.isEditingText = true;
            provider.index = widget.index;
          });
        },
        child: Text(
          provider.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }
}
