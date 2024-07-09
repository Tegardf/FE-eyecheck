class ApiEndPoints {
  static const String baseUrl = 'http://3.0.213.129:8000/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = 'auth/register';
  final String loginEmail = 'auth/login';
  final String userDokterData = 'dokter/profil';
  final String addDataDokter = 'dokter/new_rekaman';
  final String userPasienData = 'pasien/profil';
  final String addDataPasien = 'pasien/new_rekaman';
  final String checkRole = 'auth/check_role';
  final String imgURl = 'image';
  final String upImg = 'deteksi/upload';
  final String deteksi = 'deteksi/svm';
  final String allRekamanDokter = 'dokter/all_rekaman';
  final String allRekamanPasien = 'pasien/all_rekaman';
  final String rekamanDokter = 'dokter/rekaman';
  final String rekamanPasien = 'pasien/rekaman';
  final String klasifikasi = 'klasifikasi/cf';
}
