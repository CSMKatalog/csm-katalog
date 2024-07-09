enum ClientType {interested, inProgress, bought, cancelled, notInterested }

String clientTypeToString(ClientType ct) {
  switch (ct) {
    case ClientType.bought: return 'bought';
    case ClientType.cancelled: return 'cancelled';
    case ClientType.inProgress: return 'inProgress';
    case ClientType.interested: return 'interested';
    case ClientType.notInterested: return 'notInterested';
  }
}

ClientType stringToClientType(String s) {
  switch (s) {
    case 'bought': return ClientType.bought;
    case 'cancelled': return ClientType.cancelled;
    case 'inProgress': return ClientType.inProgress;
    case 'interested': return ClientType.interested;
    default: return ClientType.notInterested;
  }
}

class Client {
  final String clientID;
  final ClientType clientType;
  final String modelID;
  final String name;
  final String phoneNumber;
  final String note;

  Client.empty() :
        clientID = "",
        clientType = ClientType.notInterested,
        modelID = "",
        name = "",
        phoneNumber = "",
        note = "";

  Client ({
    required this.clientID,
    required this.clientType,
    required this.modelID,
    required this.name,
    required this.phoneNumber,
    required this.note,
  });

  factory Client.fromJson(Map<String, dynamic> json, String id) {
    var house = Client(
      clientID: id,
      clientType: stringToClientType(json["type"]),
      modelID: json["house"],
      name: json["name"],
      phoneNumber: json["phone"],
      note: json["rejection"],
    );
    return house;
  }

  Map<String, dynamic> toJson([String? id]) {
    final Map<String, dynamic> json = {};
    if (id != null) {
      json["id"] = id;
    }
    json["type"] = clientType;
    json["house"] = modelID;
    json["name"] = name;
    json["phone"] = phoneNumber;
    json["rejection"] = note;
    json["timestamp"] = DateTime.now().millisecondsSinceEpoch / 60000;
    return json;
  }
}