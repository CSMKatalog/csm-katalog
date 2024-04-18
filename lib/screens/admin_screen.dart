import 'house_list.dart';
import 'package:flutter/material.dart';
import 'house_add.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  var dashboardScreens = [
    DashboardScreen(label: "Daftar Item", icon: Icon(Icons.abc_outlined), widget: HouseList()),
    DashboardScreen(label: "Tambah Item", icon: Icon(Icons.abc_outlined), widget: HouseAdd()),
    DashboardScreen(label: "Download Katalog", icon: Icon(Icons.abc_outlined), widget: HouseList()),
  ];
  late Widget selectedScreen = dashboardScreens[0].widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: selectedScreen,
          ),
        ],
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
            width: MediaQuery.of(context).size.width/4,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/6,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("images/logo_csm.png"),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("PT. CSM"),
                          Text("Catalog Creator"),
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
                          padding: EdgeInsets.all(4.0),
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


