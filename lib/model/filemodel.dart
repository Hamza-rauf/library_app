import 'dart:io';

import 'dart:typed_data';

class FileModel {
  Uint8List imageFile;
  String? fileName;
  String? group;
  late int index;
  String? fileExtention;
  FileModel(
      {required this.imageFile,
      this.fileExtention,
      this.fileName,
      this.group,
      required this.index});
}
