part of 'common.dart';

//Mengatur Config atau host
class URLs {
  static const host = 'http://192.168.11.109:8000';
  static String installationImage(String fileName) => '$host/storage/installation/$fileName';
}

class UrlsDms {
  static const host = 'http://35.219.106.161:8080';
}
