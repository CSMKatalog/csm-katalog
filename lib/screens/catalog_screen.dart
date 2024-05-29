import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:csmkatalog/firebase/firestore_connector.dart';
import '../models/house.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final ScrollController _columnController = ScrollController();
  bool isVideo = false;
  List<ScrollController> rowControllers = [];
  List<House> houseList = [];

  void fetchHouseList() async {
    List<House> temp = await FirestoreConnector.readHouses();
    Map<String, dynamic> imageList = await FirestoreConnector.readCover();
    temp.insert(0, House.cover(imageUrls: imageList["imageUrls"]));
    setState(() {
      houseList = temp;
      rowControllers = temp.map((e) => ScrollController()).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHouseList();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width*11/12;

    void scrollUp() {
      var columnOffset = _columnController.offset;
      _columnController.animateTo(columnOffset - height, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
    void scrollDown() {
      var columnOffset = _columnController.offset;
      _columnController.animateTo(columnOffset + height, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
    void scrollLeft() {
      var curRow = _columnController.offset ~/ height;
      var rowController = rowControllers[curRow];
      var rowOffset = rowController.offset;
      rowController.animateTo(rowOffset - width, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
    void scrollRight() {
      var curRow = _columnController.offset ~/ height;
      var rowController = rowControllers[curRow];
      var rowOffset = rowController.offset;
      rowController.animateTo(rowOffset + width, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
    var scrollCallbacks = {
      "up": scrollUp,
      "down": scrollDown,
      "left": scrollLeft,
      "right": scrollRight,
    };

    return Scaffold(
      body: ListView.builder(
        controller: _columnController,
        physics: ImmediatePageScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return CatalogRow(house: houseList[index], controller: rowControllers[index], scrollCallbacks: scrollCallbacks);
        },
        itemCount: houseList.length,
      ),
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
    double widthCoefficient = MediaQuery.of(context).size.width > 750 ? 0.75 : (MediaQuery.of(context).size.width/1000);
    TextStyle normal = TextStyle(
      fontSize: 36 * widthCoefficient,
      fontWeight: FontWeight.normal,
    );
    TextStyle bold = TextStyle(
      fontSize: 38 * widthCoefficient,
      fontWeight: FontWeight.bold,
    );
    TextStyle title = TextStyle(
      fontSize: 48 * widthCoefficient,
      fontWeight: FontWeight.w300,
    );
    TextStyle small = TextStyle(
      fontSize: 28 * widthCoefficient,
      fontWeight: FontWeight.normal,
    );
    TextStyle padding = TextStyle(
      fontSize: 64 * widthCoefficient,
      color: Colors.transparent,
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50/widthCoefficient, horizontal: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(house.name, style: title,),
                  SizedBox(height: 3, child: Container(color: Colors.black87),),
                  SizedBox(height: MediaQuery.of(context).size.height/8 * widthCoefficient,),
                  for (String feature in house.features) Text(feature, style: bold),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Text(" kamar tidur", style: normal,)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Tanah ${house.landDimensions.toString()}", style: normal,),
                  Text("Rumah ${house.houseDimensions.toString()}", style: normal,),
                  const Expanded(child: SizedBox()),
                  SizedBox(height: 1, child: Container(color: Colors.black87),),
                  Text(".", style: padding,),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/4 * widthCoefficient,),
                  Expanded(child: Text(house.description, style: normal,)),
                  SizedBox(height: 1, child: Container(color: Colors.black87),),
                  Text("DP mulai dari", style: small,),
                  Text("Rp.${house.price.toString()},-", style: normal,),
                ],
              ),
            ),
          ],
        ),
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
                  FloatingActionButton(onPressed: scrollCallbacks["left"], child: const Icon(Icons.keyboard_arrow_left)),
                  FloatingActionButton(onPressed: scrollCallbacks["right"], child: const Icon(Icons.keyboard_arrow_right)),
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
  if (house.modelID == "coverCSM") {
    for (var url in house.imageUrls) {
      rowItems.add(CatalogImageItem(url: url));
    }
    return rowItems;
  }
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

