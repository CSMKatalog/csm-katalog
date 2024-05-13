import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/house.dart';

class FirebaseConnector {
  late FirebaseFirestore db;

  FirebaseConnector() {
    db = FirebaseFirestore.instance;
  }

  void createHouse(House house) {
    db.collection("houses").add(house.toJson());
  }

  Future<List<House>> readHouses() async {
    List<House> houses = [];
    await db.collection("houses").get().then((event) {
      for (var doc in event.docs) {
        House house = House.fromJson(doc.data(), doc.id);
        houses.add(house);
      }
    });
    return houses;
  }
}