import 'dart:convert';
import 'dart:typed_data';

class AppFunctions {
  Uint8List convertBase64Image(String base64String) {
    Uint8List bytes= Base64Decoder().convert(base64String.split(',').last);
    return bytes;
  }


}