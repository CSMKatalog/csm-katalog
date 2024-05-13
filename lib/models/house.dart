class House {
  final String modelID;
  final int price;
  final String name;
  final String description;
  final Vector2 houseDimensions;
  final Vector2 landDimensions;
  final bool hasAttic;
  final bool hasInsideKitchen;
  final bool hasTerrace;
  final int bedrooms;
  final List<String> allHouseNumbers;
  final List<String> unoccupiedHouseNumbers;
  final List<String> imageUrls;
  final List<String> youtubeUrls;
  final List<String> features;

  House.empty() :
        modelID = "",
        price = -1,
        name = "",
        description = "",
        houseDimensions = Vector2(length: -1, width: -1),
        landDimensions = Vector2(length: -1, width: -1),
        hasAttic = false,
        hasInsideKitchen = false,
        hasTerrace = false,
        bedrooms = -1,
        allHouseNumbers = [],
        unoccupiedHouseNumbers = [],
        imageUrls = [],
        youtubeUrls = [],
        features = [];

  House ({
    required this.modelID,
    required this.price,
    required this.name,
    required this.description,
    required this.houseDimensions,
    required this.landDimensions,
    required this.hasAttic,
    required this.hasInsideKitchen,
    required this.hasTerrace,
    required this.bedrooms,
    required this.allHouseNumbers,
    required this.unoccupiedHouseNumbers,
    required this.imageUrls,
    required this.youtubeUrls,
    required this.features,
  });

  factory House.fromJson(
      Map<String, dynamic> json,
      String id) {
    json = json["data"];
    
    Vector2 houseDim = Vector2(width: json["house_width"], length: json["house_length"]);
    Vector2 landDim = Vector2(width: json["land_width"], length: json["land_length"]);
    var house = House(
      modelID: id,
      price: json["price"],
      name: json["name"],
      description: json["description"],
      houseDimensions: houseDim,
      landDimensions: landDim,
      hasAttic: json["attic"],
      hasInsideKitchen: json["in_kitchen"],
      hasTerrace: json["terrace"],
      bedrooms: json["bedrooms"],
      allHouseNumbers: json["all_hs"],
      unoccupiedHouseNumbers: json["open_hs"],
      imageUrls: json["images"],
      youtubeUrls: json["videos"],
      features: json["features"],
    );
    return house;
  }

  Map<String, dynamic> toJson([String? id]) {
    Map<String, dynamic> json = {};
    if (id != null) {
      json["id"] = id;
    }
    json["price"] = price;
    json["name"] = name;
    json["description"] = description;
    json["house_width"] = houseDimensions.width;
    json["house_length"] = houseDimensions.length;
    json["land_width"] = landDimensions.width;
    json["land_length"] = landDimensions.length;
    json["attic"] = hasAttic;
    json["in_kitchen"] = hasInsideKitchen;
    json["terrace"] = hasTerrace;
    json["bedrooms"] = bedrooms;
    json["all_hs"] = allHouseNumbers;
    json["open_hs"] = unoccupiedHouseNumbers;
    json["images"] = imageUrls;
    json["videos"] = youtubeUrls;
    json["features"] = features;
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

var dummyList = [
  House(
    modelID: "1",
    price: 185000000,
    name: "Ocean Calm",
    description: "Lorem ipsum si dolor apsum si dolor amet.",
    houseDimensions: Vector2(length: 8, width: 7),
    landDimensions: Vector2(length: 10, width: 8),
    hasAttic: false,
    hasInsideKitchen: true,
    hasTerrace: true,
    bedrooms: 2,
    allHouseNumbers: ["201", "202", "203", "204", "205", "206", ],
    unoccupiedHouseNumbers: ["201", "204", "205", "206", ],
    imageUrls: [
        "https://img.antaranews.com/cache/1200x800/2019/07/12/WhatsApp_Image_2019-06-21_at_18_51_53_-1.jpeg.webp",
        "https://img.antaranews.com/cache/1200x800/2019/07/12/WhatsApp_Image_2019-06-21_at_18_51_53_-1.jpeg.webp",

      ],
    youtubeUrls: ["https://www.youtube.com/watch?v=nPbcg3a0unk"],
    features: ["Dapur tertutup", "Gudang loteng"],
  ),
  House(
    modelID: "2",
    price: 150000000,
    name: "River Jet",
    description: "Lorem ipsum si dolor amet ipsum si dolo.",
    houseDimensions: Vector2(length: 7, width: 6),
    landDimensions: Vector2(length: 10, width: 6),
    hasAttic: true,
    hasInsideKitchen: false,
    hasTerrace: false,
    bedrooms: 1,
    allHouseNumbers: ["101", "102", "103", "104", "105", "106", "301", "302", "303", "304", "401", "402", "403"],
    unoccupiedHouseNumbers: ["101", "104", "304", "401", "402", ],
    imageUrls: [
        "https://img.antaranews.com/cache/1200x800/2022/09/18/IMG-20220918-WA0025_2.jpg.webp",
        "https://img.antaranews.com/cache/1200x800/2023/02/07/rumah-subsidi-4.jpeg.webp",
        "https://assets.pikiran-rakyat.com/crop/283x0:1598x927/703x0/webp/photo/2022/09/18/49290791.jpeg",
      ],
    youtubeUrls: ["https://www.youtube.com/watch?v=UM51OOFKvJw"],
    features: ["Teras luas"],
  ),
];