import 'package:intl/intl.dart';

String getRupiah(nominal) {
  var formatter = NumberFormat('###,###,###,###');
  return "Rp. ${formatter.format(nominal).replaceAll(",", ".")},-";
}