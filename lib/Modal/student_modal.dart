class StudentModal {
  int? id;
  late String name, attendance,date;

  StudentModal({
     required this.id,
    required this.name,
    required this.attendance,
    required this.date,
  });

  factory StudentModal.fromMap(Map m1) {
    return StudentModal(
      id: m1['id'],
      name: m1['name'],
      attendance: m1['attendance'],
      date: m1['date'],
    );
  }
}

Map toMap(StudentModal student) {
  return {
    'id':student.id,
    'name':student.name,
    'attendance': student.attendance,
    'date': student.date,
  };
}
