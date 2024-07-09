import 'package:flutter/material.dart';

class ComboBoxDetail extends StatefulWidget {
  const ComboBoxDetail({super.key, required this.label, required this.items, required this.value, required this.onChanged});
  final String label;
  final List<String> items;
  final String value;
  final void Function(String) onChanged;

  @override
  State<ComboBoxDetail> createState() => _ComboBoxDetailState();
}

class _ComboBoxDetailState extends State<ComboBoxDetail> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${widget.label}:"),
        const SizedBox(height: 8.0,),
        DropdownButton(
          isExpanded: true,
          items: widget.items.map((e) =>
              DropdownMenuItem<String>(value: e, child: Text(e),)).toList(),
          value: dropdownValue,
          onChanged: (e) {
            if (e == null) return;
            widget.onChanged(e);
            setState(() {
              dropdownValue = e;
            });
          }
        ),
      ],
    );
  }
}