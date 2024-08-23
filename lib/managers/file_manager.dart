import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileManager{
  static Future<String?> loadTextFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
    if(result != null){
      // final extension = result.files.first.extension;
      // if(extension == 'txt'){
      final file = File(result.files.first.path!);
      return await file.readAsString();
      // } else if(extension == 'pdf'){}
    }
    return null;
  }
}