import 'package:csmkatalog/screens/admin_screen.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

import '../models/house.dart';

class HouseAdd extends StatefulWidget {
  HouseAdd({super.key, House? house}) {
    this.house = house ?? House.empty();
  }

  late House house;
  final nameController = TextEditingController();
  final landLengthController = TextEditingController();
  final landWidthController = TextEditingController();
  final houseLengthController = TextEditingController();
  final houseWidthController = TextEditingController();
  final bedroomsController = TextEditingController();

  @override
  State<HouseAdd> createState() => _HouseAddState();
}

class _HouseAddState extends State<HouseAdd> {
  // Here
  _HouseAddState () {
    // Fieldsny yang error
    if (widget.house.modelID != -1) {
      fields.add(editButtons);
      headerText = "Detail Model Rumah ${widget.house.name}";
      // TODO: set all fields to house details
    } else {
      fields.add(addButtons);
    }
  }
  late List<Widget> fields = [
    HouseAddItemTextDetail(label: "Nama", hintText: "Nama model rumah", textEditingController: widget.nameController),
    HouseAddItemTextDetail(label: "Jumlah Kamar Tidur", hintText: "Nama model rumah", textEditingController: widget.bedroomsController),
    HouseAddItemDimensionDetail(label: "tanah", lengthController: widget.landLengthController, widthController: widget.landWidthController, hintText: "tanah (meter)"),
    HouseAddItemDimensionDetail(label: "rumah", lengthController: widget.houseLengthController, widthController: widget.houseWidthController, hintText: "rumah (meter)"),
    HouseAddItemCheckboxDetail(label: "Ada dapur dalam", value: kitchenValue, onChanged: (b) => {
      setState(() {
        kitchenValue = b!;
      })
    },),
    HouseAddItemCheckboxDetail(label: "Ada teras", value: terraceValue, onChanged: (b) => {
      setState(() {
        terraceValue = b!;
      })
    },),
    HouseAddItemCheckboxDetail(label: "Ada loteng", value: atticValue, onChanged: (b) => {
      setState(() {
        atticValue = b!;
      })
    },),
  ];
  bool kitchenValue = false;
  bool terraceValue = false;
  bool atticValue = false;
  String headerText = "Tambah Model Rumah Baru";

  // Here

  Widget addButtons = Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      HouseSubmitButton(text: "Tambah", onPressed: () {
        // TODO: add function to add a new house to database
      },),
    ],
  );

  Widget editButtons = Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      HouseSubmitButton(text: "Ubah", onPressed: () {
        // TODO: add function to edit an existing house in database
      },),
      HouseSubmitButton(text: "Hapus", onPressed: () {
        // TODO: add function to delete an existing house in database
      },),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderAdminScreen(text: headerText),
        Expanded(
          child: DynamicHeightGridView(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            itemCount: fields.length,
            builder: (context, index) {
              return fields[index];
            }
          ),
        ),
      ],
    );
  }
}

class HouseSubmitButton extends StatelessWidget {
  const HouseSubmitButton({super.key, required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 120,
      child: FittedBox(
        child: FloatingActionButton.extended(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          extendedPadding: EdgeInsets.symmetric(horizontal: 32.0),
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          extendedTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
          label: Text(text,),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class HouseAddItemCheckboxDetail extends StatelessWidget {
  HouseAddItemCheckboxDetail({super.key, required this.label, required this.value, required this.onChanged});
  String label;
  bool value;
  void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text("${label}:"),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }
}

class HouseTextField extends StatelessWidget {
  HouseTextField({super.key, required this.hintText, required this.textEditingController});
  var hintText;
  var textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        height: 1.2,
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 1.0, bottom: 1.0, left: 8.0, right: 8.0),
          border: OutlineInputBorder(
              borderSide: BorderSide()
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
          ),
      ),
      controller: textEditingController,
    );
  }
}



class HouseAddItemDimensionDetail extends StatelessWidget {
  HouseAddItemDimensionDetail({super.key,
    required this.label,
    required this.lengthController,
    required this.widthController,
    required this.hintText
  });
  var label;
  var lengthController;
  var widthController;
  var hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: HouseAddItemTextDetail(label: "Panjang ${label}", hintText: "Panjang ${hintText}", textEditingController: lengthController)),
        SizedBox(width: 16.0,),
        Expanded(child: HouseAddItemTextDetail(label: "Lebar ${label}", hintText: "Lebar ${hintText}", textEditingController: widthController)),
      ],
    );
  }
}


class HouseAddItemTextDetail extends StatelessWidget {
  const HouseAddItemTextDetail({super.key, required this.label, required this.hintText, required this.textEditingController});
  final label;
  final hintText;
  final textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${label}:"),
        SizedBox(height: 8.0,),
        HouseTextField(
          hintText: hintText,
          textEditingController: textEditingController,
        ),
      ],
    );
  }
}

