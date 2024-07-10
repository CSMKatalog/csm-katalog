import 'dart:developer';

import 'package:csmkatalog/screens/sales/sales_progress.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:csmkatalog/firebase/firestore_connector.dart';
import 'package:csmkatalog/models/house.dart';
import 'package:csmkatalog/models/client.dart';
import 'package:csmkatalog/widgets/desktop/header.dart';
import 'package:csmkatalog/widgets/desktop/sidebar.dart';
import 'package:csmkatalog/screens/sales/sales_list.dart';
import 'package:csmkatalog/screens/sales/sales_add.dart';

import '../../utils/dashboard_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  Widget getClientAdd() {
    return SalesAdd(
      client: Client.empty(),
      changeScreenListener: () {
        setState(() { selectedScreen = getActiveClientList(); });
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
        setState(() { selectedScreen = getActiveClientList(); });
      },
      progressScreenListener: () {
        setState(() { selectedScreen = getClientProgress(client); });
      },
    );
  }

  Widget getClientProgress(Client client) {
    return SalesProgress(client: client, changeScreenListener: () {
      setState(() {
        selectedScreen = getPotentialClientList();
      });
    });
  }

  Widget getPotentialClientList() {
    return SalesList(
      changeScreenListener: (Client client) {setState(() {selectedScreen = getClientEdit(client);});},
      loadCallback: () => FirestoreConnector.readClients(ClientType.interested),
    );
  }

  Widget getActiveClientList() {
    return SalesList(
      changeScreenListener: (Client client) {setState(() {selectedScreen = getClientEdit(client);});},
      loadCallback: () => FirestoreConnector.readClients(ClientType.inProgress),
    );
  }

  Widget getInactiveClientList() {
    return SalesList(
      changeScreenListener: (Client client) {setState(() {selectedScreen = getClientEdit(client);});},
      loadCallback: () => FirestoreConnector.readClients(ClientType.cancelled),
    );
  }

  Widget getPastClientList() {
    return SalesList(
      changeScreenListener: (Client client) {setState(() {selectedScreen = getClientEdit(client);});},
      loadCallback: () => FirestoreConnector.readClients(ClientType.bought),
    );
  }

  _SalesScreenState () {
    dashboardScreens = [
      Screen(label: "Daftar Peminat", icon: Icons.abc_outlined, widgetFunction: getPotentialClientList),
      Screen(label: "Daftar Klien", icon: Icons.abc_outlined, widgetFunction: getActiveClientList),
      Screen(label: "Tambah Klien", icon: Icons.abc_outlined, widgetFunction: getClientAdd),
      Screen(label: "Riwayat Pembelian", icon: Icons.abc_outlined, widgetFunction: getPastClientList),
      Screen(label: "Riwayat Penawaran", icon: Icons.abc_outlined, widgetFunction: getInactiveClientList),
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



