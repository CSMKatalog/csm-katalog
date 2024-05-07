import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../models/house.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  static final List<House> houseList = dummyList;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final ScrollController _columnController = ScrollController();
  var rowControllers = CatalogScreen.houseList.map((e) => ScrollController()).toList();
  bool isVideo = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width*11/12;

    void scrollUp() {
      var columnOffset = _columnController.offset;
      _columnController.animateTo(columnOffset - height, duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
    void scrollDown() {
      var columnOffset = _columnController.offset;
      _columnController.animateTo(columnOffset + height, duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
    void scrollLeft() {
      var curRow = _columnController.offset ~/ height;
      var rowController = rowControllers[curRow];
      var rowOffset = rowController.offset;
      rowController.animateTo(rowOffset - width, duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
    void scrollRight() {
      var curRow = _columnController.offset ~/ height;
      var rowController = rowControllers[curRow];
      var rowOffset = rowController.offset;
      rowController.animateTo(rowOffset + width, duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
    var scrollCallbacks = {
      "up": scrollUp,
      "down": scrollDown,
      "left": scrollLeft,
      "right": scrollRight,
    };

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            if (false) SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Container(
                      color: Colors.grey,
                      child: GridView(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                        ),
                        children: [
                          SizedBox(),
                          CatalogScrollButton(onPressed: scrollUp, icon: Icons.keyboard_arrow_up),
                          SizedBox(),
                          CatalogScrollButton(onPressed: scrollLeft, icon: Icons.keyboard_arrow_left),
                          SizedBox(),
                          CatalogScrollButton(onPressed: scrollRight, icon: Icons.keyboard_arrow_right),
                          SizedBox(),
                          CatalogScrollButton(onPressed: scrollDown, icon: Icons.keyboard_arrow_down),
                          SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _columnController,
                physics: ImmediatePageScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return CatalogRow(house: CatalogScreen.houseList[index], controller: rowControllers[index], scrollCallbacks: scrollCallbacks);
                },
                itemCount: CatalogScreen.houseList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CatalogScrollButton extends StatelessWidget {
  const CatalogScrollButton({super.key, required this.onPressed, required this.icon});
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          color: Colors.blueGrey,
          child: Icon(icon, size: MediaQuery.of(context).size.width < 600 ? 10 : 20,),
        )
    );
  }
}


class CatalogRow extends StatelessWidget {

  const CatalogRow({super.key, required this.house, required this.controller, required this.scrollCallbacks});
  final House house;
  final ScrollController controller;
  final Map<String, VoidCallback> scrollCallbacks;

  @override
  Widget build(BuildContext context) {
    List<StatelessWidget> rowItems = getRow(house, scrollCallbacks);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              controller: controller,
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
              color: Colors.black87
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
  const CatalogVideoItem({super.key, required this.url, required this.scrollCallbacks});
  final String url;
  final Map<String, VoidCallback> scrollCallbacks;

  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(url)!,
      autoPlay: false,
      params: const YoutubePlayerParams(
        strictRelatedVideos: true,
        showControls: false,
      ),
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                child: YoutubePlayer(
                  controller: controller,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(onPressed: scrollCallbacks["left"], child: Icon(Icons.keyboard_arrow_left)),
                  FloatingActionButton(onPressed: scrollCallbacks["right"], child: Icon(Icons.keyboard_arrow_right)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<StatelessWidget> getRow(House house, Map<String, VoidCallback> scrollCallbacks) {
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
    rowItems.add(CatalogVideoItem(url: url, scrollCallbacks: scrollCallbacks,));
  }
  return rowItems;
}

class ImmediatePageScrollPhysics extends PageScrollPhysics {
  @override
  double? get dragStartDistanceMotionThreshold => null;
}

