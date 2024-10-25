import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../Helper/sql_helper.dart';
import '../Modal/student_modal.dart';
import '../Services/attendance_service.dart';

class AttendanceProvider extends ChangeNotifier {
  List studentList = [];
  List<StudentModal> studentCloudList = [];
  var txtname = TextEditingController();
  var txtattendance = TextEditingController();
  String date = '';

  Future<void> initDatabase() async {
    await DatabaseHelper.databaseHelper.initDatabase();
  }

  // Sync Firestore data to local SQLite with update or insert logic
  Future<void> syncCloudToLocal() async {
    try {
      final snapshot =
          await AttendanceServices.attendanceServices.readFromFireStore().first;
      final cloudNotes = snapshot.docs.map((doc) {
        final data = doc.data();
        return StudentModal(
          id: int.parse(data['id'].toString()),
          name: data['name'],
          date: data['date'],
          attendance: data['attendance'],
        );
      }).toList();

      await readDataFromDatabase();
      notifyListeners();
    } catch (e) {
      debugPrint("Error syncing data: $e");
    }
  }

  Future<void> addNotesDatabase(
      String name, String attendance, String date) async {
    await DatabaseHelper.databaseHelper.addStudent(
      name,
      attendance,
      date,

    );
    toMap(
      StudentModal( name: name, attendance: attendance, date: date,id:0)
    );

    readDataFromDatabase();
    clearAllVar();
    notifyListeners();
  }

  Future<void> addNoteFireStore(StudentModal data) async {
    await AttendanceServices.attendanceServices.addToFireStore(
      data.id!,
      data.name,
      data.date,
      data.attendance

    );
  }

  Future<void> updateDataFromFirestore( StudentModal data) async {
    await AttendanceServices.attendanceServices.updateInFireStore(
        data.id!,
        data.name,
        data.date,
        data.attendance
    );
  }

  Future<void> deleteDataFromFireStore(int id) async {
    await AttendanceServices.attendanceServices.deleteFromFireStore(id);
  }

  void clearAllVar() {
    txtname.clear();
    txtattendance.clear();
    date = '';
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readDataFromFireStore() {
    return AttendanceServices.attendanceServices.readFromFireStore();
  }

  Future<List<Map<String, Object?>>> readDataFromDatabase() async {
    return studentList = await DatabaseHelper.databaseHelper.readAll();
  }

  Future<void> updateNoteInDatabase(int id, String name, String attendance,
      String date) async {
    await DatabaseHelper.databaseHelper.update(
      id,
     attendance,
      name,
      date,

    );
    clearAllVar();
    notifyListeners();
  }

  Future<void> deleteNoteInDatabase(int id) async {
    await DatabaseHelper.databaseHelper.delete(id);
    notifyListeners();
  }

  AttendanceProvider () {
    initDatabase();
  }
}
