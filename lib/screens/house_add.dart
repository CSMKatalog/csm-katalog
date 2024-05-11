import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:csmkatalog/screens/admin_screen.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/house.dart';

class HouseAdd extends StatefulWidget {
  HouseAdd({super.key, required this.house});
  House house;

  @override
  State<HouseAdd> createState() => _HouseAddState();
}

class _HouseAddState extends State<HouseAdd> {
  _HouseAddState ();

  final nameController = TextEditingController();
  final landLengthController = TextEditingController();
  final landWidthController = TextEditingController();
  final houseLengthController = TextEditingController();
  final houseWidthController = TextEditingController();
  final bedroomsController = TextEditingController();
  final youtubeController = TextEditingController();
  List<Widget> fields = [];
  List<Uint8List> listOfImages = [];
  List<String> listOfFeatures = [];
  bool kitchenValue = false;
  bool terraceValue = false;
  bool atticValue = false;
  String headerText = "Tambah Model Rumah Baru";

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

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'gif', 'svg']
    );

    if (result != null) {
      Uint8List image = result.files.single.bytes!;
      listOfImages.add(image);
    }
  }

  void deleteFile(int index) {
    ;
  }

  void appendFeature(String feature) {
    listOfFeatures.add(feature);
  }

  Future<Uint8List> imageUrlToImage(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  @override
  void initState() {
    super.initState();
    fields.add(HouseAddItemTextDetail(label: "Nama", hintText: "Nama model rumah", textEditingController: nameController),);
    fields.add(HouseAddItemTextDetail(label: "Jumlah Kamar Tidur", hintText: "Nama model rumah", textEditingController: bedroomsController),);
    fields.add(HouseAddItemDimensionDetail(label: "tanah", lengthController: landLengthController, widthController: landWidthController, hintText: "tanah (meter)"),);
    fields.add(HouseAddItemDimensionDetail(label: "rumah", lengthController: houseLengthController, widthController: houseWidthController, hintText: "rumah (meter)"),);
    fields.add(HouseAddItemCheckboxDetail(label: "Ada dapur dalam", value: kitchenValue, onChanged: () => {
      setState(() {
        kitchenValue = !kitchenValue;
      })
    },),);
    fields.add(HouseAddItemCheckboxDetail(label: "Ada teras", value: terraceValue, onChanged: () => {
      setState(() {
        terraceValue = !terraceValue;
      })
    },),);
    fields.add(HouseAddItemCheckboxDetail(label: "Ada loteng", value: atticValue, onChanged: () => {
      setState(() {
        atticValue = !atticValue;
      })
    },),);
    fields.add(HouseAddItemTextDetail(label: "Link URL Youtube", hintText: "Link video tour rumah", textEditingController: youtubeController));
    if (widget.house.modelID != -1) {
      fields.add(editButtons);
      House house = widget.house;
      headerText = "Detail Model Rumah ${house.name}";
      // TODO: set all fields to house details
      nameController.text = house.name;
      landLengthController.text = house.landDimensions.length.toString();
      landWidthController.text = house.landDimensions.width.toString();
      houseLengthController.text = house.houseDimensions.length.toString();
      houseWidthController.text = house.houseDimensions.length.toString();
      bedroomsController.text = house.bedrooms.toString();
      youtubeController.text = house.youtubeUrls[0];
      listOfImages = [];
      for(String imageUrl in house.imageUrls) {
        imageUrlToImage(imageUrl).then((value) => listOfImages.add(value));
      }
    } else {
      fields.add(addButtons);
    }
    fields.add(HouseAddItemImageDetail(
      uploadFile: uploadFile,
      deleteFile: (index) {listOfImages.removeAt(index);},
      listOfImages: listOfImages,
    ));
    fields.add(HouseAddItemTextListDetail(
      appendText: (value) {listOfFeatures.add(value);},
      deleteText: (index) {listOfFeatures.removeAt(index);},
      listOfString: listOfFeatures,
    ));
  }

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

class HouseAddItemCheckboxDetail extends StatefulWidget {
  HouseAddItemCheckboxDetail({super.key, required this.label, required this.value, required this.onChanged});
  String label;
  bool value;
  void Function() onChanged;

  @override
  State<HouseAddItemCheckboxDetail> createState() => _HouseAddItemCheckboxDetailState();
}

class _HouseAddItemCheckboxDetailState extends State<HouseAddItemCheckboxDetail> {
  late bool checkValue;

  @override
  void initState() {
    super.initState();
    checkValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text("${widget.label}:"),
      value: checkValue,
      onChanged: (b) => {
        widget.onChanged(),
        setState(() {
          checkValue = !checkValue;
        }),
      },
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

// TODO: How delete image
class HouseAddItemImageDetail extends StatefulWidget {
  const HouseAddItemImageDetail({super.key, required this.uploadFile, required this.deleteFile, required this.listOfImages});
  final AsyncCallback uploadFile;
  final Function deleteFile;
  final List<Uint8List> listOfImages;

  @override
  State<HouseAddItemImageDetail> createState() => _HouseAddItemImageDetailState();
}

class _HouseAddItemImageDetailState extends State<HouseAddItemImageDetail> {
  late List<Uint8List> listOfImages;
  bool isHovered = false;

  @override
  initState() {
    super.initState();
    listOfImages = widget.listOfImages;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1), borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.listOfImages.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      widget.deleteFile(index);
                    },
                    onHover: (b) {
                      setState(() {
                        isHovered = b;
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isHovered ? Colors.red : Colors.deepPurpleAccent,
                                    width: 1
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(4.0))),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.memory(widget.listOfImages[index]),
                            ),
                          ),
                        ),
                        Placeholder(
                          color: Colors.red,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.deepPurple, width: 1), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await widget.uploadFile();
                          setState(() {
                            listOfImages;
                          });
                        },
                        child: Text(
                          "Upload Gambar",
                          style: TextStyle(color: Colors.deepPurple,),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HouseAddItemTextListDetail extends StatefulWidget {
  const HouseAddItemTextListDetail({super.key, required this.appendText, required this.deleteText, required this.listOfString});
  final Function appendText;
  final Function deleteText;
  final List<String> listOfString;

  @override
  State<HouseAddItemTextListDetail> createState() => _HouseAddItemTextListDetailState();
}

class _HouseAddItemTextListDetailState extends State<HouseAddItemTextListDetail> {
  late List<String> listOfString;
  bool isHovered = false;

  @override
  initState() {
    super.initState();
    listOfString = widget.listOfString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1), borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.listOfString.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      widget.deleteText(index);
                    },
                    onHover: (b) {
                      setState(() {
                        isHovered = b;
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isHovered ? Colors.red : Colors.deepPurpleAccent,
                                    width: 1
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(4.0))),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(widget.listOfString[index]),
                            ),
                          ),
                        ),
                        Placeholder(
                          color: Colors.red,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.deepPurple, width: 1), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          widget.appendText();
                          setState(() {
                            listOfString;
                          });
                        },
                        child: Text(
                          "Upload Gambar",
                          style: TextStyle(color: Colors.deepPurple,),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}