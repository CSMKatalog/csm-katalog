import 'dart:developer';

import 'package:csmkatalog/widgets/catalog/combobox_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:csmkatalog/models/client.dart';
import 'package:flutter/widgets.dart';

import 'package:csmkatalog/firebase/firestore_connector.dart';

class SalesList extends StatefulWidget {
  SalesList({super.key, required this.changeScreenListener});
  Function(Client client) changeScreenListener;

  @override
  State<SalesList> createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  List<Client> clientList = [];
  String typeItem = "Semua";

  void fetchSalesList([ClientType? clientType]) async {
    List<Client> temp = await FirestoreConnector.readClients(clientType);
    setState(() {
        clientList = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSalesList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width/3,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          ComboBoxDetail(label: "Filter ",
            items: ["Tertarik", "Sedang Proses", "Telah Membeli", "Semua", "Dihapus"],
            value: typeItem,
            onChanged: (e) {
              setState(() {
              typeItem = e;
                if(e != "Semua") {
                  fetchSalesList(stringToClientType(e));
                } else {
                  fetchSalesList();
                }
              });
            }
          ),
          Expanded(
            child: ListView.builder(
                itemCount: clientList.length,
                itemBuilder: (context, index) {
                  return SalesListItem(client: clientList[index], changeScreenListener: widget.changeScreenListener);
                }
            ),
          ),
        ],
      ),
    );
  }
}

class SalesListItem extends StatelessWidget {
  const SalesListItem({super.key, required this.client, required this.changeScreenListener});
  final Client client;
  final Function(Client client) changeScreenListener;

  @override
  Widget build(BuildContext context) {
    double widthCoefficient = MediaQuery.of(context).size.width > 750 ? 0.75 : (MediaQuery.of(context).size.width/1000);
    TextStyle phone = TextStyle(
      fontSize: 22 * widthCoefficient,
      fontWeight: FontWeight.normal,
    );
    TextStyle name = TextStyle(
      fontSize: 26 * widthCoefficient,
      fontWeight: FontWeight.bold,
    );
    TextStyle type = TextStyle(
      fontSize: 26 * widthCoefficient,
      fontWeight: FontWeight.w300,
    );
    TextStyle small = TextStyle(
      fontSize: 20 * widthCoefficient,
      fontWeight: FontWeight.normal,
    );
    return InkWell(
      onTap: () {
        changeScreenListener(client);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(client.name, style: name),
                  Text(client.phoneNumber, style: phone,),
                ],
              ),
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  color: Colors.blueGrey[50],
                  child: Text(
                    clientTypeToString(client.clientType),
                    style: type,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(client.note, style: small, softWrap: true,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
