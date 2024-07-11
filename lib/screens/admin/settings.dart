import 'package:csmkatalog/widgets/desktop/text_detail.dart';
import 'package:flutter/material.dart';

import '../../widgets/desktop/header.dart';

class ChangeSettings extends StatefulWidget {
  const ChangeSettings({super.key, required this.changeScreenListener});
  final VoidCallback changeScreenListener;

  @override
  State<ChangeSettings> createState() => _ChangeSettingsState();
}

class _ChangeSettingsState extends State<ChangeSettings> {
  final TextEditingController contactController = TextEditingController();
  final TextEditingController interestController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(text: "Pengaturan Katalog", onTap: widget.changeScreenListener,),
        Expanded(
          child: TextDetail(
              label: "Kontak Kantor",
              hintText: "Nomor telepon atau email kantor",
              textEditingController: contactController
          ),
        ),
        Expanded(
          child: TextDetail(
              label: "Suku Bunga Rumah",
              hintText: "Bunga untuk simulasi angsuran rumah",
              textEditingController: interestController
          ),
        ),
      ],
    );
  }
}
