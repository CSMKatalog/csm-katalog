import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csmkatalog/models/client.dart';
import 'package:csmkatalog/models/house.dart';

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
    if (clientType == null) {
      await db.collection("clients").orderBy("timestamp").get().then((event) {
        for (var doc in event.docs) {
          Client client = Client.fromJson(doc.data(), doc.id);
          clients.add(client);
        }
      });
    } else {
      await db.collection("clients").where(
          "type", isEqualTo: clientTypeToString(clientType)).orderBy(
          "timestamp", descending: true).get().then((event) {
        for (var doc in event.docs) {
          Client client = Client.fromJson(doc.data(), doc.id);
          clients.add(client);
        }
      });
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
      data["imageUrls"] = event.docs[0].data()["imageUrls"];
    });
    return data;
  }
}