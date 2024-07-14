import 'package:intl/intl.dart';

String getRupiah(int text) {
  var formatter = NumberFormat('###,###,###,###');
  return "Rp. ${formatter.format(text).replaceAll(",", ".")},-";
}

bool isPhoneNumber(String text) {
  return text.length >= 10 && text.length <= 13;
}

String getPhoneNumber(String text) {
  var front = text.substring(0,4);
  var mid = text.substring(4,8);
  var back = text.substring(8);
  return "$front-$mid-$back";
}