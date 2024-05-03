class House {
  final int modelID;
  final int price;
  final String name;
  final Vector2 houseDimensions;
  final Vector2 landDimensions;
  final bool hasAttic;
  final bool hasInsideKitchen;
  final bool hasTerrace;
  final int bedrooms;
  final List<String> allHouseNumbers;
  final List<String> occupiedHouseNumbers;
  final List<String> imageUrls;
  final List<String> youtubeUrls;

  House.empty() :
    modelID = -1,
    price = -1,
    name = "",
    houseDimensions = Vector2(length: -1, width: -1),
    landDimensions = Vector2(length: -1, width: -1),
    hasAttic = false,
    hasInsideKitchen = false,
    hasTerrace = false,
    bedrooms = -1,
    allHouseNumbers = [],
    occupiedHouseNumbers = [],
    imageUrls = [],
    youtubeUrls = [];

  House ({
    required this.modelID,
    required this.price,
    required this.name,
    required this.houseDimensions,
    required this.landDimensions,
    required this.hasAttic,
    required this.hasInsideKitchen,
    required this.hasTerrace,
    required this.bedrooms,
    required this.allHouseNumbers,
    required this.occupiedHouseNumbers,
    required this.imageUrls,
    required this.youtubeUrls,
  });

  factory House.fromJson(
      Map<String, dynamic> json,) {
    json = json["data"];
    
    Vector2 houseDim = Vector2(width: json["house_width"], length: json["house_length"]);
    Vector2 landDim = Vector2(width: json["land_width"], length: json["land_length"]);
    var house = House(
      modelID: json["id"],
      price: json["price"],
      name: json["name"],
      houseDimensions: houseDim,
      landDimensions: landDim,
      hasAttic: json["attic"],
      hasInsideKitchen: json["in_kitchen"],
      hasTerrace: json["terrace"],
      bedrooms: json["rooms"],
      allHouseNumbers: json["all_hs"],
      occupiedHouseNumbers: json["open_hs"],
      imageUrls: json["images"],
      youtubeUrls: json["videos"],
    );
    return house;
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
    modelID: 1,
    price: 185000000,
    name: "Ocean Calm",
    houseDimensions: Vector2(length: 8, width: 7),
    landDimensions: Vector2(length: 10, width: 8),
    hasAttic: false,
    hasInsideKitchen: true,
    hasTerrace: true,
    bedrooms: 2,
    allHouseNumbers: ["201", "202", "203", "204", "205", "206", ],
    occupiedHouseNumbers: ["201", "204", "205", "206", ],
    imageUrls: [
        "https://img.antaranews.com/cache/1200x800/2019/07/12/WhatsApp_Image_2019-06-21_at_18_51_53_-1.jpeg.webp",
        "https://img.antaranews.com/cache/1200x800/2019/07/12/WhatsApp_Image_2019-06-21_at_18_51_53_-1.jpeg.webp",

      ],
    youtubeUrls: [],
  ),
  House(
    modelID: 2,
    price: 150000000,
    name: "River Jet",
    houseDimensions: Vector2(length: 7, width: 6),
    landDimensions: Vector2(length: 10, width: 6),
    hasAttic: true,
    hasInsideKitchen: false,
    hasTerrace: false,
    bedrooms: 1,
    allHouseNumbers: ["101", "102", "103", "104", "105", "106", "301", "302", "303", "304", "401", "402", "403"],
    occupiedHouseNumbers: ["101", "104", "304", "401", "402", ],
    imageUrls: [
        "https://img.antaranews.com/cache/1200x800/2022/09/18/IMG-20220918-WA0025_2.jpg.webp",
        "https://img.antaranews.com/cache/1200x800/2023/02/07/rumah-subsidi-4.jpeg.webp",
        "https://assets.pikiran-rakyat.com/crop/283x0:1598x927/703x0/webp/photo/2022/09/18/49290791.jpeg",
      ],
    youtubeUrls: [],
  ),
];