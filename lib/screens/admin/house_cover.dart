import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:csmkatalog/firebase/firestore_connector.dart';
import 'package:csmkatalog/firebase/firestorage_connector.dart';
import 'package:csmkatalog/utils/file_list.dart';
import 'package:csmkatalog/widgets/desktop/image_list_detail.dart';
import 'package:csmkatalog/widgets/desktop/submit_button.dart';

class HouseCover extends StatefulWidget {
  const HouseCover({super.key});

  @override
  State<HouseCover> createState() => _HouseCoverState();
}

class _HouseCoverState extends State<HouseCover> {
  FileList listOfImages = FileList();
  List<String> imageUrls = [];

  Future<void> uploadImageList() async {
    for (var imageUrl in imageUrls) {
      FirestorageConnector.deleteFile(Uri.parse(imageUrl).pathSegments.last);
    }
    final List<String> newImageUrls = [];
    for (Uint8List image in listOfImages.fileList) {
      String fileName = "cover-${DateTime.now()}";
      String imageUrl = await FirestorageConnector.uploadFile(image, fileName, "images/");
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
      listOfImages.addFile(image);
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
      listOfImages.addFile(image);
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
              ImageListDetail(
                label: "List gambar untuk halaman depan katalog:",
                uploadFile: openFile,
                deleteFile: (index) {listOfImages.deleteFile(index);},
                listOfImages: listOfImages,
              ),
              SizedBox(height: 8,),
              SubmitButton(text: "Simpan", onPressed: uploadImageList)
            ],
          ),
        ),
      ),
    );
  }
}
