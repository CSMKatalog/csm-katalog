
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/house.dart';

class CatalogScreen extends StatelessWidget {
  CatalogScreen({super.key});

  // Untuk sementara digunakan data dummy
  static final List<House> houseList = dummyList;
  var catalogRows = houseList.map((e) => CatalogRow(house: e,)).toList();
  var currentIndex = 0;

  final ScrollController _columnController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    void handleKeyEvent(RawKeyEvent event) {
      var columnOffset = _columnController.offset;
      var scrollOffset = MediaQuery.of(context).size.height;
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _columnController.animateTo(columnOffset - scrollOffset, duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
      else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _columnController.animateTo(columnOffset + scrollOffset, duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    }

    return Scaffold(
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: _focusNode,
        onKey: handleKeyEvent,
        child: ListView.builder(
          controller: _columnController,
          physics: ImmediatePageScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return CatalogRow(house: houseList[index]);
          },
          itemCount: houseList.length,
        ),
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
              physics: ImmediatePageScrollPhysics(),
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
      return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.black
            ),
            child: Center(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                    color: Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(url, height: double.infinity),
                ),
              ),
            ),
          )
      );
  }
}

class CatalogDetailItem extends StatelessWidget {
  const CatalogDetailItem({super.key, required this.house});
  final House house;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Text(house.name),
          if(house.hasTerrace) Text("Lapangan luas"),
          if(house.hasAttic) Text("Gudang di atap"),
          if(house.hasInsideKitchen) Text("Dapur dalam rumah"),
        ],
      ),
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

