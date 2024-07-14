import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key,
    required this.hintText,
    required this.textEditingController,
    this.type = TextInputType.text,
    this.readOnly = false,
    this.limit = -1});
  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType type;
  final bool readOnly;
  final int limit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      keyboardType: type,
      inputFormatters: [
        if(type == TextInputType.number) FilteringTextInputFormatter.allow(RegExp(r"[\.\,0-9]*")),
        if(limit != -1) LengthLimitingTextInputFormatter(limit),
      ],
      maxLines: type == TextInputType.multiline ? null : 1,
      style: const TextStyle(
        height: 1.2,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
        border: const OutlineInputBorder(
            borderSide: BorderSide()
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 13,
        ),
      ),
      controller: textEditingController,
    );
  }
}

class DimensionDetail extends StatelessWidget {
  const DimensionDetail({super.key,
    required this.label,
    required this.lengthController,
    required this.widthController,
    required this.hintText,
    this.readOnly = false,
  });
  final String label;
  final TextEditingController lengthController;
  final TextEditingController widthController;
  final String hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: NumberDetail(
          label: "Panjang $label",
          hintText: "Panjang $hintText",
          textEditingController: lengthController,
          readOnly: readOnly,
        )),
        const SizedBox(width: 16.0,),
        Expanded(child: NumberDetail(
            label: "Lebar $label",
            hintText: "Lebar $hintText",
            textEditingController: widthController,
        )),
      ],
    );
  }
}

class NumberDetail extends StatelessWidget {
  const NumberDetail({super.key,
    required this.label,
    required this.hintText,
    required this.textEditingController,
    this.readOnly = false});
  final String label;
  final String hintText;
  final TextEditingController textEditingController;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:"),
        const SizedBox(height: 8.0,),
        CustomTextField(
          hintText: hintText,
          textEditingController: textEditingController,
          type: TextInputType.number,
          readOnly: readOnly,
          limit: 20,
        ),
      ],
    );
  }
}


class TextDetail extends StatelessWidget {
  const TextDetail({super.key,
    required this.label,
    required this.hintText,
    required this.textEditingController,
    this.readOnly = false
  });
  final String label;
  final String hintText;
  final TextEditingController textEditingController;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:"),
        const SizedBox(height: 8.0,),
        CustomTextField(
          hintText: hintText,
          textEditingController: textEditingController,
          type: TextInputType.text,
          readOnly: readOnly,
          limit: 50,
        ),
      ],
    );
  }
}

class LongTextDetail extends StatelessWidget {
  const LongTextDetail({super.key,
    required this.label,
    required this.hintText,
    required this.textEditingController,
    this.readOnly = false});
  final String label;
  final String hintText;
  final TextEditingController textEditingController;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:"),
        const SizedBox(height: 8.0,),
        CustomTextField(
          hintText: hintText,
          textEditingController: textEditingController,
          type: TextInputType.multiline,
          readOnly: readOnly,
        ),
      ],
    );
  }
}