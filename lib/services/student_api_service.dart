import 'dart:io';
import 'package:http/http.dart' as http;

class StudentApiService {

  Future<void> addStudent({
    required int libraryId,
    required String seatNo, // example: "SEAT12"
    required String name,
    required String phone,
    required String email,
    required String education,
    required String payMoney,
    required String totalFees,
    DateTime? birthDate,
    DateTime? payDate,
    File? studentPhoto,
    File? documentPhoto,
  }) async {

    // ✅ Convert "SEAT12" → 12 (INT)
    final int seatNumber =
    int.parse(seatNo.replaceAll(RegExp(r'[^0-9]'), ''));

    final uri = Uri.parse("http://localhost:8080/api/library/add-student");
    final request = http.MultipartRequest("POST", uri);

    request.fields.addAll({
      "libraryId": libraryId.toString(),
      "seatNo": seatNumber.toString(), // ✅ send as string
      "studentName": name,
      "phoneNumber": phone,
      "email": email,
      "education": education,
      "payMoney": payMoney,
      "totalFees": totalFees,
      "birthDate": birthDate == null
          ? ""
          : birthDate.toString().split(" ")[0],
      "payDate": payDate == null
          ? ""
          : payDate.toString().split(" ")[0],
      "uniqueStudentId": "STU${DateTime.now().millisecondsSinceEpoch}",
      "studentPresent": "YES",

    });

    // Optional student photo
    if (studentPhoto != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "studentPhoto",
          studentPhoto.path,
        ),
      );
    }

    // Optional document photo
    if (documentPhoto != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "documentPhoto",
          documentPhoto.path,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add student");
    }
  }
}
