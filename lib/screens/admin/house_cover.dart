import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:csmkatalog/screens/admin/house_add.dart';
import 'package:csmkatalog/firebase/firestore_connector.dart';
import 'package:csmkatalog/firebase/firestorage_connector.dart';

class HouseCover extends StatefulWidget {
  const HouseCover({super.key});

  @override
  State<HouseCover> createState() => _HouseCoverState();
}

class _HouseCoverState extends State<HouseCover> {
  ImageList listOfImages = ImageList();
  List<String> imageUrls = [];

  Future<void> uploadImageList() async {
    for (var imageUrl in imageUrls) {
      FirestorageConnector.deleteFile(Uri.parse(imageUrl).pathSegments.last);
    }
    final List<String> newImageUrls = [];
    for (Uint8List image in listOfImages.imageList) {
      String fileName = "cover-${DateTime.now()}";
      String imageUrl = await FirestorageConnector.uploadFile(image, fileName, true);
      newImageUrls.add(imageUrl);
    }
    await FirestoreConnector.updateCover("coverCSM", {"imageUrls": newImageUrls});
    loadImages();
  }

  Future<Uint8List> imageUrlToImage(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  void loadImages() async {
    var newImageUrls = await FirestoreConnector.readCover();
    for(String imageUrl in newImageUrls["imageUrls"]) {
      Uint8List image = await imageUrlToImage(imageUrl);
      listOfImages.addImage(image);
    }
    setState(() {
      imageUrls = newImageUrls["imageUrls"];
    });
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

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            children: [
              HouseAddItemImageDetail(
                uploadFile: openFile,
                deleteFile: (index) {listOfImages.deleteImage(index);},
                listOfImages: listOfImages,
              ),
              SizedBox(height: 8,),
              HouseSubmitButton(text: "Simpan", onPressed: uploadImageList)
            ],
          ),
        ),
      ),
    );
  }
}
