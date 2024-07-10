import 'package:csmkatalog/widgets/desktop/text_detail.dart';
import 'package:flutter/material.dart';

class TextListDetail extends StatefulWidget {
  const TextListDetail({super.key, required this.label, required this.hintText, required this.appendText, required this.deleteText, required this.listOfString});
  final String label;
  final String hintText;
  final VoidCallback appendText;
  final Function(int) deleteText;
  final List<TextEditingController> listOfString;

  @override
  State<TextListDetail> createState() => _TextListDetailState();
}

class _TextListDetailState extends State<TextListDetail> {
  late List<TextEditingController> listOfString;

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
                      return TextListDetailItem(
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Tambah ${widget.hintText}",
                                style: const TextStyle(color: Colors.blueGrey,),
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

class TextListDetailItem extends StatefulWidget {
  const TextListDetailItem({super.key, required this.index, required this.hintText, required this.textEditingController, required this.deleteText});
  final int index;
  final String hintText;
  final TextEditingController textEditingController;
  final VoidCallback deleteText;

  @override
  State<TextListDetailItem> createState() => _TextListDetailItemState();
}

class _TextListDetailItemState extends State<TextListDetailItem> {
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
                child: CustomTextField(
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