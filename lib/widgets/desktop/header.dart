import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: Container(
            color: isHovered ? Colors.red : Colors.blueGrey,
            child: Icon(
                Icons.arrow_back,
                color: Colors.white),
          ),
          onTap: widget.onTap,
          onHover: (b){
            setState(() {
              isHovered = b;
            });
          },
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 23,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}