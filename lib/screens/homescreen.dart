import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:library_app/list_order/grouped_list.dart';
import 'package:library_app/model/filemodel.dart';
import 'package:library_app/provider/myprovider.dart';
import 'package:library_app/widgets/texteditable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FileModel> fileList = [];
  late MyProvider provider;
  Random random = new Random();

  void _incrementCounter() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    int randomNumber = random.nextInt(1000);

    if (result != null && randomNumber != provider.index) {
      setState(() {
        fileList.add(FileModel(
          index: randomNumber,
          group: result.files.first.name[0].toUpperCase(),
          fileExtention: result.files.first.extension.toString(),
          fileName: result.files.first.name.split('.').first.toString(),
        ));
      });
    } else {
      // User canceled the picker
    }
  }

  Widget listTitleIcon(element) {
    if (element.fileExtention == "pdf") {
      return const FaIcon(FontAwesomeIcons.filePdf);
    }
    if (element.fileExtention == "word") {
      return const FaIcon(FontAwesomeIcons.fileWord);
    }
    return const FaIcon(FontAwesomeIcons.file);
  }

  String I = "FaIcon(FontAwesomeIcons.fileWord)";
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MyProvider>(context);
    return GestureDetector(
      onTap: () {
        if (provider.editingController.text.isNotEmpty) {
          fileList.forEach((element) {
            if (element.index == provider.index) {
              setState(() {
                element.group=provider.editingController.text[0].toUpperCase();
                element.fileName = provider.editingController.text;
                provider.isEditingText = false;
              });
            }
          });
        }

        // setState(() {
        //   provider.name = provider.editingController.text;
        //   provider.isEditingText = false;
        // });
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(500, 100, 500, 10),
          child: GroupedListView<dynamic, String>(
            elements: fileList,
            groupBy: (element) => element.group,
            groupComparator: (value1, value2) => value2.compareTo(value1),
            itemComparator: (item1, item2) =>
                item1.fileName.compareTo(item2.fileName),
            order: GroupedListOrder.DESC,
            useStickyGroupSeparators: false,
            groupSeparatorBuilder: (String value) => Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    textAlign: TextAlign.start,
                    style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            itemBuilder: (c, element) {
              return ListTile(
                trailing: PopupMenuButton(
                    icon: const FaIcon(FontAwesomeIcons.ellipsisV),
                    onSelected: (result) {
                      if (result == 2) {
                        setState(() {
                          fileList.removeWhere(
                              (item) => item.fileName == element.fileName);
                          // fileList.remove(element.fileName);
                        });
                      }
                    },
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Text("umbenennen"),
                              ],
                            ),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.picture_in_picture,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Text("Hintergrund"),
                              ],
                            ),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Text("Ioschen"),
                              ],
                            ),
                            value: 2,
                          ),
                        ]),
                title: TextEditAble(element.fileName.toString(), element.index),
                leading: listTitleIcon(element),
              );
            },
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          icon: FaIcon(FontAwesomeIcons.laptopMedical),
          label: Text('Upload Document'),
          backgroundColor: Colors.black54,
          onPressed: _incrementCounter,
          tooltip: 'Add File',
        ),
        /*floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,*/ // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
