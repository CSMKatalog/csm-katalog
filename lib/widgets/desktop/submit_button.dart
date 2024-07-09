import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton({super.key, required this.text, required this.onPressed});
  final String text;
  final AsyncCallback onPressed;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool hasClicked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 120,
      child: FittedBox(
        child: FloatingActionButton.extended(
          backgroundColor: hasClicked ? Colors.blueGrey.shade50 : null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          extendedPadding: const EdgeInsets.symmetric(horizontal: 32.0),
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          extendedTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
          label: hasClicked ? Text("${widget.text}?",) : Text(widget.text,),
          onPressed: () {
            if(hasClicked) {
              widget.onPressed();
            } else {
              setState(() {
                hasClicked = true;
              });
            }
          },
        ),
      ),
    );
  }
}