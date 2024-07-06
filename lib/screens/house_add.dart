import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:csmkatalog/screens/admin_screen.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:csmkatalog/firebase/firestorage_connector.dart';
import 'package:csmkatalog/firebase/firestore_connector.dart';

import '../models/house.dart';

class HouseAdd extends StatefulWidget {
  const HouseAdd({super.key, required this.house, required this.changeScreenListener});
  final House house;
  final VoidCallback changeScreenListener;

  @override
  State<HouseAdd> createState() => _HouseAddState();
}

class _HouseAddState extends State<HouseAdd> {
  _HouseAddState ();

  // TODO: Ini untuk data-data yang diperlukan untuk menampung data input
  final nameController = TextEditingController();
  final landAreaController = TextEditingController();
  final houseAreaController = TextEditingController();
  final priceController = TextEditingController();
  final dpController = TextEditingController();
  final typeController = TextEditingController();
  final descriptionController = TextEditingController();
  late List<Widget> fields;
  late ImageList listOfImages;
  late List<TextEditingController> listOfFeatures;
  late List<TextEditingController> listOfCriteria;
  late List<TextEditingController> listOfYoutubeUrls;
  String headerText = "Tambah Model Rumah Baru";

  Future<List<String>> uploadImageList() async {
    final List<String> imageUrls = [];
    for (Uint8List image in listOfImages.imageList) {
      String fileName = "image-${DateTime.now()}";
      String imageUrl = await FirestorageConnector.uploadFile(image, fileName);
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }

  // TODO: Ini untuk ubah data yang disimpan dan upload
  Future<void> uploadHouseDetail() async {
    double houseArea = double.parse(houseAreaController.value.text.replaceAll(",", "."));
    double landArea = double.parse(landAreaController.value.text.replaceAll(",", "."));
    int price = int.parse(priceController.value.text.replaceAll(",", "").replaceAll(".", ""));
    int dp = int.parse(dpController.value.text.replaceAll(",", "").replaceAll(".", ""));

    House house =  House(
      modelID: widget.house.modelID,
      buildingType: typeController.value.text,
      price: price,
      downPayment: dp,
      name: nameController.value.text,
      description: descriptionController.value.text,
      houseDimensions: houseArea,
      landDimensions: landArea,
      imageUrls: await uploadImageList(),
      youtubeUrls: listOfYoutubeUrls.map((e) => e.value.text).toList(),
      features: listOfFeatures.map((e) => e.value.text).toList(),
      criteria: listOfCriteria.map((e) => e.value.text).toList(),
    );

    if (widget.house.modelID.isNotEmpty) {
      await FirestoreConnector.updateHouse(widget.house.modelID, house)
          .then((value) => widget.changeScreenListener());
    } else {
      await FirestoreConnector.createHouse(house)
          .then((value) => widget.changeScreenListener());
    }
  }

  Future<void> reuploadHouseDetail() async {
    for (var imageUrl in widget.house.imageUrls) {
      FirestorageConnector.deleteFile(Uri.parse(imageUrl).pathSegments.last);
    }
    await uploadHouseDetail();
  }

  Future<void> deleteHouseDetail() async {
    for (var imageUrl in widget.house.imageUrls) {
      FirestorageConnector.deleteFile(Uri.parse(imageUrl).pathSegments.last);
    }
    await FirestoreConnector.deleteHouse(widget.house.modelID)
        .then((value) => widget.changeScreenListener());
  }

  Future<void> openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'gif', 'svg'],
        withData: true,
    );

    if (result != null) {
      Uint8List image = result.files.single.bytes!;
      listOfImages.addImage(image);
    }
  }

  Future<Uint8List> imageUrlToImage(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  void loadImages(List<String> imageUrls) async {
    for(String imageUrl in imageUrls) {
      Uint8List image = await imageUrlToImage(imageUrl);
      listOfImages.addImage(image);
    }
  }

  @override
  void initState() {
    super.initState();
    listOfImages = ImageList();
    listOfFeatures = [];
    listOfYoutubeUrls = [];
    listOfCriteria = [];
    fields = [];

    // Isi form field jika ada data
    // TODO: Ini untuk ubah pindahkan data dari detail ke tampilan
    if (widget.house.modelID.isNotEmpty) {
      House house = widget.house;
      headerText = "Detail Model Rumah ${house.name}";
      nameController.text = house.name;
      typeController.text = house.buildingType.toString();
      priceController.text = house.price.toString();
      dpController.text = house.downPayment.toString();
      houseAreaController.text = house.houseDimensions.toString();
      landAreaController.text = house.landDimensions.toString();
      descriptionController.text = house.description;
      loadImages(house.imageUrls);
      for(String feature in house.features) {
        listOfFeatures.add(TextEditingController(text: feature));
      }
      for(String videoUrl in house.youtubeUrls) {
        listOfYoutubeUrls.add(TextEditingController(text: videoUrl));
      }
      for(String videoUrl in house.criteria) {
        listOfCriteria.add(TextEditingController(text: videoUrl));
      }
    }

    // Tambah elemen form
    // TODO: Ini untuk ubah kolom pada detail rumah
    fields.add(HouseAddItemTextDetail(label: "Nama", hintText: "Nama model rumah", textEditingController: nameController),);
    fields.add(const SizedBox());
    fields.add(HouseAddItemTextDetail(label: "Tipe Bangunan", hintText: "Kode tipe banguan", textEditingController: typeController),);
    fields.add(HouseAddItemLongTextDetail(label: "Deskripsi Model Rumah", hintText: "Maksimal 200 huruf", textEditingController: descriptionController),);
    fields.add(HouseAddItemNumberDetail(label: "Harga Jual Rumah", hintText: "Harga (rupiah)", textEditingController: priceController),);
    fields.add(HouseAddItemNumberDetail(label: "Down Payment", hintText: "DP (rupiah)", textEditingController: dpController),);
    fields.add(HouseAddItemNumberDetail(label: "Luas Rumah", hintText: "Luas (meter persegi)", textEditingController: houseAreaController),);
    fields.add(HouseAddItemNumberDetail(label: "Luas Tanah", hintText: "Luas (meter persegi)", textEditingController: landAreaController),);
    fields.add(HouseAddItemTextListDetail(
      label: "Daftar fitur istimewa",
      hintText: "Fitur",
      appendText: () {listOfFeatures.add(TextEditingController());},
      deleteText: (index) {listOfFeatures.removeAt(index);},
      listOfString: listOfFeatures,
    ));
    fields.add(HouseAddItemTextListDetail(
      label: "Link video Youtube",
      hintText: "Video",
      appendText: () {listOfYoutubeUrls.add(TextEditingController());},
      deleteText: (index) {listOfYoutubeUrls.removeAt(index);},
      listOfString: listOfYoutubeUrls,
    ));

    fields.add(HouseAddItemTextListDetail(
      label: "List keterangan pembelian rumah",
      hintText: "Keterangan",
      appendText: () {listOfCriteria.add(TextEditingController());},
      deleteText: (index) {listOfCriteria.removeAt(index);},
      listOfString: listOfCriteria,
    ));
    fields.add(HouseAddItemImageDetail(
      uploadFile: openFile,
      deleteFile: (index) {listOfImages.deleteImage(index);},
      listOfImages: listOfImages,
    ));

    fields.add(const SizedBox());
    // Tambah tombol add atau edit
    if (widget.house.modelID.isNotEmpty) {
      fields.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          HouseSubmitButton(text: "Ubah", onPressed: reuploadHouseDetail),
          HouseSubmitButton(text: "Hapus", onPressed: deleteHouseDetail),
        ],
      ));
    } else {
      fields.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          HouseSubmitButton(text: "Tambah", onPressed: uploadHouseDetail),
        ],
      ));
    }
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

class HouseSubmitButton extends StatefulWidget {
  const HouseSubmitButton({super.key, required this.text, required this.onPressed});
  final String text;
  final AsyncCallback onPressed;

  @override
  State<HouseSubmitButton> createState() => _HouseSubmitButtonState();
}

class _HouseSubmitButtonState extends State<HouseSubmitButton> {
  bool hasClicked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 120,
      child: FittedBox(
        child: FloatingActionButton.extended(
          backgroundColor: hasClicked ? Colors.blueGrey.shade50 : null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          extendedPadding: const EdgeInsets.symmetric(horizontal: 32.0),
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          extendedTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
          label: hasClicked ? Text("${widget.text}?",) : Text(widget.text,),
          onPressed: () {
            if(hasClicked) {
              widget.onPressed();
            } else {
              setState(() {
                hasClicked = true;
              });
            }
          },
        ),
      ),
    );
  }
}

class HouseAddItemCheckboxDetail extends StatefulWidget {
  const HouseAddItemCheckboxDetail({super.key, required this.label, required this.value, required this.onChanged});
  final String label;
  final bool value;
  final VoidCallback onChanged;

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
  const HouseTextField({super.key, required this.hintText, required this.textEditingController, this.type = TextInputType.text});
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: type,
      inputFormatters: [
        if(type == TextInputType.number) FilteringTextInputFormatter.allow(RegExp(r"[\.\,0-9]*")),
      ],
      maxLines: type == TextInputType.multiline ? null : 1,
      style: const TextStyle(
        height: 1.2,
      ),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
          border: const OutlineInputBorder(
              borderSide: BorderSide()
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 13,
          ),
      ),
      controller: textEditingController,
    );
  }
}

class HouseAddItemDimensionDetail extends StatelessWidget {
  const HouseAddItemDimensionDetail({super.key,
    required this.label,
    required this.lengthController,
    required this.widthController,
    required this.hintText
  });
  final String label;
  final TextEditingController lengthController;
  final TextEditingController widthController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: HouseAddItemTextDetail(label: "Panjang $label", hintText: "Panjang $hintText", textEditingController: lengthController)),
        const SizedBox(width: 16.0,),
        Expanded(child: HouseAddItemTextDetail(label: "Lebar $label", hintText: "Lebar $hintText", textEditingController: widthController)),
      ],
    );
  }
}

class HouseAddItemNumberDetail extends StatelessWidget {
  const HouseAddItemNumberDetail({super.key, required this.label, required this.hintText, required this.textEditingController});
  final String label;
  final String hintText;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:"),
        const SizedBox(height: 8.0,),
        HouseTextField(
          hintText: hintText,
          textEditingController: textEditingController,
          type: TextInputType.number
        ),
      ],
    );
  }
}


class HouseAddItemTextDetail extends StatelessWidget {
  const HouseAddItemTextDetail({super.key, required this.label, required this.hintText, required this.textEditingController});
  final String label;
  final String hintText;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:"),
        const SizedBox(height: 8.0,),
        HouseTextField(
          hintText: hintText,
          textEditingController: textEditingController,
          type: TextInputType.text
        ),
      ],
    );
  }
}

class HouseAddItemLongTextDetail extends StatelessWidget {
  const HouseAddItemLongTextDetail({super.key, required this.label, required this.hintText, required this.textEditingController});
  final String label;
  final String hintText;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:"),
        const SizedBox(height: 8.0,),
        HouseTextField(
          hintText: hintText,
          textEditingController: textEditingController,
          type: TextInputType.multiline
        ),
      ],
    );
  }
}


class HouseAddItemImageDetail extends StatefulWidget {
  const HouseAddItemImageDetail({super.key, required this.uploadFile, required this.deleteFile, required this.listOfImages});
  final AsyncCallback uploadFile;
  final Function(int) deleteFile;
  final ImageList listOfImages;

  @override
  State<HouseAddItemImageDetail> createState() => _HouseAddItemImageDetailState();
}

class _HouseAddItemImageDetailState extends State<HouseAddItemImageDetail> {
  late ImageList listOfImages;
  bool isHovered = false;

  @override
  initState() {
    super.initState();
    listOfImages = widget.listOfImages;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    const Text("List gambar rumah, denah, atau tabel angsuran:"),
    const SizedBox(height: 8.0,),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1), borderRadius: const BorderRadius.all(Radius.circular(4.0))),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListenableBuilder(
                    listenable: listOfImages,
                    builder: (BuildContext context, Widget? child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listOfImages.imageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return HouseAddItemImageListItemDetail(
                            index: index,
                            image: listOfImages.imageList[index],
                            deleteFile: () {
                              widget.deleteFile(index);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey, width: 1), borderRadius: const BorderRadius.all(Radius.circular(4.0))),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              await widget.uploadFile();
                            },
                            child: const Text(
                              "Upload Gambar",
                              style: TextStyle(color: Colors.blueGrey,),
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
        ),
      ],
    );
  }
}

class ImageList with ChangeNotifier {
  final List<Uint8List> imageList = [];

  void addImage(Uint8List image) {
    imageList.add(image);
    notifyListeners();
  }

  void deleteImage(int index) {
    imageList.removeAt(index);
    notifyListeners();
  }
}

class HouseAddItemImageListItemDetail extends StatefulWidget {
  const HouseAddItemImageListItemDetail({super.key, required this.index, required this.image, required this.deleteFile});
  final int index;
  final Uint8List image;
  final VoidCallback deleteFile;

  @override
  State<HouseAddItemImageListItemDetail> createState() => _HouseAddItemImageListItemDetailState();
}

class _HouseAddItemImageListItemDetailState extends State<HouseAddItemImageListItemDetail> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.deleteFile,
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
                      color: isHovered ? Colors.red : Colors.blueGrey,
                      width: 1
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0))),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.memory(widget.image),
              ),
            ),
          ),
          if (isHovered) const Padding(
            padding: EdgeInsets.all(2.0),
            child: Icon(Icons.cancel_outlined, size: 24, color: Colors.red,),
          ),
        ],
      ),
    );
  }
}


class HouseAddItemTextListDetail extends StatefulWidget {
  const HouseAddItemTextListDetail({super.key, required this.label, required this.hintText, required this.appendText, required this.deleteText, required this.listOfString});
  final String label;
  final String hintText;
  final VoidCallback appendText;
  final Function(int) deleteText;
  final List<TextEditingController> listOfString;

  @override
  State<HouseAddItemTextListDetail> createState() => _HouseAddItemTextListDetailState();
}

class _HouseAddItemTextListDetailState extends State<HouseAddItemTextListDetail> {
  late List<TextEditingController> listOfString;
  bool isHovered = false;

  @override
  initState() {
    super.initState();
    listOfString = widget.listOfString;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${widget.label}:"),
        const SizedBox(height: 8.0,),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1), borderRadius: const BorderRadius.all(Radius.circular(4.0))),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listOfString.length,
                    itemBuilder: (BuildContext context, int index) {
                      return HouseAddItemTextListItemDetail(
                        index: index,
                        hintText: "${widget.hintText} ${index+1}",
                        textEditingController: listOfString[index],
                        deleteText: () {
                          widget.deleteText(index);
                          setState(() {
                            listOfString;
                          });
                        },
                      );
                    },
                  ),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey, width: 1), borderRadius: const BorderRadius.all(Radius.circular(4.0))),
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
                              "Tambah ${widget.hintText}",
                              style: const TextStyle(color: Colors.blueGrey,),
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
        ),
      ],
    );
  }
}

class HouseAddItemTextListItemDetail extends StatefulWidget {
  const HouseAddItemTextListItemDetail({super.key, required this.index, required this.hintText, required this.textEditingController, required this.deleteText});
  final int index;
  final String hintText;
  final TextEditingController textEditingController;
  final VoidCallback deleteText;

  @override
  State<HouseAddItemTextListItemDetail> createState() => _HouseAddItemTextListItemDetailState();
}

class _HouseAddItemTextListItemDetailState extends State<HouseAddItemTextListItemDetail> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: widget.deleteText,
          onHover: (b) {
            setState(() {
              isHovered = b;
            });
          },
          child: const SizedBox(
            width: 40,
            child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(Icons.cancel_outlined, size: 24, color: Colors.red,),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: isHovered ? Colors.red : Colors.blueGrey,
                      width: 1
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0))),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: HouseTextField(
                  textEditingController: widget.textEditingController, hintText: widget.hintText,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
