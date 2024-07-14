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
  final bool deleted;

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
        criteria = [],
        deleted = false;

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
    required this.deleted,
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
        this.imageUrls = imageUrls.map((e) => e.toString()).toList(),
        deleted = false;


  factory House.fromJson(
      Map<String, dynamic> json,
      String id) {
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
      deleted: json['deleted'],
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
    json["deleted"] = deleted.toString();
    return json;
  }
}