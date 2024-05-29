import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/house.dart';

class FirestoreConnector {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> createHouse(House house) async {
    await db.collection("houses").add(house.toJson());
  }

  static Future<List<House>> readHouses() async {
    List<House> houses = [];
    await db.collection("houses").orderBy("timestamp").get().then((event) {
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

  static Future<void> updateCover(String id, Map<String, dynamic> imageList) async {
    await db.collection("covers").doc(id).set(imageList);
  }

  static Future<Map<String, dynamic>> readCover() async {
    Map<String, dynamic> data = {};
    await db.collection("covers").get().then((event) {
      data["imageUrls"] = event.docs[0].data()["imageUrls"];
    });
    return data;
  }
}