import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hintText = "",
    required this.textEditingController,
    this.type = TextInputType.text,
    this.readOnly = false,
    this.limit = -1,
  });
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType type;
  final bool readOnly;
  final int limit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: type == TextInputType.number ? TextAlign.end : TextAlign.start,
      readOnly: readOnly,
      keyboardType: type,
      inputFormatters: [
        if(type == TextInputType.number) FilteringTextInputFormatter.allow(RegExp(r"[\.\,0-9]*")),
        if(limit != -1) LengthLimitingTextInputFormatter(limit),
      ],
      maxLines: type == TextInputType.multiline ? null : 1,
      style: const TextStyle(
        height: 1.0,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        border: const OutlineInputBorder(
            borderSide: BorderSide()
        ),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 13),
        hintTextDirection: type == TextInputType.number ? TextDirection.rtl : TextDirection.ltr,
      ),
      controller: textEditingController,
    );
  }
}

class TextDetail extends StatelessWidget {
  const TextDetail({super.key, required this.label, this.hintText = "", this.prefix, this.suffix, required this.textController, this.numberInput = false, this.readOnly = false});
  final String label;
  final String hintText;
  final String? prefix;
  final String? suffix;
  final TextEditingController textController;
  final bool numberInput;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 18
                      ),
                    )
                  ),
                  if(prefix != null) Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        prefix!,
                        style: TextStyle(
                            fontSize: 20
                        ),
                      )
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: hintText,
                      textEditingController: textController,
                      type: (numberInput != null && numberInput != false) ? TextInputType.number : TextInputType.text,
                      readOnly: readOnly != null ? readOnly! : false,
                      limit: 50,
                    ),
                  ),
                  if(suffix != null) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      suffix!,
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
