import 'package:flutter/material.dart';

class HouseAdd extends StatelessWidget {
  HouseAdd({super.key});

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            HouseAddItemDetail(label: "Nama model rumah", textEditingController: nameController)
          ],
        ),
        Column(),
      ],
    );
  }
}

class HouseAddItemDetail extends StatelessWidget {
  const HouseAddItemDetail({super.key, required this.label, required this.textEditingController});
  final label;
  final textEditingController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${label}:"),
          SizedBox(
            width: MediaQuery.of(context).size.width/3,
            child: TextField(
              decoration: InputDecoration(
                constraints: BoxConstraints.tightForFinite()
              ),
              controller: textEditingController,
            ),
          ),
        ],
      ),
    );
  }
}

