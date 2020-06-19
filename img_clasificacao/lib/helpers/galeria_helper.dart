import 'dart:io';
import 'package:image_picker/image_picker.dart';

class GaleriaHelper {
  static Future<File> opengalery() async{
    var galery = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (galery == null) {
      return null;
    }
    return galery;
  }
  
}