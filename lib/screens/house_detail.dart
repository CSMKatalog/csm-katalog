import 'package:csmkatalog/models/house.dart';
import 'package:flutter/material.dart';

import 'house_add.dart';

class HouseDetail extends StatelessWidget {
  HouseDetail({super.key, required house}) {
    houseScreen = HouseAdd(house: house);
  }
  late HouseAdd houseScreen;

  @override
  Widget build(BuildContext context) {
    return houseScreen;
  }
}
