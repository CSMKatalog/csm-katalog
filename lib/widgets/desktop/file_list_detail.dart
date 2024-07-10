import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../firebase/firestorage_connector.dart';
import '../../utils/file_list.dart';

class FileListDetail extends StatefulWidget {
  const FileListDetail({super.key, required this.label, required this.listOfUrls, required this.fileAddListener, required this.fileDeleteListener});
  final String label;
  final List<dynamic> listOfUrls;
  final void Function(String) fileAddListener;
  final void Function(int) fileDeleteListener;

  @override
  State<FileListDetail> createState() => _FileListDetailState();
}

class _FileListDetailState extends State<FileListDetail> {
  late List<dynamic> listOfUrls;

  Future<void> openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );

    if (result != null) {
      Uint8List image = result.files.single.bytes!;
      String fileName = "file-${DateTime.now()}";
      String imageUrl = await FirestorageConnector.uploadFile(image, fileName, "documents/");
      widget.fileAddListener(imageUrl);
      setState(() {
        widget.listOfUrls.add(imageUrl);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listOfUrls = widget.listOfUrls;
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
                    itemCount: listOfUrls.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FileListDetailItem(
                        index: index,
                        url: listOfUrls[index],
                        deleteFile: () {
                          widget.fileDeleteListener(index);
                          setState(() {
                            listOfUrls.removeAt(index);
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
                            onTap: openFile,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                "Upload Dokumen",
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

  Future<void> deleteDocument() async {
    FirestorageConnector.deleteFile(Uri.parse(widget.url).pathSegments.last);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        deleteDocument();
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
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(Uri.parse(widget.url).pathSegments.last),
                ),
                onTap: () {
                  final Uri url = Uri.parse(widget.url);
                  launchUrl(url);
                },
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