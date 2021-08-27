import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    provider.editingController = TextEditingController();

    if (provider.isEditingText) {
      return TextFormField(
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
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
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }
}
