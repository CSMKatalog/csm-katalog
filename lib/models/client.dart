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

Map<String, dynamic> getBlankProgress() {
  return {
    "ktpkk": {
      "done": false,
      "ktp": [],
      "kk": [],
    },
    "dp": {
      "done": false,
      "dp": [],
    },
    "bi": {
      "done": false,
      "bi": [],
    },
    "pendamping": {
      "done": false,
      "pasangan": [],
      "gaji3bln": [],
      "gajiskpg": [],
      "skk": [],
      "nip": [],
      "tbng3bln": [],
      "rmhlurah": [],
      "tbngbtn": [],
      "sku": [],
      "lku": [],
      "legalusaha": [],
      "mat600035": [],
    },
    "survei": {
      "done": false,
      "survei": [],
    },
    "kredit": {
      "done": false,
      "kredit": [],
    },
    "kunci": {
      "done": false,
      "kunci": [],
    },
  };
}

class Client {
  final String clientID;
  final ClientType clientType;
  final String house;
  final String name;
  final String phoneNumber;
  final String note;
  final Map<String, dynamic> progress;

  Client.empty() :
        clientID = "",
        clientType = ClientType.notInterested,
        house = "",
        name = "",
        phoneNumber = "",
        note = "",
        progress = getBlankProgress();

  Client ({
    required this.clientID,
    required this.clientType,
    required this.house,
    required this.name,
    required this.phoneNumber,
    required this.note,
    required this.progress,
  });

  factory Client.fromJson(Map<String, dynamic> json, String id) {
    var house = Client(
      clientID: id,
      clientType: stringToClientType(json["type"]),
      house: json["house"],
      name: json["name"],
      phoneNumber: json["phone"],
      note: json["notes"],
      progress: json["progress"],
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
    json["notes"] = note;
    json["progress"] = progress;
    json["timestamp"] = DateTime.now().millisecondsSinceEpoch / 60000;
    return json;
  }
}