class House {
  final String modelID;
  final String name;
  final Vector2 houseDimensions;
  final Vector2 landDimensions;
  final int floors;
  final int rooms;
  final List<String> allHouseNumbers;
  final List<String> occupiedHouseNumbers;
  final List<String> imageUrls;
  final int firstImage;
  final List<String> youtubeUrls;

  House({
    required this.modelID,
    required this.name,
    required this.houseDimensions,
    required this.landDimensions,
    required this.floors,
    required this.rooms,
    required this.allHouseNumbers,
    required this.occupiedHouseNumbers,
    required this.imageUrls,
    required this.firstImage,
    required this.youtubeUrls,
  });

  factory House.fromJson(
      Map<String, dynamic> json,) {
    json = json["data"];
    
    Vector2 houseDim = Vector2(width: json["house_width"], length: json["house_length"]);
    Vector2 landDim = Vector2(width: json["land_width"], length: json["land_length"]);
    var house = House(
      modelID: json["id"],
      name: json["name"],
      houseDimensions: houseDim,
      landDimensions: landDim,
      floors: json["floors"],
      rooms: json["rooms"],
      allHouseNumbers: json["all_hs"],
      occupiedHouseNumbers: json["open_hs"],
      imageUrls: json["images"],
      firstImage: json["first_image"],
      youtubeUrls: json["videos"]
    );
    return house;
  }
}

class Vector2 {
  double? width;
  double? length;

  Vector2({
    this.width,
    this.length,
  });

  @override
  String toString(){
    if (width != null && length != null){
      return "${width!} x ${length!} meter";
    }
    return "-";
  }
}