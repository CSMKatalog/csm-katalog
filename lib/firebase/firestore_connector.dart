import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csmkatalog/models/client.dart';
import 'package:csmkatalog/models/house.dart';
import 'dart:developer';

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

  static Future<void> createClient(Client client) async {
    await db.collection("clients").add(client.toJson());
  }

  static Future<List<Client>> readClients([ClientType? clientType]) async {
    List<Client> clients = [];
    await db.collection("clients").orderBy("timestamp").get().then((event) {
      for (var doc in event.docs) {
        Client client = Client.fromJson(doc.data(), doc.id);
        clients.add(client);
      }
    });
    if(clientType != null) {
      clients = clients.where((e) => e.clientType == clientType).toList();
    }
    return clients;
  }

  static Future<void> updateClient(String id, Client client) async {
    await db.collection("clients").doc(id).set(client.toJson());
  }

  static Future<void> deleteClient(String id) async {
    await db.collection("clients").doc(id).delete();
  }

  static Future<void> updateCover(String id, Map<String, dynamic> imageList) async {
    await db.collection("covers").doc(id).set(imageList);
  }

  static Future<Map<String, dynamic>> readCover() async {
    Map<String, dynamic> data = {};
    await db.collection("covers").get().then((event) {
      data["imageUrls"] = event.docs.first.data()["imageUrls"];
    });
    return data;
  }

  static Future<void> updateSettings(String id, Map<String, String> settings) async {
    await db.collection("settings").doc(id).set(settings);
  }

  static Future<Map<String, String>> readSettings() async {
    Map<String, String> settings = {};
    await db.collection("settings").get().then((event) {
      settings["interest_rate"] = event.docs.first.data()['interest_rate'];
      settings["office_contact"] = event.docs.first.data()['office_contact'];
    });
    return settings;
  }
}