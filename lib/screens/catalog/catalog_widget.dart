import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatalogWidget extends StatelessWidget {
  const CatalogWidget({super.key, required this.icon, required this.openWidgetListener});
  final IconData icon;
  final VoidCallback openWidgetListener;

  @override
  Widget build(BuildContext context) {
    var sizeCoef = MediaQuery.of(context).size.width/11;
    sizeCoef = sizeCoef > 60 ? 60 : sizeCoef;

    return InkWell(
      onTap: openWidgetListener,
      child: Container(
        height: sizeCoef,
        width: sizeCoef,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
            color: Colors.blue
        ),
        child: Icon(icon, size: sizeCoef/2, color: Colors.white,),
      ),
    );
  }
}

class CatalogOverlayBackground extends StatelessWidget {
  const CatalogOverlayBackground({super.key, required this.children, required this.label, required this.closeWidgetListener});
  final List<Widget> children;
  final String label;
  final VoidCallback closeWidgetListener;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color.fromARGB(200, 40, 40, 60),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: closeWidgetListener,
                      child: Icon(Icons.cancel_outlined, color: Colors.blueGrey,),
                    ),
                    Expanded(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              for(Widget child in children) child
            ],
          ),
        ),
      ),
    );
  }
}
