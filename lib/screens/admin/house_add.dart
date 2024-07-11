import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:file_picker/file_picker.dart';

import 'package:csmkatalog/firebase/firestorage_connector.dart';
import 'package:csmkatalog/firebase/firestore_connector.dart';
import 'package:csmkatalog/models/house.dart';
import 'package:csmkatalog/utils/file_list.dart';
import 'package:csmkatalog/widgets/desktop/header.dart';
import 'package:csmkatalog/widgets/desktop/image_list_detail.dart';
import 'package:csmkatalog/widgets/desktop/submit_button.dart';
import 'package:csmkatalog/widgets/desktop/text_detail.dart';
import 'package:csmkatalog/widgets/desktop/text_list_detail.dart';


// class HouseAdd extends StatefulWidget {
//   const HouseAdd({super.key, required this.house, required this.changeScreenListener, required this.missingValueToast, required this.moreThanPriceToast,
//     required this.successAddToast, required this.successCreateToast, required this.successDeleteToast});
//   final House house;
//   final VoidCallback changeScreenListener;
//   final VoidCallback missingValueToast;
//   final VoidCallback moreThanPriceToast;
//   final VoidCallback successAddToast;
//   final VoidCallback successCreateToast;
//   final VoidCallback successDeleteToast;
//
//   @override
//   State<HouseAdd> createState() => _HouseAddState();
// }

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
  late FileList listOfImages;
  late List<TextEditingController> listOfFeatures;
  late List<TextEditingController> listOfCriteria;
  late List<TextEditingController> listOfYoutubeUrls;
  String headerText = "Tambah Model Rumah Baru";

  Future<List<String>> uploadImageList() async {
    final List<String> imageUrls = [];
    for (Uint8List image in listOfImages.fileList) {
      String fileName = "image-${DateTime.now()}";
      String imageUrl = await FirestorageConnector.uploadFile(image, fileName, "images/");
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }

  // TODO: Ini untuk ubah data yang disimpan dan upload
  Future<bool> uploadHouseDetail() async {
    double houseArea = double.parse(houseAreaController.value.text.replaceAll(",", "."));
    double landArea = double.parse(landAreaController.value.text.replaceAll(",", "."));
    int price = int.parse(priceController.value.text.replaceAll(",", "").replaceAll(".", ""));
    int dp = int.parse(dpController.value.text.replaceAll(",", "").replaceAll(".", ""));

    if(price < dp) {
      // widget.missingValueToast();
      return false;
    }

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
    return true;
  }

  Future<void> reuploadHouseDetail() async {
    if (await uploadHouseDetail()) {
      //TODO: Add toast
      return;
    }
    for (var imageUrl in widget.house.imageUrls) {
      FirestorageConnector.deleteFile(Uri.parse(imageUrl).pathSegments.last);
    }
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
      listOfImages.addFile(image);
    }
  }

  Future<Uint8List> imageUrlToImage(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  void loadImages(List<String> imageUrls) async {
    for(String imageUrl in imageUrls) {
      Uint8List image = await imageUrlToImage(imageUrl);
      listOfImages.addFile(image);
    }
  }

  @override
  void initState() {
    super.initState();
    listOfImages = FileList();
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
    fields.add(TextDetail(label: "Nama", hintText: "Nama model rumah", textEditingController: nameController),);
    fields.add(const SizedBox());
    fields.add(TextDetail(label: "Tipe Bangunan", hintText: "Kode tipe banguan", textEditingController: typeController),);
    fields.add(LongTextDetail(label: "Deskripsi Model Rumah", hintText: "Maksimal 200 huruf", textEditingController: descriptionController),);
    fields.add(NumberDetail(label: "Harga Jual Rumah", hintText: "Harga (rupiah)", textEditingController: priceController),);
    fields.add(NumberDetail(label: "Down Payment", hintText: "DP (rupiah)", textEditingController: dpController),);
    fields.add(NumberDetail(label: "Luas Rumah", hintText: "Luas (meter persegi)", textEditingController: houseAreaController),);
    fields.add(NumberDetail(label: "Luas Tanah", hintText: "Luas (meter persegi)", textEditingController: landAreaController),);
    fields.add(TextListDetail(
      label: "Daftar fitur istimewa",
      hintText: "Fitur",
      appendText: () {listOfFeatures.add(TextEditingController());},
      deleteText: (index) {listOfFeatures.removeAt(index);},
      listOfString: listOfFeatures,
    ));
    fields.add(TextListDetail(
      label: "Link video Youtube",
      hintText: "Video",
      appendText: () {listOfYoutubeUrls.add(TextEditingController());},
      deleteText: (index) {listOfYoutubeUrls.removeAt(index);},
      listOfString: listOfYoutubeUrls,
    ));

    fields.add(TextListDetail(
      label: "List keterangan pembelian rumah",
      hintText: "Keterangan",
      appendText: () {listOfCriteria.add(TextEditingController());},
      deleteText: (index) {listOfCriteria.removeAt(index);},
      listOfString: listOfCriteria,
    ));
    fields.add(ImageListDetail(
      label: "List gambar rumah, denah, atau tabel angsuran:",
      uploadFile: openFile,
      deleteFile: (index) {listOfImages.deleteFile(index);},
      listOfImages: listOfImages,
    ));

    fields.add(const SizedBox());
    // Tambah tombol add atau edit
    if (widget.house.modelID.isNotEmpty) {
      fields.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SubmitButton(text: "Ubah", onPressed: reuploadHouseDetail),
          SubmitButton(text: "Hapus", onPressed: deleteHouseDetail),
        ],
      ));
    } else {
      fields.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SubmitButton(text: "Tambah", onPressed: uploadHouseDetail),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(text: headerText, onTap: widget.changeScreenListener,),
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










