import 'package:flutter/material.dart';

class Toast extends StatelessWidget {
  const Toast({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: Container(
        width: MediaQuery.of(context).size.width/2,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blueGrey[50],
        ),
        alignment: AlignmentDirectional.center,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
