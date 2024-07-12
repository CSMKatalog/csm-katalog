import 'package:flutter/material.dart';

class LoadScreen extends StatelessWidget {
  const LoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Loading..."),
    );
  }
}


class ProgressTrack extends StatelessWidget {
  const ProgressTrack({super.key, required this.items});
  final List<ProgressTrackItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: 30,
            color: Colors.blueGrey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for(ProgressTrackItem item in items) item
            ],
          ),
        ]
      ),
    );
  }
}

class ProgressTrackItem extends StatefulWidget {
  const ProgressTrackItem({super.key, required this.icon, required this.label, required this.changeScreenListener,});
  final IconData icon;
  final String label;
  final VoidCallback changeScreenListener;

  @override
  State<ProgressTrackItem> createState() => _ProgressTrackItemState();
}

class _ProgressTrackItemState extends State<ProgressTrackItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (e) {
        setState(() {
          isHovered = e;
        });
      },
      onTap: widget.changeScreenListener,
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width/15,
              child: Text("")
          ),
          Container(
            height: MediaQuery.of(context).size.width/12,
            width: MediaQuery.of(context).size.width/12,
            child: Icon(
              widget.icon,
              size: 60,
              color: isHovered ? Colors.white : Colors.blueGrey,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.blueGrey, width: 5),
              color: isHovered ? Colors.blueGrey : Colors.white
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width/15,
            child: Text(widget.label, textAlign: TextAlign.center,)
          ),
        ],
      ),
    );
  }
}
