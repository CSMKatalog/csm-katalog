import 'dart:async';

import 'package:csmkatalog/screens/admin/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:csmkatalog/models/house.dart';
import 'package:csmkatalog/models/client.dart';
import 'package:csmkatalog/utils/dashboard_screen.dart';
import 'package:csmkatalog/widgets/desktop/sidebar.dart';
import 'package:csmkatalog/screens/admin/house_cover.dart';
import 'package:csmkatalog/screens/admin/house_list.dart';
import 'package:csmkatalog/screens/admin/house_add.dart';
import 'package:csmkatalog/screens/sales/sales_list.dart';
import 'package:csmkatalog/screens/sales/sales_add.dart';
import 'package:csmkatalog/widgets/desktop/toast.dart';

import 'package:csmkatalog/screens/sales/sales_progress.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  void showToast(String message) async {
    setState(() {
      toastOverlay = Toast(message: message);
      timer = Timer(Duration(seconds: 2), () {
        setState(() {
          toastOverlay = null;
        });
      });
    });
  }

  void missingValueToast() {
    showToast("Ada data penting yang belum diisi");
  }

  void notANumberToast() {
    showToast("Ada data angka yang tidak valid");
  }

  void moreThanPriceToast() {
    showToast("DP tidak dapat lebih dari harga rumah");
  }

  void tooLongToast() {
    showToast("Deskripsi rumah terlalu panjang");
  }

  void notAPhoneNumberToast() {
    showToast("Nomor telepon tidak valid");
  }

  void successUpdateToast() {
    showToast("Data berhasil diedit");
  }

  void successCreateToast() {
    showToast("Data berhasil ditambah");
  }

  void successDeleteToast() {
    showToast("Data berhasil dihapus");
  }

  void successRestoreToast() {
    showToast("Data berhasil dipulihkan");
  }

  Widget? toastOverlay;
  Timer? timer;

  Widget getHouseAdd() {
    return HouseAdd(
      house: House.empty(),
      changeScreenListener: () {
        setState(() { selectedScreen = getHouseList(); });
      },
      missingValueToast: missingValueToast,
      moreThanPriceToast: moreThanPriceToast,
      tooLongToast: tooLongToast,
      successUpdateToast: successUpdateToast,
      successCreateToast: successCreateToast,
      successDeleteToast: successDeleteToast,
    );
  }

  Widget getHouseEdit(House house) {
    return HouseAdd(
      house: house,
      changeScreenListener: () {
        setState(() { selectedScreen = getHouseList(); });
      },
      missingValueToast: missingValueToast,
      moreThanPriceToast: moreThanPriceToast,
      tooLongToast: tooLongToast,
      successUpdateToast: successUpdateToast,
      successCreateToast: successCreateToast,
      successDeleteToast: successDeleteToast,
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
    return HouseCover(successUpdateToast: successUpdateToast,);
  }

  Widget getClientAdd() {
    return SalesAdd(
      client: Client.empty(),
      changeScreenListener: () {
        setState(() { selectedScreen = getClientList(); });
      },
      progressScreenListener: () { },
      missingValueToast: missingValueToast,
      tooLongToast: tooLongToast,
      notAPhoneNumberToast: notAPhoneNumberToast,
      successUpdateToast: successUpdateToast,
      successCreateToast: successCreateToast,
      successDeleteToast: successDeleteToast,
      successRestoreToast: successRestoreToast,
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
      missingValueToast: missingValueToast,
      tooLongToast: tooLongToast,
      notAPhoneNumberToast: notAPhoneNumberToast,
      successUpdateToast: successUpdateToast,
      successCreateToast: successCreateToast,
      successDeleteToast: successDeleteToast,
      successRestoreToast: successRestoreToast,
    );
  }

  Widget getClientProgress(Client client) {
    return SalesProgress(client: client, changeScreenListener: () {
      setState(() { selectedScreen = getClientEdit(client); });
    }, successUpdateToast: successUpdateToast,);
  }

  Widget getClientList() {
    return SalesList(
      changeScreenListener: (Client client) {setState(() {selectedScreen = getClientEdit(client);});},
    );
  }

  Widget getChangeSettings() {
    return ChangeSettings(
      changeScreenListener: () { setState(() { selectedScreen = getHouseList(); }); },
      missingValueToast: missingValueToast,
      notANumberToast: notANumberToast,
      successUpdateToast: successUpdateToast,
    );
  }

  _AdminScreenState () {
    dashboardScreens = [
      DashboardScreen(label: "Daftar Item", icon: Icons.abc_outlined, widgetFunction: getHouseList),
      DashboardScreen(label: "Tambah Item", icon: Icons.abc_outlined, widgetFunction: getHouseAdd),
      DashboardScreen(label: "Halaman Depan", icon: Icons.abc_outlined, widgetFunction: getCover),
      // DashboardScreen(label: "", icon: const Icon(Icons.abc_outlined), widget: SizedBox(height: 10,)),
      DashboardScreen(label: "Daftar Klien", icon: Icons.abc_outlined, widgetFunction: getClientList),
      DashboardScreen(label: "Tambah Klien", icon: Icons.abc_outlined, widgetFunction: getClientAdd),
      DashboardScreen(label: "Pengaturan", icon: Icons.abc_outlined, widgetFunction: getChangeSettings),
    ];
    selectedScreen = dashboardScreens[0].widgetFunction();
  }
  late List<DashboardScreen> dashboardScreens;
  late Widget selectedScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
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
          ),
          if(toastOverlay != null) Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                toastOverlay!
              ]
          ),
        ],
      )
    );
  }
}

