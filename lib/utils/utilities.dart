import 'dart:math';

import 'package:flutter/material.dart';

class Utilities {
  static String getInitials({String firstname, String surname}) {
    String firstnameInitial = firstname != null ? firstname[0] : '';
    String surnameInitial = surname != null ? surname[0] : '';
    return '$firstnameInitial$surnameInitial'.toUpperCase();
  }

  static String generateRandomColor() {
    const predefinedColours = [
      '0xFFF44336', //red
      '0xFFE91E63', //pink
      '0xFFEF6C00', //orange[800]
      '0xFFFF5722', //deepOrange
      '0xFF1B5E20', //green[900]
      '0xFF00897B', //teal[600]
      '0xFF2196F3', //blue
      '0xFF455A64', //blueGrey[700]
      '0xFF03A9F4', //lightBlue
      '0xFF1A237E', //indigo[900]
      '0xFF9C27B0', //purple
      '0xFF00BCD4', //cyan
      '0xFF212121', //grey[900]
      '0xFF673AB7', //deepPurple
      '0xFF4E342E', //brown[800]
      '0xFFFFC107', //amber
    ];
    Random random = Random();
    return predefinedColours[random.nextInt(predefinedColours.length)];
  }

  static Color codeToColor(String colorCode) {
    return Color(
      int.parse(colorCode),
    ); //.substring(1, 7), radix: 16) + 0xFF000000);
  }

  // static Color generateRandomColor() {
  //   Random random = Random();
  //   double randomDouble = random.nextDouble();
  //   return Color((randomDouble * 0xFFFFFF).toInt()
  //   ).withOpacity(1.0);
  // }

  // static Color generateRandomColor() {
  //   Random random = Random();
  //   return Color.fromARGB(
  //     255,
  //     random.nextInt(256),
  //     random.nextInt(256),
  //     random.nextInt(256),
  //   );
  // }

  // static Future<PickedFile> pickImage(BuildContext context,
  //     {ImageSource source}) async {
  //   ImagePicker _picker;
  //   PickedFile _selectedImage = await _picker.getImage(source: source);
  //   // return compressImage(imageToCompress: selectedImage);
  //   _selectedImage != null
  //       ? Navigator.of(context)
  //           .pushNamed(CropImageRoute, arguments: File(_selectedImage.path))
  //       : Navigator.of(context).pop();
  //   return _selectedImage;
  // }

  // static Future<File> compressImage({File imageToCompress}) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;

  //   int randomName = Random().nextInt(10000);

  //   Image.Image image = Image.decodeImage(imageToCompress.readAsBytesSync());
  //   Image.copyResize(image, width: 500, height: 500);

  //   return new File('$path/img_$randomName.jpg')
  //     ..writeAsBytesSync(Image.encodeJpg(image, quality: 85));
  // }

  // Future saveToDocuments(File imageFile) async {
  //   final appDir = await getApplicationDocumentsDirectory();
  //   final fileName = basename(imageFile.path);
  //   final savedImage = await imageFile.copy('${appDir.path}/$fileName');
  // }
}
