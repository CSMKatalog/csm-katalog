import 'dart:ffi';

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

  House({
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
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.rumah123.com%2Fpanduan-properti%2Ftips-properti-66343-panduan-rumah-tipe-36-harga-denah-desain-dan-dekorasi-2020-id.html&psig=AOvVaw2gDZ3AA-2nqacl_SsJkxCt&ust=1711457008464000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCNj2kqq4j4UDFQAAAAAdAAAAABAJ",
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.researchgate.net%2Ffigure%2FThe-observed-house-type-36-98-Saputra-2004_fig1_322080059&psig=AOvVaw2gDZ3AA-2nqacl_SsJkxCt&ust=1711457008464000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCNj2kqq4j4UDFQAAAAAdAAAAABAR",
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.99.co%2Fid%2Fpanduan%2Fukuran-rumah-tipe-36%2F&psig=AOvVaw2gDZ3AA-2nqacl_SsJkxCt&ust=1711457008464000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCNj2kqq4j4UDFQAAAAAdAAAAABAh",
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
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.kompas.com%2Fproperti%2Fread%2F2021%2F07%2F01%2F090000921%2Fperlu-diketahui-realisasi-kpr-subsidi-rata-rata-202666-unit-per-tahun&psig=AOvVaw1Ro6NbCwair88sO3y3RFW4&ust=1711461379554000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCKiCvM7Ij4UDFQAAAAAdAAAAABBA",
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.kompas.com%2Ftren%2Fread%2F2021%2F02%2F22%2F150300065%2Fcari-rumah-subsidi-cek-infonya-di-3-aplikasi-dan-situs-web-ini%3Fpage%3Dall&psig=AOvVaw1Ro6NbCwair88sO3y3RFW4&ust=1711461379554000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCKiCvM7Ij4UDFQAAAAAdAAAAABBI",
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pikiran-rakyat.com%2Fproperti%2Fpr-017501114%2Fcicilan-rp1-jutaan-dan-dp-1-persen-berikut-tabel-simulasi-angsuran-rumah-subsidi-di-bandung-2023%3Fpage%3Dall&psig=AOvVaw3g093y178SDddBQPPCPTBL&ust=1711461486696000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCKiNxoHJj4UDFQAAAAAdAAAAABAY",
      ],
    youtubeUrls: [],
  ),
];