import 'package:flutter/material.dart';

import '../models/house.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  static final List<House> houseList = dummyList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListView.builder(
              itemBuilder: (context, index) {
                return CatalogRow(house: houseList[index]);
              },
            itemCount: houseList.length,
          ),
        ],
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

    return ListView.builder(
        itemBuilder: (context, index) {
          return rowItems[index];
        },
        itemCount: rowItems.length,
    );
  }
}

class CatalogImageItem extends StatelessWidget {
  const CatalogImageItem({super.key, required String url});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CatalogDetailItem extends StatelessWidget {
  const CatalogDetailItem({super.key, required House house});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CatalogVideoItem extends StatelessWidget {
  const CatalogVideoItem({super.key, required String url});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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


