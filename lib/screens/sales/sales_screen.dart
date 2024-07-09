import 'package:csmkatalog/firebase/firestore_connector.dart';
import 'package:csmkatalog/screens/sales/sales_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:csmkatalog/models/house.dart';
import 'package:csmkatalog/models/client.dart';
import 'package:csmkatalog/widgets/desktop_widgets.dart';
import 'package:csmkatalog/screens/sales/sales_list.dart';
import 'package:csmkatalog/screens/sales/sales_add.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  getClientAdd({Client? client}) {
    return SalesAdd(
        client: client ?? Client.empty(),
        changeScreenListener: () {
          setState(() {
            selectedScreen = getActiveClientList();
          });
        }
    );
  }

  getPotentialClientList() {
    return SalesList(
      changeScreenListener: (Client client) {setState(() {selectedScreen = getClientAdd(client: client);});},
      loadCallback: () => FirestoreConnector.readClients(),
    );
  }

  getActiveClientList() {
    return SalesList(
        changeScreenListener: (Client client) {setState(() {selectedScreen = getClientAdd(client: client);});},
        loadCallback: () => FirestoreConnector.readClients(),
    );
  }

  getInactiveClientList() {
    return SalesList(
      changeScreenListener: (Client client) {setState(() {selectedScreen = getClientAdd(client: client);});},
      loadCallback: () => FirestoreConnector.readClients(),
    );
  }

  getPastClientList() {
    return SalesList(
      changeScreenListener: (Client client) {setState(() {selectedScreen = getClientAdd(client: client);});},
      loadCallback: () => FirestoreConnector.readClients(),
    );
  }

  _SalesScreenState () {
    dashboardScreens = [
      DashboardScreen(label: "Daftar Peminat", icon: const Icon(Icons.abc_outlined), widget: getPotentialClientList()),
      DashboardScreen(label: "Daftar Klien", icon: const Icon(Icons.abc_outlined), widget: getActiveClientList()),
      DashboardScreen(label: "Tambah Klien", icon: const Icon(Icons.abc_outlined), widget: getClientAdd()),
      DashboardScreen(label: "Riwayat Pembelian", icon: const Icon(Icons.abc_outlined), widget: getPastClientList()),
      DashboardScreen(label: "Riwayat Penawaran", icon: const Icon(Icons.abc_outlined), widget: getInactiveClientList()),
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
                  applicationName: "Pencatatan Client",
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



