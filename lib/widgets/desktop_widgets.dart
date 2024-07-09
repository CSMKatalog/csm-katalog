import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Bottombar extends StatelessWidget {
  const Bottombar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.applicationName, required this.dashboardScreens, required this.changeScreenListener});
  final String applicationName;
  final Function(Widget) changeScreenListener;
  final List<DashboardScreen> dashboardScreens;
  final int selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          border: BorderDirectional(
              end: BorderSide(
                  color: Colors.blueGrey,
                  width: 3
              )
          )
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 6.0),
        child: DecoratedBox(
          decoration: const BoxDecoration(
              border: BorderDirectional(
                  end: BorderSide(
                      color: Colors.blueGrey,
                      width: 1
                  )
              )
          ),
          child: SizedBox(
            width: (MediaQuery.of(context).size.width > 720) ? (MediaQuery.of(context).size.width/4) : (180),
            height: MediaQuery.of(context).size.height,
            child: Container(
              color: Colors.blueGrey[300],
              child: Column(
                children: [
                  const SizedBox(height: 8,),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/6,
                    child: Container(
                      color: Colors.blueGrey,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MediaQuery.of(context).size.width > 1000 ? Image.asset("images/logo_csm.png") : const SizedBox(),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("PT. CSM",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(applicationName),
                              ]
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(height: 1, child: Container(
                    color: Colors.blueGrey,
                  ),),
                  const SizedBox(height: 16),
                  for (var screen in dashboardScreens)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        hoverColor: Colors.blueGrey,
                        onTap: () => changeScreenListener(screen.widget),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 2.0, top: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey, width: 2)
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(screen.label,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blueGrey[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen {
  String label;
  Icon icon;
  Widget widget;

  DashboardScreen({required this.label, required this.icon, required this.widget});
}

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