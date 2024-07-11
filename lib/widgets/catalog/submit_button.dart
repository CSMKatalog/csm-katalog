import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.text, required this.onPressed});
  final String text;
  final AsyncCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 120,
      child: FittedBox(
        child: FloatingActionButton.extended(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          extendedPadding: const EdgeInsets.symmetric(horizontal: 32.0),
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          extendedTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
          label: Text(text,),
          onPressed: () {
            onPressed();
          },
        ),
      ),
    );
  }
}