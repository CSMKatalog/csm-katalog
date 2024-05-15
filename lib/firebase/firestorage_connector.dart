import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestorageConnector {
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static Future<String> uploadFile(Uint8List rawImage, String fileName) async {

    // Create the file metadata
    final mime = lookupMimeType("", headerBytes: rawImage)!;
    final metadata = SettableMetadata(contentType: extensionFromMime(mime));
    final localImageUrl = "images/$fileName.${mime.toString().replaceFirst("image/", "")}";

    // Upload file and metadata to the path 'images/mountains.jpg'
    await storage.ref()
        .child(localImageUrl)
        .putData(rawImage, metadata);

    final uploadedImageUrl = await storage.ref()
        .child(localImageUrl)
        .getDownloadURL();

    return uploadedImageUrl;
  }
}