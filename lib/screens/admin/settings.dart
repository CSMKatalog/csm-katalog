import 'package:csmkatalog/widgets/desktop/submit_button.dart';
import 'package:csmkatalog/widgets/desktop/text_detail.dart';
import 'package:flutter/material.dart';

import '../../firebase/firestore_connector.dart';
import '../../widgets/desktop/header.dart';

class ChangeSettings extends StatefulWidget {
  const ChangeSettings({super.key, required this.changeScreenListener,
    required this.missingValueToast, required this.notANumberToast,
    required this.successUpdateToast});
  final VoidCallback changeScreenListener;
  final VoidCallback missingValueToast;
  final VoidCallback notANumberToast;
  final VoidCallback successUpdateToast;

  @override
  State<ChangeSettings> createState() => _ChangeSettingsState();
}

class _ChangeSettingsState extends State<ChangeSettings> {
  final TextEditingController contactController = TextEditingController();
  final TextEditingController interestController = TextEditingController();

  Future<void> uploadSettings() async {
    if(interestController.value.text.isEmpty ||
        contactController.value.text.isEmpty) {
      widget.missingValueToast();
      return;
    }

    double interest;
    try {
     interest = double.parse(interestController.value.text.replaceAll(",", "."));
    } catch (formatException) {
      widget.notANumberToast();
      return;
    }

    await FirestoreConnector.updateSettings("settingCSM", {
      "interest_rate": interest.toString(),
      "office_contact": contactController.value.text,
    });
    widget.changeScreenListener();
  }

  void fetchSettings() async {
    Map<String, String> temp = await FirestoreConnector.readSettings();
    contactController.text = temp['office_contact']!;
    interestController.text = temp['interest_rate']!;
    widget.successUpdateToast();
  }

  @override
  void initState() {
    super.initState();
    fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PageHeader(text: "Pengaturan Katalog", onTap: widget.changeScreenListener,),
        SizedBox(height: 40,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextDetail(
              label: "Kontak Kantor",
              hintText: "Nomor telepon atau email kantor",
              textEditingController: contactController
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextDetail(
              label: "Suku Bunga Kredit Rumah",
              hintText: "Bunga untuk simulasi angsuran rumah",
              textEditingController: interestController
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: SubmitButton(text: "Simpan", onPressed: uploadSettings),
        )
      ],
    );
  }
}
