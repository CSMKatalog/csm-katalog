enum ClientType {interested, inProgress, bought, cancelled, notInterested }

String clientTypeToString(ClientType ct) {
  switch (ct) {
    case ClientType.bought: return 'Telah Membeli';
    case ClientType.cancelled: return 'Batal';
    case ClientType.inProgress: return 'Sedang Proses';
    case ClientType.interested: return 'Tertarik';
    case ClientType.notInterested: return 'Belum Tentu';
  }
}

ClientType stringToClientType(String s) {
  switch (s) {
    case 'Telah Membeli': return ClientType.bought;
    case 'Batal': return ClientType.cancelled;
    case 'Sedang Proses': return ClientType.inProgress;
    case 'Tertarik': return ClientType.interested;
    default: return ClientType.notInterested;
  }
}

class Client {
  final String clientID;
  final ClientType clientType;
  final String house;
  final String name;
  final String phoneNumber;
  final String note;

  Client.empty() :
        clientID = "",
        clientType = ClientType.notInterested,
        house = "",
        name = "",
        phoneNumber = "",
        note = "";

  Client ({
    required this.clientID,
    required this.clientType,
    required this.house,
    required this.name,
    required this.phoneNumber,
    required this.note,
  });

  factory Client.fromJson(Map<String, dynamic> json, String id) {
    var house = Client(
      clientID: id,
      clientType: stringToClientType(json["type"]),
      house: json["house"],
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
    json["type"] = clientTypeToString(clientType);
    json["house"] = house;
    json["name"] = name;
    json["phone"] = phoneNumber;
    json["rejection"] = note;
    json["timestamp"] = DateTime.now().millisecondsSinceEpoch / 60000;
    return json;
  }
}