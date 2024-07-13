import 'dart:developer';
import 'dart:math';

import 'package:csmkatalog/widgets/catalog/submit_button.dart';
import 'package:csmkatalog/widgets/catalog/text_detail.dart';
import 'package:csmkatalog/widgets/catalog/combobox_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csmkatalog/models/house.dart';
import 'catalog_widget.dart';

class CalculatorOverlay extends StatefulWidget {
  const CalculatorOverlay({super.key, required this.houseList, required this.interest, required this.closeWidgetListener, required this.missingValueToast, required this.moreThanPriceToast, required this.lessThanMinimumToast});
  final List<House> houseList;
  final double interest;
  final VoidCallback closeWidgetListener;
  final VoidCallback missingValueToast;
  final VoidCallback moreThanPriceToast;
  final VoidCallback lessThanMinimumToast;

  @override
  State<CalculatorOverlay> createState() => _CalculatorOverlayState();
}

class _CalculatorOverlayState extends State<CalculatorOverlay> {
  final priceController = TextEditingController();
  final dpController = TextEditingController();
  final interestController = TextEditingController();
  int minimumDP = 0;

  late List<String> houseTypes = [...widget.houseList.where((e) => e.name.isNotEmpty).map((e) => e.name).toList(), "Belum Tentu"];
  late String selectedHouse = houseTypes.last;
  List<Widget> compoundTable = [];

  @override
  void initState() {
    super.initState();
    interestController.text = widget.interest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return CatalogOverlayBackground(
        label: "Simulasi Kredit",
        closeWidgetListener: widget.closeWidgetListener,
        children: [
          Flexible(
            child: ComboBoxDetail(label: "Tipe Rumah", items: houseTypes, value: selectedHouse,
                onChanged: (v) {
                  selectedHouse = v;
                  House house = widget.houseList.firstWhere((e) => e.name == v, orElse: House.empty);
                  priceController.text = house.modelID.isNotEmpty ? house.price.toString() : "";
                  dpController.text = house.modelID.isNotEmpty ? house.downPayment.toString() : "";
                  minimumDP = house.modelID.isNotEmpty ? house.downPayment : 0;
                }),
          ),
          TextDetail(
            label: "Harga Jual Rumah",
            hintText: "Harga jual (Rp)",
            textController: priceController,
            prefix: "Rp.",
            suffix: ",—",
            numberInput: true,
            readOnly: true,
          ),
          TextDetail(
            label: "Down Payment",
            hintText: "DP (Rp)",
            textController: dpController,
            prefix: "Rp.",
            suffix: ",—",
            numberInput: true,),
          TextDetail(
            label: "Suku Bunga Kredit",
            hintText: "Suku bunga (%)",
            textController: interestController,
            suffix: "%          ",
            numberInput: true,
            readOnly: true,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SubmitButton(text: "Hitung", onPressed: () async {
                  if(priceController.value.text.isEmpty ||
                      dpController.value.text.isEmpty ||
                      interestController.value.text.isEmpty) {
                    widget.missingValueToast();
                    return;
                  }

                  int price = int.parse(priceController.value.text.replaceAll(RegExp(r"[.,]"), ""));
                  int downPayment = int.parse(dpController.value.text.replaceAll(RegExp(r"[.,]"), ""));
                  double interest = double.parse(interestController.value.text.replaceAll(",", ".")) / 100;
                  List<int> years = [5, 10, 15, 20];

                  if(downPayment > price) {
                    widget.moreThanPriceToast();
                    return;
                  }

                  if(downPayment < minimumDP) {
                    widget.lessThanMinimumToast();
                    return;
                  }

                  setState(() {
                      compoundTable = years.map((e) {
                        // num priceAfterInterest = (price - downPayment) * pow(1 + interest, e);
                        num priceAfterInterest = (price - downPayment) * (1 + (interest * e));
                        TextEditingController _ = TextEditingController();
                        _.text = ((priceAfterInterest / e) ~/ 12).toString();
                        return TextDetail(
                          label: "$e tahun",
                          textController: _,
                          prefix: "±Rp.",
                          suffix: ",—/bln",
                          numberInput: true,
                          readOnly: true,
                        );
                      }).toList();
                    });
                  }),
                SizedBox(width: 32,)
              ],
            ),
          ),
          SizedBox(height: 8,),
          for(Widget row in compoundTable) row,
        ]
    );
  }
}