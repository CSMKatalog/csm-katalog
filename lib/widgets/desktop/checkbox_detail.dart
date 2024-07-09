import 'package:flutter/material.dart';

class CheckboxDetail extends StatefulWidget {
  const CheckboxDetail({super.key, required this.label, required this.value, required this.onChanged});
  final String label;
  final bool value;
  final VoidCallback onChanged;

  @override
  State<CheckboxDetail> createState() => _CheckboxDetailState();
}

class _CheckboxDetailState extends State<CheckboxDetail> {
  late bool checkValue;

  @override
  void initState() {
    super.initState();
    checkValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text("${widget.label}:"),
      value: checkValue,
      onChanged: (b) => {
        widget.onChanged(),
        setState(() {
          checkValue = !checkValue;
        }),
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }
}