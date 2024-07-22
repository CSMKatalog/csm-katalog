import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'package:csmkatalog/firebase/firestorage_connector.dart';

class FileListDetail extends StatefulWidget {
  const FileListDetail({super.key, required this.label, required this.listOfUrls,
    required this.onSubmit, required this.fileAddListener, required this.fileDeleteListener});
  final String label;
  final List<dynamic> listOfUrls;
  final AsyncCallback onSubmit;
  final void Function(String) fileAddListener;
  final void Function(int) fileDeleteListener;

  @override
  State<FileListDetail> createState() => _FileListDetailState();
}

class _FileListDetailState extends State<FileListDetail> {
  Future<void> openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'gif', 'svg'],
      withData: true,
    );

    if (result != null) {
      Uint8List image = result.files.single.bytes!;
      String fileName = "file-${DateTime.now()}";
      String imageUrl = await FirestorageConnector.uploadFile(image, fileName, "documents/");
      widget.fileAddListener(imageUrl);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 8.0,),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black45, width: widget.listOfUrls.isEmpty ? 3 : 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.listOfUrls.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FileListDetailItem(
                        index: index,
                        url: widget.listOfUrls[index],
                        deleteFile: () {
                          widget.fileDeleteListener(index);
                          widget.onSubmit();
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
                              await openFile();
                              widget.onSubmit();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                "Upload Foto Dokumen",
                                style: TextStyle(color: Colors.blueGrey,),
                                textAlign: TextAlign.center,
                              ),
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

class FileListDetailItem extends StatefulWidget {
  const FileListDetailItem({super.key, required this.index, required this.url, required this.deleteFile});
  final int index;
  final String url;
  final VoidCallback deleteFile;

  @override
  State<FileListDetailItem> createState() => _FileListDetailItemState();
}

class _FileListDetailItemState extends State<FileListDetailItem> {
  bool isHovered = false;
  Uint8List? image;

  Future<void> deleteDocument() async {
    String uri = Uri.parse(widget.url).pathSegments.last;
    FirestorageConnector.deleteFile(uri);
  }

  Future<void> downloadDocument() async {
    launchUrl(Uri.parse(widget.url));
  }

  Future<void> loadImage(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    setState(() {
      image = response.bodyBytes;
    }); 
  }

  @override
  void initState() {
    super.initState();
    loadImage(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await deleteDocument();
        widget.deleteFile();
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
                      color: isHovered ? Colors.red : Colors.blueGrey,
                      width: 1
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0))),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: image != null ? Image.memory(image!) : Text("Loading...")
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