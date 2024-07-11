import 'package:csmkatalog/screens/admin/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:csmkatalog/firebase/firestore_connector.dart';
import 'package:csmkatalog/models/house.dart';
import 'package:csmkatalog/models/client.dart';
import 'package:csmkatalog/utils/dashboard_screen.dart';
import 'package:csmkatalog/widgets/desktop/sidebar.dart';
import 'package:csmkatalog/screens/admin/house_cover.dart';
import 'package:csmkatalog/screens/admin/house_list.dart';
import 'package:csmkatalog/screens/admin/house_add.dart';
import 'package:csmkatalog/screens/sales/sales_list.dart';
import 'package:csmkatalog/screens/sales/sales_add.dart';

import '../sales/sales_progress.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  void missingValueToast() {

  }

  Widget? toastOverlay;

  Widget getHouseAdd() {
    return HouseAdd(
        house: House.empty(),
        changeScreenListener: () {
          setState(() { selectedScreen = getHouseList(); });
        }
    );
  }

  Widget getHouseEdit(House house) {
    return HouseAdd(
        house: house,
        changeScreenListener: () {
          setState(() {
            selectedScreen = getHouseList();
          });
        }
    );
  }

  Widget getHouseList() {
    return HouseList(changeScreenListener: (House house) {
      setState(() {
        selectedScreen = getHouseEdit(house);
      });
    });
  }

  Widget getCover() {
    return HouseCover();
  }

  Widget getClientAdd() {
    return SalesAdd(
        client: Client.empty(),
        changeScreenListener: () {
          setState(() { selectedScreen = getClientList(); });
        },
        progressScreenListener: () {
          setState(() { selectedScreen = getClientProgress(Client.empty()); });
        },
    );
  }

  Widget getClientEdit(Client client) {
    return SalesAdd(
      client: client,
      changeScreenListener: () {
        setState(() { selectedScreen = getClientList(); });
      },
      progressScreenListener: () {
        setState(() { selectedScreen = getClientProgress(client); });
      },
    );
  }

  Widget getClientProgress(Client client) {
    return SalesProgress(client: client, changeScreenListener: () {
      setState(() {
        selectedScreen = getClientList();
      });
    });
  }

  Widget getClientList() {
    return SalesList(
      changeScreenListener: (Client client) {setState(() {selectedScreen = getClientEdit(client);});},
    );
  }

  Widget getChangeSettings() {
    return ChangeSettings(
      changeScreenListener: () {
        setState(() { selectedScreen = getHouseList(); });
      },
    );
  }

  _AdminScreenState () {
    dashboardScreens = [
      Screen(label: "Daftar Item", icon: Icons.abc_outlined, widgetFunction: getHouseList),
      Screen(label: "Tambah Item", icon: Icons.abc_outlined, widgetFunction: getHouseAdd),
      Screen(label: "Halaman Depan", icon: Icons.abc_outlined, widgetFunction: getCover),
      // DashboardScreen(label: "", icon: const Icon(Icons.abc_outlined), widget: SizedBox(height: 10,)),
      Screen(label: "Daftar Klien", icon: Icons.abc_outlined, widgetFunction: getClientList),
      Screen(label: "Tambah Klien", icon: Icons.abc_outlined, widgetFunction: getClientAdd),
      Screen(label: "Pengaturan", icon: Icons.abc_outlined, widgetFunction: getChangeSettings),
    ];
    selectedScreen = dashboardScreens[0].widgetFunction();
  }
  late List<Screen> dashboardScreens;
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
                applicationName: "Penyusun Katalog",
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

