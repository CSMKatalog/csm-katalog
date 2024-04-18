import 'package:flutter/material.dart';

import '../models/house.dart';

class HouseList extends StatelessWidget {
  const HouseList({super.key});

  // Untuk sementara digunakan data dummy
  static final List<House> houseList = dummyList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width/3,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: houseList.length,
          itemBuilder: (context, index) {
            return HouseListItem(house: houseList[index]);
          }
      ),
    );
  }
}

class HouseListItem extends StatelessWidget {
  const HouseListItem({super.key, required this.house});
  final House house;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                width: MediaQuery.of(context).size.width/8,
                child: Image.network(
                  house.imageUrls[0],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(house.name),
              Text("Rp. ${house.price}"),
            ],
          )
        ],
      ),
    );
  }
}
