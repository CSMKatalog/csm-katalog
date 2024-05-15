import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/house.dart';

class FirestoreConnector {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> createHouse(House house) async {
    await db.collection("houses").add(house.toJson());
  }

  static Future<List<House>> readHouses() async {
    List<House> houses = [];
    await db.collection("houses").get().then((event) {
      for (var doc in event.docs) {
        House house = House.fromJson(doc.data(), doc.id);
        houses.add(house);
      }
    });
    return houses;
  }

  static Future<void> updateHouse(String id, House house) async {
    await db.collection("houses").doc(id).set(house.toJson());
  }

  static Future<void> deleteHouse(String id) async {
    await db.collection("houses").doc(id).delete();
  }
}