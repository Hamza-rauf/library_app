// @dart=2.9
import 'dart:async';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:library_app/controller/home_controller.dart';
import 'package:library_app/list_order/grouped_list.dart';
import 'package:library_app/model/filemodel.dart';
import 'package:library_app/widgets/texteditable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FileModel> fileList = [];
  HomeController homeController = Get.find<HomeController>();
  Random random = new Random();

  void _incrementCounter() async {
    Get.find<HomeController>().changeLoaderState(true);
    FilePickerResult result = await FilePicker.platform.pickFiles();
    int randomNumber = random.nextInt(1000);

    if (result != null && randomNumber != homeController.index) {
      Get.find<HomeController>().changeLoaderState(false);
      setState(() {
        homeController.fileListProvider.add(FileModel(
          imageFile: null,
          index: randomNumber,
          group: result.files.first.name[0].toUpperCase(),
          fileExtention: result.files.first.extension.toString(),
          fileName: result.files.first.name.split('.').first.toString(),
        ));
      });
    } else {
      Get.find<HomeController>().changeLoaderState(false);
      // User canceled the picker
    }
  }

  uploadImage(FileModel element) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        element.imageFile = file.bytes;
        Image image = new Image.memory(element.imageFile);
        Completer<ui.Image> completer = new Completer<ui.Image>();
        image.image.resolve(ImageConfiguration()).addListener(
            ImageStreamListener((ImageInfo info, bool synchronousCall) {
          completer.complete(info.image);
          print('Image Info--->>${info.image}');
        }));
        // print('ELEMENT--->>${element.imageFile}');
      });
    } else {
      // User canceled the picker
    }
  }

  Widget listTitleIcon(FileModel element) {
    if (element.imageFile == null) {
      if (element.fileExtention == "pdf") {
        return const FaIcon(FontAwesomeIcons.filePdf);
      }
      if (element.fileExtention == "word") {
        return const FaIcon(FontAwesomeIcons.fileWord);
      }
      return const FaIcon(FontAwesomeIcons.file);
    } else {
      return AspectRatio(
        aspectRatio: 2 / 4,
        child: Image.memory(
          element.imageFile,
          fit: BoxFit.fill,
        ),
      );
    }
  }

  Widget buildrenderItem(double l, double t, double r, double b) {
    return GetBuilder(
      init: HomeController(),
      builder: (HomeController _homeController) => Padding(
        padding: EdgeInsets.fromLTRB(l, t, r, b),
        child: GroupedListView<dynamic, String>(
          elements: _homeController.fileListProvider,
          groupBy: (element) => element.group,
          groupComparator: (value1, value2) => value2.compareTo(value1),
          itemComparator: (item1, item2) =>
              item1.fileName.compareTo(item2.fileName),
          order: GroupedListOrder.DESC,
          useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (c, element) {
            return ListTile(
              trailing: PopupMenuButton(
                icon: const FaIcon(FontAwesomeIcons.ellipsisV),
                onSelected: (result) {
                  if (result == 1) {
                    uploadImage(element);
                    setState(() {});
                  } else if (result == 2) {
                    setState(() {
                      _homeController.fileListProvider.removeWhere(
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
                ],
              ),
              title: TextEditAble(
                element.fileName.toString(),
                element.index,
              ),
              leading: listTitleIcon(element),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (HomeController _homeController) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_homeController.editingController.text.isNotEmpty) {
                _homeController.fileListProvider.forEach((element) {
                  if (element.index == _homeController.index) {
                    setState(() {
                      element.group = _homeController.editingController.text[0]
                          .toUpperCase();
                      element.fileName = _homeController.editingController.text;
                      _homeController.isEditingText = false;
                    });
                  }
                });
              } else {
                setState(() {
                  _homeController.isEditingText = false;
                });
              }

              // setState(() {
              //   provider.name = provider.editingController.text;
              //   provider.isEditingText = false;
              // });
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 1100) {
                      ///Desktop
                      return buildrenderItem(100, 100, 800, 10);
                    }
                    // If width it less then 1100 and more then 650 we consider it as tablet
                    else if (constraints.maxWidth >= 650) {
                      //Tablet

                      return buildrenderItem(100, 100, 400, 10);
                    }
                    //Mobile

                    // Or less then that we called it mobile
                    else {
                      return buildrenderItem(20, 20, 20, 10);
                    }
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
              floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerFloat, // This trailing comma makes auto-formatting nicer for build methods.
            ),
          ),
          _homeController.loaderState
              ? Container(
                  color: Colors.white.withOpacity(0.6),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
