import 'package:flutter/material.dart';

import 'package:csmkatalog/firebase/firestore_connector.dart';
import 'package:csmkatalog/models/house.dart';

class HouseList extends StatefulWidget {
  const HouseList({super.key, required this.changeScreenListener});
  final Function(House house) changeScreenListener;

  @override
  State<HouseList> createState() => _HouseListState();
}

class _HouseListState extends State<HouseList> {
  List<House> houseList = [];
  late Future<dynamic> _future;

  Future<dynamic> fetchHouseList() async {
    var temp = await FirestoreConnector.readHouses();
    houseList = temp;
  }

  @override
  Widget build(BuildContext context) {
    _future = fetchHouseList();

    return SizedBox(
      width: MediaQuery.of(context).size.width/3,
      child: FutureBuilder(
        builder: (context, snapshot) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: houseList.length,
              itemBuilder: (context, index) {
                return HouseListItem(house: houseList[index], changeScreenListener: widget.changeScreenListener);
              }
          );
        }, future: _future,
      ),
    );
  }
}

class HouseListItem extends StatelessWidget {
  const HouseListItem({super.key, required this.house, required this.changeScreenListener});
  final House house;
  final Function(House house) changeScreenListener;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        changeScreenListener(house);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width/4,
                  child: Image.network(
                    house.imageUrls[0],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(house.name),
                Text("Rp. ${house.price}"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
