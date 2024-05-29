import '../models/house.dart';
import 'house_cover.dart';
import 'house_list.dart';
import 'package:flutter/material.dart';
import 'house_add.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  getHouseAdd({House? house}) {
    return HouseAdd(
        house: house ?? House.empty(),
        changeScreenListener: () {
          setState(() {
            selectedScreen = getHouseList();
          });
        }
    );
  }

  getHouseList() {
    return HouseList(changeScreenListener: (House house) {
      setState(() {
        selectedScreen = getHouseAdd(house: house);
      });
    });
  }

  getCover() {
    return HouseCover();
  }

  _AdminScreenState () {
    dashboardScreens = [
      DashboardScreen(label: "Daftar Item", icon: const Icon(Icons.abc_outlined), widget: getHouseList()),
      DashboardScreen(label: "Tambah Item", icon: const Icon(Icons.abc_outlined), widget: getHouseAdd()),
      DashboardScreen(label: "Halaman Depan", icon: const Icon(Icons.abc_outlined), widget: getCover()),
    ];
    selectedScreen = dashboardScreens[0].widget;
  }
  late List<DashboardScreen> dashboardScreens;
  late Widget selectedScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent)
        ),
        child: SizedBox(
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
   const Sidebar({super.key, required this.dashboardScreens, required this.changeScreenListener});
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
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("PT. CSM",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                    color: Colors.black,
                                  ),
                                ),
                              Text("Penyusun Katalog"),
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

class HeaderAdminScreen extends StatelessWidget {
  const HeaderAdminScreen({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: const TextStyle(
          fontSize: 23,
        ),
    );
  }
}



