import 'package:eyecheckv2/utils/api_endpoints.dart';
import 'package:eyecheckv2/utils/medical_record_model.dart';
import 'package:flutter/material.dart';

class MedicalRecordTile extends StatefulWidget {
  final String recordTilteName;
  final String recordTilteTime;
  final bool isPasien;

  final MedicalRecord medicalRecord;

  const MedicalRecordTile(
      {required this.recordTilteName,
      required this.recordTilteTime,
      required this.medicalRecord,
      required this.isPasien,
      super.key});

  @override
  State<MedicalRecordTile> createState() => _MedicalRecordTileState();
}

class _MedicalRecordTileState extends State<MedicalRecordTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.white70,
        child: Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isPasien
                    ? const SizedBox(height: 0)
                    : Text(
                        widget.recordTilteName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                Text('Waktu Deteksi: ${widget.recordTilteTime}'),
              ],
            ),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Status Deteksi: ${widget.medicalRecord.gejala['Lensa keruh']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  widget.medicalRecord.jenisKatarak == null
                      ? const SizedBox(height: 0)
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Jenis Katarak: ${widget.medicalRecord.jenisKatarak}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                  const SizedBox(height: 10),
                  widget.medicalRecord.jenisKatarak == null
                      ? const SizedBox(height: 0)
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.medicalRecord.gejala.length - 1,
                          itemBuilder: (BuildContext context, int index) {
                            var entry = widget.medicalRecord.gejala.entries
                                .elementAt(index);
                            return Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${entry.key}: ',
                                        // style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: '${entry.value}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                  const SizedBox(height: 10),
                  widget.medicalRecord.percentageExpertSystem == null
                      ? const SizedBox(height: 0)
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Percentage Expert System: ${widget.medicalRecord.percentageExpertSystem?.toStringAsFixed(2)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                  const SizedBox(height: 10),
                  Center(
                      child: Column(
                    children: [
                      const Text(
                        'Gambar Mata',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Image.network(
                        "${ApiEndPoints.baseUrl}image${widget.medicalRecord.pictureUrl}",
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ],
                  )),
                  const SizedBox(height: 10),
                ],
              ),
            ],
            onExpansionChanged: (bool expanded) {
              setState(
                () {
                  isExpanded = expanded;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
