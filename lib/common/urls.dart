part of 'common.dart';

//Mengatur Config atau host
class URLs {
  static const host = 'https://devqms.triasmitra.com/public';

  static const hostStorage = 'https://devqms.triasmitra.com/storage';
  static String installationImage(String fileName) => '$hostStorage/app/public/$fileName';
}

class UrlsDms {
  static const host = 'http://35.219.106.161:8080';
}
