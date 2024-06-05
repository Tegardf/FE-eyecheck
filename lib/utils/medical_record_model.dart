import 'package:intl/intl.dart';

class MedicalRecord {
  final int id;
  final Map<String, String?> gejala;
  final String? jenisKatarak;
  final double? percentageExpertSystem;
  final String pictureUrl;
  final String name;
  final String tglCheck;
  final int umur;

  MedicalRecord({
    required this.gejala,
    required this.jenisKatarak,
    required this.percentageExpertSystem,
    required this.pictureUrl,
    required this.id,
    required this.name,
    required this.tglCheck,
    required this.umur,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    DateTime birthDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
        .parse(json['tgl_lahir_pasien']);
    DateTime today = DateTime.now();
    int years = today.year - birthDate.year;
    int months = today.month - birthDate.month;
    int days = today.day - birthDate.day;
    if (months < 0 || (months == 0 && days < 0)) {
      years--;
    }

    List<String> symptomDescriptions = [
      "Penglihatan Rabun",
      "Sensitif kepada cahaya langsung",
      "Pengelihatan ganda",
      "Pengelihatan Berkabut",
      "Sakit pada mata",
      "Pengelihatan Lebih nyaman pada sore hari / lebih nyaman pada ruangan redup",
      "Terdapat lingkaran putih saat melihat ke cahaya",
      "Pengelihatan tehadap warna menurun",
      "Sering ganti ukuran kacamata",
      "Pernah cedera pada bola mata",
      "Benturan pada area sekitar mata",
      "Memiliki riwayat diabetes",
      "Penggunaan steroid jangka panjang / meminum obat yang tidak terdaftar",
      "Berusia lebih dari 50 Tahun",
      "Berusia kurang dari 50 tahun",
      "Lama kejadian keluhan, satu sampai 10 tahun",
      "Lensa keruh"
    ];

    String convertGejala(double? value) {
      if (value == null) {
        return 'null';
      } else if (value == 0.0) {
        return 'Sangat Tidak';
      } else if (value == 0.2) {
        return 'Tidak';
      } else if (value == 0.4) {
        return 'Mungkin tidak';
      } else if (value == 0.6) {
        return 'Mungkin Iya';
      } else if (value == 0.8) {
        return 'Iya';
      } else if (value == 1.0) {
        return 'Pasti Iya';
      } else {
        return 'null';
      }
    }

    String convertDeteksi(double? value) {
      if (value == 0.0) {
        return 'Normal';
      } else {
        return 'Katarak';
      }
    }

    Map<String, String?> gejala = {};
    for (var i = 0; i < symptomDescriptions.length; i++) {
      var gejalaValue = json['gejala']['g${i + 1}'];
      if (i == symptomDescriptions.length - 1) {
        gejala[symptomDescriptions[i]] = convertDeteksi(gejalaValue);
      } else {
        gejala[symptomDescriptions[i]] = convertGejala(gejalaValue);
      }
    }
    var imgUrl = json['image_url'] == null
        ? 'null'
        : json['image_url'].replaceFirst('./APIfile', '/');

    return MedicalRecord(
      gejala: gejala,
      jenisKatarak: json['jenis_katarak'],
      percentageExpertSystem: json['akurasi_cf'],
      pictureUrl: imgUrl,
      id: json['id'],
      name: json['nama_pasien'],
      tglCheck: json['tgl_cek'],
      umur: years,
    );
  }
}
