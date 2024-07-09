import 'package:csmkatalog/widgets/desktop/combobox_detail.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import 'package:csmkatalog/models/client.dart';
import 'package:csmkatalog/firebase/firestore_connector.dart';
import 'package:csmkatalog/widgets/desktop/header.dart';
import 'package:csmkatalog/widgets/desktop/submit_button.dart';
import 'package:csmkatalog/widgets/desktop/text_detail.dart';

class SalesAdd extends StatefulWidget {
  const SalesAdd({super.key, required this.client, required this.changeScreenListener});
  final Client client;
  final VoidCallback changeScreenListener;

  @override
  State<SalesAdd> createState() => _SalesAddState();
}

class _SalesAddState extends State<SalesAdd> {
  _SalesAddState ();

  // TODO: Ini untuk data-data yang diperlukan untuk menampung data input
  late List<Widget> fields;
  final houseController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();
  String typeItem = "Tertarik";
  String headerText = "Tambah Data Klien Baru";

  Future<void> uploadClientDetail() async {
    Client client =  Client(
      clientID: widget.client.clientID,
      clientType: stringToClientType(typeItem),
      house: houseController.value.text,
      name: nameController.value.text,
      phoneNumber: phoneController.value.text,
      note: noteController.value.text,
    );

    if (widget.client.clientID.isNotEmpty) {
      await FirestoreConnector.updateClient(widget.client.clientID, client)
          .then((value) => widget.changeScreenListener());
    } else {
      await FirestoreConnector.createClient(client)
          .then((value) => widget.changeScreenListener());
    }
  }

  Future<void> deleteClientDetail() async {
    await FirestoreConnector.deleteClient(widget.client.clientID)
        .then((value) => widget.changeScreenListener());
  }

  @override
  void initState() {
    super.initState();
    fields = [];

    // Isi form field jika ada data
    // TODO: Ini untuk ubah pindahkan data dari detail ke tampilan
    if (widget.client.clientID.isNotEmpty) {
      Client client = widget.client;
      headerText = "Detail Klien ${client.name}";
      houseController.text = client.house;
      nameController.text = client.name;
      phoneController.text = client.phoneNumber;
      noteController.text = client.note;
      typeItem = clientTypeToString(client.clientType);
    }

    fields.add(TextDetail(label: "Nama", hintText: "Nama klien", textEditingController: nameController),);
    fields.add(const SizedBox());
    fields.add(ComboBoxDetail(label: "Tipe Klien", onChanged: (e) { typeItem = e; }, value: typeItem,
      items: ["Tertarik", "Sedang Proses", "Telah Membeli", "Batal", "Belum Tentu"],));
    fields.add(TextDetail(label: "Model Rumah Terkait", hintText: "Model rumah yang diinginkan klien", textEditingController: houseController),);
    fields.add(TextDetail(label: "Nomor Telepon", hintText: "Nomor telepon kontak klien", textEditingController: phoneController),);
    fields.add(LongTextDetail(label: "Keterangan", hintText: "Keterangan terkait klien", textEditingController: noteController),);
    fields.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SubmitButton(text: "Progress", onPressed: uploadClientDetail),
      ],
    ));
    // Tambah tombol add atau edit
    if (widget.client.clientID.isNotEmpty) {
      fields.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SubmitButton(text: "Ubah", onPressed: uploadClientDetail),
          SubmitButton(text: "Hapus", onPressed: deleteClientDetail),
        ],
      ));
    } else {
      fields.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SubmitButton(text: "Tambah", onPressed: uploadClientDetail),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(text: headerText, onTap: widget.changeScreenListener,),
        Expanded(
          child: DynamicHeightGridView(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              itemCount: fields.length,
              builder: (context, index) {
                return fields[index];
              }
          ),
        ),
      ],
    );
  }
}