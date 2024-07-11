import 'dart:async';

import 'package:csmkatalog/screens/catalog/catalog_widget.dart';
import 'package:csmkatalog/screens/catalog/contact_form.dart';
import 'package:csmkatalog/widgets/catalog/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:csmkatalog/firebase/firestore_connector.dart';
import 'package:csmkatalog/models/house.dart';

import 'calculator.dart';

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
  Widget? catalogWidgetOverlay;
  Widget? toastOverlay;
  String officeContact = '';
  double interest = 3.0975;
  late Timer timer;

  void fetchHouseList() async {
    List<House> temp = await FirestoreConnector.readHouses();
    Map<String, dynamic> imageList = await FirestoreConnector.readCover();
    temp.insert(0, House.cover(imageUrls: imageList["imageUrls"]));
    setState(() {
      houseList = temp;
      rowControllers = temp.map((e) => ScrollController()).toList();
    });
  }

  void fetchOfficeContact() async {
    Map<String, String> temp = await FirestoreConnector.readSettings();
    setState(() {
      officeContact = temp['office_contact']!;
      interest = double.parse(temp['interest_rate']!);
    });
  }

  void showToast(String message) async {
    setState(() {
      toastOverlay = Toast(message: message);
      timer = Timer(Duration(seconds: 2), () {
        setState(() {
          toastOverlay = null;
        });
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchHouseList();
    fetchOfficeContact();
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
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ListView.builder(
            controller: _columnController,
            physics: ImmediatePageScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return CatalogRow(houseList: houseList, houseIndex: index, controller: rowControllers[index], scrollCallbacks: scrollCallbacks);
            },
            itemCount: houseList.length,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CatalogWidget(
                  icon: Icons.calculate_outlined,
                  openWidgetListener: () {
                    setState(() {
                      catalogWidgetOverlay = CalculatorOverlay(
                        closeWidgetListener: () {
                          setState(() {
                            catalogWidgetOverlay = null;
                          });
                        },
                        missingValueToast: () {
                          showToast("Silahkan pilih tipe rumah terlebih dahulu");
                        },
                        moreThanPriceValueToast: () {
                          showToast("DP tidak dapat lebih dari harga rumah");
                        },
                        lessThanMinimumValueToast: () {
                          showToast("DP tidak dapat kurang dari DP minimum");
                        },
                        houseList: houseList, interest: interest,
                      );
                    });
                  },
                ),
                SizedBox(height: 10,),
                CatalogWidget(
                    icon: Icons.phone,
                    openWidgetListener: () {
                      setState(() {
                        catalogWidgetOverlay = ContactFormOverlay(
                          closeWidgetListener: () {
                            setState(() {
                              catalogWidgetOverlay = null;
                            });
                          },
                          submitWidgetListener: () {
                            setState(() {
                              catalogWidgetOverlay = ResultsOverlay(closeWidgetListener: () {
                                setState(() {
                                  catalogWidgetOverlay = null;
                                });
                              }, officeContact: officeContact,);
                            });
                          },
                          missingValueToast: () {
                            showToast("Ada data penting yang belum diisi");
                          },
                          houseList: houseList, officeContact: officeContact,
                        );
                      });
                    },
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
          if(catalogWidgetOverlay != null) catalogWidgetOverlay!,
          if(toastOverlay != null) Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              toastOverlay!
            ]
          ),
        ]
      ),
    );
  }
}

class CatalogScrollHelper extends StatefulWidget {
  const CatalogScrollHelper({super.key, required this.rowIndex, required this.colIndex, required this.lastRowIndex, required this.lastColIndex});
  final int rowIndex;
  final int colIndex;
  final int lastRowIndex;
  final int lastColIndex;

  @override
  State<CatalogScrollHelper> createState() => _CatalogScrollHelperState();
}

class _CatalogScrollHelperState extends State<CatalogScrollHelper> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          if(widget.rowIndex != 0) const CatalogArrow(icon: Icons.keyboard_arrow_up),
          Expanded(
              child: Row(
                children: [
                  if(widget.colIndex != 0) const CatalogArrow(icon: Icons.keyboard_arrow_left),
                  const Expanded(child: SizedBox()),
                  if(widget.colIndex != widget.lastColIndex) const CatalogArrow(icon: Icons.keyboard_arrow_right),
                ],
              )
          ),
          if(widget.rowIndex != widget.lastRowIndex) const CatalogArrow(icon: Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class CatalogArrow extends StatelessWidget {
  const CatalogArrow({super.key, required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(150, 150, 150, 0.1),
        ),
        child: Icon(
          icon,
          color: Colors.blue,
          weight: 20,
          size: 25,
        ),
      ),
    );
  }
}

class CatalogRow extends StatelessWidget {
  const CatalogRow({super.key, required this.houseList, required this.houseIndex, required this.controller, required this.scrollCallbacks});
  final List<House> houseList;
  final int houseIndex;
  final ScrollController controller;
  final Map<String, VoidCallback> scrollCallbacks;

  @override
  Widget build(BuildContext context) {
    List<StatelessWidget> rowItems = getRow(houseList[houseIndex], scrollCallbacks);
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
                  return Stack(
                    children: [
                      rowItems[index],
                      CatalogScrollHelper(
                          rowIndex: houseIndex,
                          colIndex: index,
                          lastRowIndex: houseList.length-1,
                          lastColIndex: rowItems.length-1)
                    ],
                  );
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  color: Colors.white,
                  child: Image.network(
                    url,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  )
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

  String getRupiah(nominal) {
    var formatter = NumberFormat('###,###,###,###');
    return "Rp. ${formatter.format(nominal).replaceAll(",", ".")},-";
  }

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(house.name, style: title,),
                    ],
                  ),
                  SizedBox(height: 3, child: Container(color: Colors.black87),),
                  SizedBox(height: MediaQuery.of(context).size.height/12 * widthCoefficient,),
                  Text("Total harga jual", style: normal,),
                  Text(getRupiah(house.price), style: bold,),
                  const SizedBox(height: 10),
                  for (String feature in house.features) Text(feature, style: bold),
                  Text("Luas tanah ${house.landDimensions} m²", style: normal,),
                  Text("Luas rumah ${house.houseDimensions} m²", style: normal,),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(house.buildingType, style: title,),
                    ],
                  ),
                  SizedBox(height: 3, child: Container(color: Colors.black87),),
                  SizedBox(height: MediaQuery.of(context).size.height/12 * widthCoefficient,),
                  Expanded(child: Text(house.description, style: small,),),
                  SizedBox(height: 1, child: Container(color: Colors.black87),),
                  Text("DP mulai dari", style: small,),
                  Text(getRupiah(house.downPayment), style: normal,),
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

class CatalogPolicyItem extends StatelessWidget {
  const CatalogPolicyItem({super.key, required this.house});
  final House house;

  @override
  Widget build(BuildContext context) {
    double widthCoefficient = MediaQuery.of(context).size.width > 750 ? 0.75 : (MediaQuery.of(context).size.width/1000);
    TextStyle tiny = TextStyle(
      fontSize: 22 * widthCoefficient,
      fontWeight: FontWeight.normal,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(house.name, style: title,),
            SizedBox(height: 3, child: Container(color: Colors.black87),),
            SizedBox(height: MediaQuery.of(context).size.height/12 * widthCoefficient,),
            for (final (index, criterion) in house.criteria.indexed) Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${index+1}.", style: tiny),
                SizedBox(width: 3,),
                Expanded(child: Container(child: Text(criterion, style: tiny, softWrap: true,))),
              ],
            ),
            const Expanded(child: SizedBox()),
            SizedBox(height: 1, child: Container(color: Colors.black87),),
            Text(".", style: padding,),
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
  rowItems.add(CatalogPolicyItem(house: house));
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

