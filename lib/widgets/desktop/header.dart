import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}


class PageHeader extends StatefulWidget {
  const PageHeader({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
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