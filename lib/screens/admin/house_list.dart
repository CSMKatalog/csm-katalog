import 'package:flutter/material.dart';

import 'package:csmkatalog/firebase/firestore_connector.dart';
import 'package:csmkatalog/models/house.dart';
import 'package:csmkatalog/utils/utils.dart';

class HouseList extends StatefulWidget {
  const HouseList({super.key, required this.changeScreenListener});
  final Function(House house) changeScreenListener;

  @override
  State<HouseList> createState() => _HouseListState();
}

class _HouseListState extends State<HouseList> {
  List<House> houseList = [];

  void fetchHouseList() async {
    var temp = await FirestoreConnector.readHouses();
    setState(() {
        houseList = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHouseList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width/3,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: houseList.length,
          itemBuilder: (context, index) {
            return HouseListItem(house: houseList[index], changeScreenListener: widget.changeScreenListener);
          }
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
                  child: house.imageUrls.length > 0 ? Image.network(
                    house.imageUrls[0],
                    fit: BoxFit.contain,
                  ) : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Belum ada gambar"),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(house.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(getRupiah(house.price),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
