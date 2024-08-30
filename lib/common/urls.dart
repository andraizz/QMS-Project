part of 'common.dart';

//Mengatur Config atau host
class URLs {
  static const host = 'http://192.168.11.109:8000';
  static String image(String fileName) => '$host/documentation_installation/$fileName';
}