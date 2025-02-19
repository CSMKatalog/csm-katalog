
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestorageConnector {
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static Future<String> uploadFile(Uint8List rawFile, String fileName, String folder) async {
    // Create the file metadata
    final mime = lookupMimeType("", headerBytes: rawFile)!;
    final metadata = SettableMetadata(contentType: extensionFromMime(mime));
    final localUrl = "$folder$fileName.${mime.toString().replaceFirst(RegExp(r'\w+\/'), "")}";

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
    final ref = storage.ref().child(imageUrl);
    await ref.delete();
  }
}