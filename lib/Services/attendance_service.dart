import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceServices {
  AttendanceServices._();

  static AttendanceServices attendanceServices = AttendanceServices._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFireStore(
      int id, String name, String attendance, String date) async {
    await _firestore.collection("students").doc(id.toString()).set({
      'id': id,
      'name': name,
      'attendance' : attendance,
      'date': date,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readFromFireStore() {
    return _firestore.collection("students").snapshots();
  }

  Future<void> deleteFromFireStore(int id) async {
    await _firestore.collection("students").doc(id.toString()).delete();
  }

  Future<void> updateInFireStore(int id, String name, String attendance, String date) async {
    await _firestore.collection("students").doc(id.toString()).update({
      'id': id,
      'name': name,
      'attendance' : attendance,
      'date': date,
    });
  }
}
