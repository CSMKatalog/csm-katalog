import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:csmkatalog/models/client.dart';

class SalesList extends StatefulWidget {
  const SalesList({super.key, required this.changeScreenListener, required this.loadCallback});
  final Function(Client client) changeScreenListener;
  final AsyncValueGetter<List<Client>> loadCallback;

  @override
  State<SalesList> createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  List<Client> clientList = [];

  void fetchSalesList() async {
    List<Client> temp = await widget.loadCallback();
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
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: clientList.length,
          itemBuilder: (context, index) {
            return SalesListItem(client: clientList[index], changeScreenListener: widget.changeScreenListener);
          }
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
      fontSize: 36 * widthCoefficient,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client.name, style: name),
                Text(client.phoneNumber, style: phone,),
              ],
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clientTypeToString(client.clientType), style: type,),
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
