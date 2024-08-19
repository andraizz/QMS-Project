part of 'common.dart';

//Mengatur Config atau host
class URLs {
  static const host = 'http://192.168.11.109:8080';
  static String image(String fileName) => '$host/documentation_installation/$fileName';
}