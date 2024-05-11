import '../models/house.dart';
import 'house_list.dart';
import 'package:flutter/material.dart';
import 'house_add.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  _AdminScreenState () {
    dashboardScreens = [
      DashboardScreen(label: "Daftar Item", icon: Icon(Icons.abc_outlined), widget: HouseList(changeScreenListener:
          (House house) {
        setState(() {
          selectedScreen = HouseAdd(house: house);
        });
      }
      )),
      DashboardScreen(label: "Tambah Item", icon: Icon(Icons.abc_outlined), widget: HouseAdd(house: House.empty(),)),
      DashboardScreen(label: "Download Katalog", icon: Icon(Icons.abc_outlined), widget: Placeholder()),
    ];
    selectedScreen = dashboardScreens[0].widget;
  }
  late List<DashboardScreen> dashboardScreens;
  late Widget selectedScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Sidebar(
              dashboardScreens: dashboardScreens,
              changeScreenListener: (widget) {
                setState(() {
                  selectedScreen = widget;
                });
              },
            ),
            // Main dashboard
            SizedBox(
              width: (MediaQuery.of(context).size.width > 720) ? (MediaQuery.of(context).size.width*2.95/4) : (MediaQuery.of(context).size.width-190),
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                child: selectedScreen,
              ),
            ),
          ],
        ),
      )
    );
  }
}

class Bottombar extends StatelessWidget {
  const Bottombar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class Sidebar extends StatelessWidget {
   Sidebar({super.key, required this.dashboardScreens, required this.changeScreenListener});
   final Function(Widget) changeScreenListener;
   final dashboardScreens;
   var selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: BorderDirectional(
          end: BorderSide(
            color: Colors.blueAccent,
            width: 3
          )
        )
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 6.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: BorderDirectional(
                  end: BorderSide(
                      color: Colors.blueAccent,
                      width: 1
                  )
              )
          ),
          child: SizedBox(
            width: (MediaQuery.of(context).size.width > 720) ? (MediaQuery.of(context).size.width/4) : (180),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/6,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MediaQuery.of(context).size.width > 1000 ? Image.asset("images/logo_csm.png") : SizedBox(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("PT. CSM",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                          Text("Penyusun Katalog"),
                        ]
                      )
                    ],
                  ),
                ),
                for (var screen in dashboardScreens)
                  GestureDetector(
                    onTap: () => changeScreenListener(screen.widget),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 16.0, right: 4.0),
                          child: Text(screen.label),
                        ),
                      ],
                    ),
                  )
              ],
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

class HeaderAdminScreen extends StatelessWidget {
  HeaderAdminScreen({super.key, required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: TextStyle(
          fontSize: 23,
        ),
    );
  }
}



