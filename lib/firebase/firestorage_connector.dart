import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestorageConnector {
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static Future<String> uploadFile(Uint8List rawFile, String fileName, bool image) async {
    // Create the file metadata
    final mime = lookupMimeType("", headerBytes: rawFile)!;
    final metadata = SettableMetadata(contentType: extensionFromMime(mime));
    final folder = image ? "images/" : "documents/";
    final localUrl = "$folder$fileName.${mime.toString().replaceFirst(folder, "")}";

    // Upload file and metadata to the path 'images/mountains.jpg'
    await storage.ref()
        .child(localUrl)
        .putData(rawFile, metadata);

    final uploadedUrl = await storage.ref()
        .child(localUrl)
        .getDownloadURL();

    return uploadedUrl;
  }

  static Future<void> deleteFile(String imageUrl) async {
    // Create a reference to the file to delete
    final desertRef = storage.ref().child(imageUrl);

    // Delete the file
    await desertRef.delete();
  }
}