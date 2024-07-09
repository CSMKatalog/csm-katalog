import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/image_list.dart';

class ImageListDetail extends StatelessWidget {
  const ImageListDetail({super.key, required this.uploadFile, required this.deleteFile, required this.listOfImages});
  final AsyncCallback uploadFile;
  final Function(int) deleteFile;
  final ImageList listOfImages;

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
                          return ImageListDetailItem(
                            index: index,
                            image: listOfImages.imageList[index],
                            deleteFile: () {
                              deleteFile(index);
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
                              await uploadFile();
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

class ImageListDetailItem extends StatefulWidget {
  const ImageListDetailItem({super.key, required this.index, required this.image, required this.deleteFile});
  final int index;
  final Uint8List image;
  final VoidCallback deleteFile;

  @override
  State<ImageListDetailItem> createState() => _ImageListDetailItemState();
}

class _ImageListDetailItemState extends State<ImageListDetailItem> {
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