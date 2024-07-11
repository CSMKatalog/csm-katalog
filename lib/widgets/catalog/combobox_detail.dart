import 'package:flutter/cupertino.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("${widget.label}:",
            style: TextStyle(
                fontSize: 18
            ),
          ),
          const SizedBox(width: 30.0,),
          Expanded(
            child: DropdownButton(
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
          ),
        ],
      ),
    );
  }
}