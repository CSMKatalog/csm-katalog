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
  const SalesAdd({super.key,
    required this.client,
    required this.changeScreenListener,
    required this.progressScreenListener,
    required this.missingValueToast,
    required this.tooLongToast,
    required this.successUpdateToast,
    required this.successCreateToast,
    required this.successDeleteToast});
  final Client client;
  final VoidCallback changeScreenListener;
  final VoidCallback progressScreenListener;
  final VoidCallback missingValueToast;
  final VoidCallback tooLongToast;
  final VoidCallback successUpdateToast;
  final VoidCallback successCreateToast;
  final VoidCallback successDeleteToast;

  @override
  State<SalesAdd> createState() => _SalesAddState();
}

class _SalesAddState extends State<SalesAdd> {
  _SalesAddState ();

  late List<Widget> fields;
  final houseController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();
  String typeItem = "Tertarik";
  String headerText = "Tambah Data Klien Baru";

  Future<void> uploadClientDetail() async {
    if(nameController.value.text.isEmpty || houseController.value.text.isEmpty || phoneController.value.text.isEmpty) {
      widget.missingValueToast();
      return;
    }

    Client client =  Client(
      clientID: widget.client.clientID,
      clientType: stringToClientType(typeItem),
      house: houseController.value.text,
      name: nameController.value.text,
      phoneNumber: phoneController.value.text,
      note: noteController.value.text,
      progress: widget.client.clientID.isNotEmpty ? widget.client.progress : getBlankProgress()
    );

    if(noteController.value.text.length > 200) {
      widget.tooLongToast();
      return;
    }

    if (widget.client.clientID.isNotEmpty) {
      await FirestoreConnector.updateClient(widget.client.clientID, client);
      widget.successUpdateToast();
    } else {
      await FirestoreConnector.createClient(client);
      widget.successCreateToast();
    }
  }

  Future<void> deleteClientDetail() async {
    await FirestoreConnector.deleteClient(widget.client.clientID);
    widget.successDeleteToast();
  }

  @override
  void initState() {
    super.initState();
    fields = [];
    var spinnerItems = ["Tertarik", "Sedang Proses", "Telah Membeli"];

    if (widget.client.clientID.isNotEmpty) {
      Client client = widget.client;
      headerText = "Detail Klien ${client.name}";
      houseController.text = client.house;
      nameController.text = client.name;
      phoneController.text = client.phoneNumber;
      noteController.text = client.note;
      typeItem = clientTypeToString(client.clientType);
      if(client.clientType == ClientType.deleted) {
        spinnerItems.add(clientTypeToString(ClientType.deleted));
      }
    }

    fields.add(TextDetail(label: "Nama *", hintText: "Nama klien", textEditingController: nameController,
      readOnly: typeItem == clientTypeToString(ClientType.deleted),),);
    fields.add(const SizedBox());
    fields.add(ComboBoxDetail(label: "Status Klien *", onChanged: (e) { typeItem = e; }, value: typeItem, items: spinnerItems,
      readOnly: typeItem == clientTypeToString(ClientType.deleted),));
    fields.add(TextDetail(label: "Model Rumah Terkait *", hintText: "Model rumah yang diinginkan klien", textEditingController: houseController,
        readOnly: typeItem == clientTypeToString(ClientType.deleted),),);
    fields.add(TextDetail(label: "Nomor Telepon / Email *", hintText: "Kontak klien yang dapat dihubungi", textEditingController: phoneController,
      readOnly: typeItem == clientTypeToString(ClientType.deleted),),);
    fields.add(LongTextDetail(label: "Keterangan", hintText: "Keterangan terkait klien", textEditingController: noteController,
      readOnly: typeItem == clientTypeToString(ClientType.deleted),),);

    if (widget.client.clientID.isEmpty) {
      fields.add(SizedBox());
      fields.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SubmitButton(text: "Tambah", onPressed: () async {
            await uploadClientDetail();
            widget.changeScreenListener();
          }),
        ],
      ));
      return;
    }

    if (widget.client.clientType == ClientType.deleted) {
      fields.add(SizedBox());
      fields.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SubmitButton(text: "Pulihkan", onPressed: () async {
            typeItem = clientTypeToString(ClientType.inProgress);
            await uploadClientDetail();
            widget.changeScreenListener();
          }),
        ],
      ));
      return;
    }

    fields.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SubmitButton(
            text: "Progress",
            onPressed: () async {
              await uploadClientDetail();
              widget.progressScreenListener();
            }),
      ],
    ));
    fields.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SubmitButton(text: "Ubah", onPressed: () async {
          await uploadClientDetail();
          widget.changeScreenListener();
        }),
        SubmitButton(text: "Hapus", onPressed: () async {
          if(typeItem != clientTypeToString(ClientType.deleted)) {
            typeItem = clientTypeToString(ClientType.deleted);
            await uploadClientDetail();
            widget.changeScreenListener();
          }
          // deleteClientDetail();
        }),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(text: headerText, onTap: widget.changeScreenListener,),
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