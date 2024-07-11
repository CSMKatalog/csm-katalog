import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../firebase/firestore_connector.dart';
import '../../models/client.dart';
import '../../models/house.dart';
import '../../widgets/catalog/combobox_detail.dart';
import '../../widgets/catalog/submit_button.dart';
import '../../widgets/catalog/text_detail.dart';
import 'catalog_widget.dart';

class ContactFormOverlay extends StatefulWidget {
  const ContactFormOverlay({super.key, required this.officeContact, required this.houseList, required this.closeWidgetListener, required this.submitWidgetListener, required this.missingValueToast});
  final String officeContact;
  final List<House> houseList;
  final VoidCallback closeWidgetListener;
  final VoidCallback submitWidgetListener;
  final VoidCallback missingValueToast;

  @override
  State<ContactFormOverlay> createState() => _ContactFormOverlayState();
}

class _ContactFormOverlayState extends State<ContactFormOverlay> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final officeController = TextEditingController();

  late List<String> houseTypes = [...widget.houseList.where((e) => e.name.isNotEmpty).map((e) => e.name).toList(), "Belum Tentu"];
  late String selectedHouse = houseTypes.last;

  Future<void> uploadClientDetail() async {
    if(nameController.value.text.isEmpty ||
        phoneController.value.text.isEmpty ||
        officeController.value.text.isEmpty) {
      widget.missingValueToast();
      return;
    }

    Client client =  Client(
        clientID: "",
        clientType: ClientType.interested,
        house: selectedHouse,
        name: nameController.value.text,
        phoneNumber: phoneController.value.text,
        note: "Mengontak melalui form pada katalog",
        progress: getBlankProgress()
    );

    await FirestoreConnector.createClient(client)
        .then((value) => widget.submitWidgetListener());
  }

  @override
  void initState() {
    super.initState();
    officeController.text = widget.officeContact;
  }

  @override
  Widget build(BuildContext context) {
    return CatalogOverlayBackground(
        label: "Hubungi Kami",
        closeWidgetListener: widget.closeWidgetListener,
        children: [
          TextDetail(
            label: "Nomor Kami",
            textController: officeController,
            readOnly: true,
          ),
          SizedBox(height: 24,),
          TextDetail(
            label: "Nama Anda *",
            hintText: "Nama pemilik kontak",
            textController: nameController,
          ),
          TextDetail(
            label: "Nomor / Email *",
            hintText: "Kontak yang dapat dihubungi",
            textController: phoneController,
          ),
          Flexible(
            child: ComboBoxDetail(label: "Model Rumah", items: houseTypes, value: selectedHouse,
              onChanged: (v) { selectedHouse = v; },
            ),
          ),
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SubmitButton(text: "Kirim", onPressed: uploadClientDetail),
            ],
          )),
         ]
    );
  }
}

class ResultsOverlay extends StatelessWidget {
  const ResultsOverlay({super.key, required this.officeContact, required this.closeWidgetListener});
  final VoidCallback closeWidgetListener;
  final String officeContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color.fromARGB(200, 40, 40, 60),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "Terima Kasih Atas Respons Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
              ),
              const Text(
                  "Anda juga dapat menghubungi kami melalui",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  )
              ),
              SizedBox(height: 4,),
              Text(
                  officeContact,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                  )
              ),
              SizedBox(height: 8,),
              SubmitButton(
                  text: "Kembali",
                  onPressed: () async { closeWidgetListener(); }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
