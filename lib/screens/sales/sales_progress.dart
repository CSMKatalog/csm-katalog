

import 'dart:developer';

import 'package:csmkatalog/screens/sales/progress_track.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import 'package:csmkatalog/models/client.dart';
import 'package:csmkatalog/widgets/desktop/header.dart';
import 'package:csmkatalog/widgets/desktop/checkbox_detail.dart';
import 'package:csmkatalog/widgets/desktop/document_list_detail.dart';

import '../../firebase/firestore_connector.dart';
import '../../utils/dashboard_screen.dart';

class SalesProgress extends StatefulWidget {
  const SalesProgress({super.key, required this.client, required this.changeScreenListener, required this.successUpdateToast});
  final Client client;
  final VoidCallback changeScreenListener;
  final VoidCallback successUpdateToast;

  @override
  State<SalesProgress> createState() => _SalesProgressState();
}

class _SalesProgressState extends State<SalesProgress> {
  late Client client;

  Future<void> uploadClientDetail() async {
    log('5');
    await FirestoreConnector.updateClient(client.clientID, client);
    log('6');
    Client updatedClient = await FirestoreConnector.getClient(client.clientID);
    log('7');
    widget.successUpdateToast();
    setState(() {
      client = updatedClient;
    });
  }

  Widget getKTPKKScreen(Client client) {
    return DocumentProgress(
      label: "KTP dan KK telah diupload",
      headerText: "Upload KTP dan KK",
      value: client.progress['ktpkk']['done'],
      documents: [
        FileListDetail(
          label: "Foto KTP",
          listOfUrls: client.progress['ktpkk']['ktp'],
          fileAddListener: (s) { client.progress['ktpkk']['ktp'].add(s); },
          fileDeleteListener: (i) { client.progress['ktpkk']['ktp'].removeAt(i); },
          onSubmit: uploadClientDetail,
        ),
        FileListDetail(
          label: "Foto KK",
          listOfUrls: client.progress['ktpkk']['kk'],
          fileAddListener: (s) { client.progress['ktpkk']['kk'].add(s); },
          fileDeleteListener: (i) { client.progress['ktpkk']['kk'].removeAt(i); },
          onSubmit: uploadClientDetail,
        ),
      ],
      onCheck: () {
        client.progress['ktpkk']['done'] = !client.progress['ktpkk']['done'];
        uploadClientDetail();
      },
    );
  }

  Widget getDPScreen(Client client) {
    return DocumentProgress(
        label: "DP telah dibayar dan dikonfirmasi",
        headerText: "Pembayaran Down Payment",
        value: client.progress['dp']['done'],
        documents: [
          FileListDetail(
            label: "Bukti pembayaran DP",
            listOfUrls: client.progress['dp']['dp'],
            fileAddListener: (s) { client.progress['dp']['dp'].add(s); },
            fileDeleteListener: (i) { client.progress['dp']['dp'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
        ],
        onCheck: () {
          client.progress['dp']['done'] = !client.progress['dp']['done'];
          uploadClientDetail();
        },
    );
  }

  Widget getBIScreen(Client client) {
    return DocumentProgress(
        label: "Pengecek BI telah dilakukan",
        headerText: "Pengecekan Bank Indonesia",
        value: client.progress['bi']['done'],
        documents: [
          FileListDetail(
            label: "Hasil pengecekan BI",
            listOfUrls: client.progress['bi']['bi'],
            fileAddListener: (s) { client.progress['bi']['bi'].add(s); },
            fileDeleteListener: (i) { client.progress['bi']['bi'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
        ],
        onCheck: () {
          client.progress['bi']['done'] = !client.progress['bi']['done'];
          uploadClientDetail();
        },
    );
  }

  Widget getDocumentsScreen(Client client) {
    return DocumentProgress(
        label: "Data-data telah diterima",
        headerText: "Upload Dokumen-dokumen Pendamping",
        value: client.progress['pendamping']['done'],
        documents: [
          FileListDetail(
            label: "Pasfoto suami/istri 3x4",
            listOfUrls: client.progress['pendamping']['pasangan'],
            fileAddListener: (s) { client.progress['pendamping']['pasangan'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['pasangan'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Slip gaji 3 bulan terakhir",
            listOfUrls: client.progress['pendamping']['gaji3bln'],
            fileAddListener: (s) { client.progress['pendamping']['gaji3bln'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['gaji3bln'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Daftar gaji SKPG (dilegalisir)",
            listOfUrls: client.progress['pendamping']['gajiskpg'],
            fileAddListener: (s) { client.progress['pendamping']['gajiskpg'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['gajiskpg'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Surat Keterangan Kerja",
            listOfUrls: client.progress['pendamping']['skk'],
            fileAddListener: (s) { client.progress['pendamping']['skk'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['skk'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Kartu pegawai / NIP",
            listOfUrls: client.progress['pendamping']['nip'],
            fileAddListener: (s) { client.progress['pendamping']['nip'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['nip'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Tabungan 3 bulan terakhir",
            listOfUrls: client.progress['pendamping']['tbng3bln'],
            fileAddListener: (s) { client.progress['pendamping']['tbng3bln'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['tbng3bln'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Surat belum punya rumah dari kelurahan",
            listOfUrls: client.progress['pendamping']['rmhlurah'],
            fileAddListener: (s) { client.progress['pendamping']['rmhlurah'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['rmhlurah'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Tabungan Batara (BTN)",
            listOfUrls: client.progress['pendamping']['tbngbtn'],
            fileAddListener: (s) { client.progress['pendamping']['tbngbtn'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['tbngbtn'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Surat Keterangan Usaha (wiraswasta)",
            listOfUrls: client.progress['pendamping']['sku'],
            fileAddListener: (s) { client.progress['pendamping']['sku'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['sku'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Laporan Keuangan Usaha (wiraswasta)",
            listOfUrls: client.progress['pendamping']['lku'],
            fileAddListener: (s) { client.progress['pendamping']['lku'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['lku'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Foto tempat usaha / bukti legalitas (wiraswasta)",
            listOfUrls: client.progress['pendamping']['legalusaha'],
            fileAddListener: (s) { client.progress['pendamping']['legalusaha'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['legalusaha'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
          FileListDetail(
            label: "Materai 6000 (35 lembar)",
            listOfUrls: client.progress['pendamping']['mat600035'],
            fileAddListener: (s) { client.progress['pendamping']['mat600035'].add(s); },
            fileDeleteListener: (i) { client.progress['pendamping']['mat600035'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
        ],
        onCheck: () {
          client.progress['pendamping']['done'] = !client.progress['pendamping']['done'];
          uploadClientDetail();
        },
    );
  }

  Widget getSurveyScreen(Client client) {
    return DocumentProgress(
        label: "Survei telah dilakukan",
        headerText: "Hasil Survei",
        value: client.progress['survei']['done'],
        documents: [
          FileListDetail(
            label: "Hasil survei",
            listOfUrls: client.progress['survei']['survei'],
            fileAddListener: (s) { client.progress['survei']['survei'].add(s); },
            fileDeleteListener: (i) { client.progress['survei']['survei'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
        ],
        onCheck: () {
          client.progress['survei']['done'] = !client.progress['survei']['done'];
          uploadClientDetail();
        },
    );
  }

  Widget getCreditScreen(Client client) {
    return DocumentProgress(
        label: "Akad kredit telah dilakukan",
        headerText: "Kontrak Akad Kredit",
        value: client.progress['kredit']['done'],
        documents: [
          FileListDetail(
            label: "Akad kredit",
            listOfUrls: client.progress['kredit']['kredit'],
            fileAddListener: (s) { client.progress['kredit']['kredit'].add(s); },
            fileDeleteListener: (i) { client.progress['kredit']['kredit'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
        ],
        onCheck: () {
          client.progress['kredit']['done'] = !client.progress['kredit']['done'];
          uploadClientDetail();
        },
    );
  }

  Widget getKeyScreen(Client client) {
    return DocumentProgress(
        label: "Serah terima telah dilakukan",
        headerText: "Penyerahan Kunci",
        value: client.progress['kunci']['done'],
        documents: [
          FileListDetail(
            label: "Foto serah terima",
            listOfUrls: client.progress['kunci']['kunci'],
            fileAddListener: (s) { client.progress['kunci']['kunci'].add(s); },
            fileDeleteListener: (i) { client.progress['kunci']['kunci'].removeAt(i); },
            onSubmit: uploadClientDetail,
          ),
        ],
        onCheck: () {
          client.progress['kunci']['done'] = !client.progress['kunci']['done'];
          uploadClientDetail();
        },
    );
  }

  @override
  void initState() {
    super.initState();
    client = widget.client;
    documents = [
      ProgressScreen(label: "KTP KK", valueKey: 'ktpkk', icon: Icons.perm_identity, widgetFunction: getKTPKKScreen),
      ProgressScreen(label: "DP", valueKey: 'dp', icon: Icons.payments_outlined, widgetFunction: getDPScreen),
      ProgressScreen(label: "BI", valueKey: 'bi', icon: Icons.account_balance_outlined, widgetFunction: getBIScreen),
      ProgressScreen(label: "Dokumen", valueKey: 'pendamping', icon: Icons.file_copy_outlined, widgetFunction: getDocumentsScreen),
      ProgressScreen(label: "Survei", valueKey: 'survei', icon: Icons.search, widgetFunction: getSurveyScreen),
      ProgressScreen(label: "Kredit", valueKey: 'kredit', icon: Icons.credit_card, widgetFunction: getCreditScreen),
      ProgressScreen(label: "Serah Terima", valueKey: 'kunci', icon: Icons.key, widgetFunction: getKeyScreen),
    ];
    selectedScreenFunction = documents[index].widgetFunction;
  }

  late List<ProgressScreen> documents;
  late Widget Function(Client) selectedScreenFunction;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(text: "Progress Pengajuan Kredit", onTap: widget.changeScreenListener,),
        ProgressTrack(items: documents.map((e) => ProgressTrackItem(
            icon: e.icon,
            label: e.label,
            checkValue: client.progress[e.valueKey]['done'],
            changeScreenListener: () {
              setState(() {
                selectedScreenFunction = e.widgetFunction;
              });
            },
        )).toList()),
        Flexible(child: selectedScreenFunction(client)),
      ],
    );
  }
}

class DocumentProgress extends StatefulWidget {
  const DocumentProgress({super.key, required this.label, required this.headerText, required this.value, required this.documents, required this.onCheck});
  final String label;
  final String headerText;
  final bool value;
  final List<FileListDetail> documents;
  final VoidCallback onCheck;

  @override
  State<DocumentProgress> createState() => _DocumentProgressState();
}

class _DocumentProgressState extends State<DocumentProgress> {
  _DocumentProgressState ();
  late Future<dynamic> _future;

  Future<dynamic> loadWidgets() {
    List<Widget> fields = [];
    fields.add(CheckboxDetail(label: widget.label, value: widget.value, onChanged: widget.onCheck,),);
    fields.add(const SizedBox());
    for(FileListDetail doc in widget.documents) {
      fields.add(doc);
    }
    fields.add(SizedBox());
    if(widget.documents.length % 2 == 1) fields.add(SizedBox());
    return Future<dynamic>.value(fields);
  }

  @override
  Widget build(BuildContext context) {
    _future = loadWidgets();

    return Column(
      children: [
        SectionHeader(text: widget.headerText, ),
        Expanded(
          child: FutureBuilder(
            builder: (context, snapshot) {
              List<Widget> screens = snapshot.connectionState == ConnectionState.waiting ? [] : snapshot.data;
              return DynamicHeightGridView(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  itemCount: screens.length,
                  builder: (context, index) {
                    return screens[index];
                  }
              );
            }, future: _future,
          ),
        ),
      ],
    );
  }
}