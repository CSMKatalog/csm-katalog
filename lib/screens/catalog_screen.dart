
import 'package:flutter/material.dart';

import '../models/house.dart';

class CatalogScreen extends StatelessWidget {
  CatalogScreen({super.key});

  // Untuk sementara digunakan data dummy
  static final List<House> houseList = dummyList;
  var catalogRows = houseList.map((e) => CatalogRow(house: e,)).toList();
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        physics: ImmediatePageScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return CatalogRow(house: houseList[index]);
        },
        itemCount: houseList.length,
      ),
    );
  }
}

class CatalogRow extends StatelessWidget {
  CatalogRow({super.key, required this.house});
  House house;

  @override
  Widget build(BuildContext context) {
    List<StatelessWidget> rowItems = getRow(house);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return rowItems[index];
                },
                itemCount: rowItems.length,
            ),
          ),
        ],
      ),
    );
  }
}

class CatalogImageItem extends StatelessWidget {
  const CatalogImageItem({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
      return Image.network(url);
  }
}

class CatalogDetailItem extends StatelessWidget {
  const CatalogDetailItem({super.key, required this.house});
  final House house;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(house.name),
        if(house.hasTerrace) Text("Lapangan luas"),
        if(house.hasAttic) Text("Gudang di atap"),
        if(house.hasInsideKitchen) Text("Dapur dalam rumah"),
      ],
    );
  }
}

class CatalogVideoItem extends StatelessWidget {
  const CatalogVideoItem({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Text(url);
  }
}

List<StatelessWidget> getRow(House house) {
  List<StatelessWidget> rowItems = [];
  if (house.imageUrls.isNotEmpty) {
    rowItems.add(CatalogImageItem(url: house.imageUrls[0]));
  }
  rowItems.add(CatalogDetailItem(house: house));
  if (house.imageUrls.isNotEmpty) {
    for (var url in house.imageUrls.sublist(1)) {
      rowItems.add(CatalogImageItem(url: url));
    }
  }
  for (var url in house.youtubeUrls) {
    rowItems.add(CatalogVideoItem(url: url));
  }
  return rowItems;
}

class ImmediatePageScrollPhysics extends PageScrollPhysics {
  @override
  double? get dragStartDistanceMotionThreshold => null;
}

