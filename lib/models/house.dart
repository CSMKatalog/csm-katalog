class House {
  final String modelID;
  final String buildingType;
  final int price;
  final int downPayment;
  final String name;
  final String description;
  final double houseDimensions;
  final double landDimensions;
  final List<String> imageUrls;
  final List<String> youtubeUrls;
  final List<String> features;
  final List<String> criteria;

  House.empty() :
        modelID = "",
        buildingType = "",
        price = -1,
        downPayment = -1,
        name = "",
        description = "",
        houseDimensions = -1,
        landDimensions = -1,
        imageUrls = [],
        youtubeUrls = [],
        features = [],
        criteria = [];

  House ({
    required this.modelID,
    required this.buildingType,
    required this.price,
    required this.downPayment,
    required this.name,
    required this.description,
    required this.houseDimensions,
    required this.landDimensions,
    required this.imageUrls,
    required this.youtubeUrls,
    required this.features,
    required this.criteria,
  });

  House.cover({required List imageUrls}) :
        modelID = "coverCSM",
        buildingType = "",
        price = -1,
        downPayment = -1,
        name = "",
        description = "",
        houseDimensions = -1,
        landDimensions = -1,
        youtubeUrls = [],
        features = [],
        criteria = [],
        this.imageUrls = imageUrls.map((e) => e.toString()).toList();


  factory House.fromJson(
      Map<String, dynamic> json,
      String id) {
    // Vector2 houseDim = Vector2(width: json["house_width"], length: json["house_length"]);
    // Vector2 landDim = Vector2(width: json["land_width"], length: json["land_length"]);
    var house = House(
      modelID: id,
      buildingType: json["type"],
      price: json["price"],
      name: json["name"],
      downPayment: json["dp"],
      description: json["description"],
      houseDimensions: json["house_area"].toDouble(),
      landDimensions: json["land_area"].toDouble(),
      imageUrls: List<String>.from(json["images"]),
      youtubeUrls: List<String>.from(json["videos"]),
      features: List<String>.from(json["features"]),
      criteria: List<String>.from(json["criteria"]),
    );
    return house;
  }

  Map<String, dynamic> toJson([String? id]) {
    final Map<String, dynamic> json = {};
    if (id != null) {
      json["id"] = id;
    }
    json["type"] = buildingType;
    json["price"] = price;
    json["dp"] = downPayment;
    json["name"] = name;
    json["description"] = description;
    json["house_area"] = houseDimensions;
    json["land_area"] = landDimensions;
    json["images"] = imageUrls;
    json["videos"] = youtubeUrls;
    json["features"] = features;
    json["criteria"] = criteria;
    json["timestamp"] = DateTime.now().millisecondsSinceEpoch / 60000;
    return json;
  }
}

class Vector2 {
  double? length;
  double? width;

  Vector2({
    this.length,
    this.width,
  });

  @override
  String toString(){
    if (length != null && width != null){
      return "${length!} x ${width!} meter";
    }
    return "-";
  }
}

// var dummyList = [
//   House(
//     modelID: "1",
//     price: 185000000,
//     name: "Ocean Calm",
//     description: "Lorem ipsum si dolor apsum si dolor amet.",
//     houseDimensions: Vector2(length: 8, width: 7),
//     landDimensions: Vector2(length: 10, width: 8),
//     hasAttic: false,
//     hasInsideKitchen: true,
//     hasTerrace: true,
//     bedrooms: 2,
//     allHouseNumbers: ["201", "202", "203", "204", "205", "206", ],
//     unoccupiedHouseNumbers: ["201", "204", "205", "206", ],
//     imageUrls: [
//         "https://img.antaranews.com/cache/1200x800/2019/07/12/WhatsApp_Image_2019-06-21_at_18_51_53_-1.jpeg.webp",
//         "https://img.antaranews.com/cache/1200x800/2019/07/12/WhatsApp_Image_2019-06-21_at_18_51_53_-1.jpeg.webp",
//
//       ],
//     youtubeUrls: ["https://www.youtube.com/watch?v=nPbcg3a0unk"],
//     features: ["Dapur tertutup", "Gudang loteng"],
//   ),
//   House(
//     modelID: "2",
//     price: 150000000,
//     name: "River Jet",
//     description: "Lorem ipsum si dolor amet ipsum si dolo.",
//     houseDimensions: Vector2(length: 7, width: 6),
//     landDimensions: Vector2(length: 10, width: 6),
//     hasAttic: true,
//     hasInsideKitchen: false,
//     hasTerrace: false,
//     bedrooms: 1,
//     allHouseNumbers: ["101", "102", "103", "104", "105", "106", "301", "302", "303", "304", "401", "402", "403"],
//     unoccupiedHouseNumbers: ["101", "104", "304", "401", "402", ],
//     imageUrls: [
//         "https://img.antaranews.com/cache/1200x800/2022/09/18/IMG-20220918-WA0025_2.jpg.webp",
//         "https://img.antaranews.com/cache/1200x800/2023/02/07/rumah-subsidi-4.jpeg.webp",
//         "https://assets.pikiran-rakyat.com/crop/283x0:1598x927/703x0/webp/photo/2022/09/18/49290791.jpeg",
//       ],
//     youtubeUrls: ["https://www.youtube.com/watch?v=UM51OOFKvJw"],
//     features: ["Teras luas"],
//   ),
// ];