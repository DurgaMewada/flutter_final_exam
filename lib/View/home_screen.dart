import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_exam/View/signIn_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../Controller/auth_controller.dart';
import '../Modal/student_modal.dart';
import '../Provider/attendance_provider.dart';
import '../Services/auth_service.dart';
import 'Components/text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    var providerTrue = Provider.of<AttendanceProvider>(context);
    var providerFalse = Provider.of<AttendanceProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xff0d0603),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d0603),
        leading:  Icon(Icons.menu,color:Colors.white,),
        centerTitle: true,
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: () async {
            await AuthService.authService.signOutUser();

            User? user = AuthService.authService.getUser();
            if (user == null) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn(),));
              authController.txtEmail.clear();
              authController.txtName.clear();
              authController.txtPhone.clear();
              authController.txtPassword.clear();
            }
          }, icon: Icon(Icons.logout),color: Colors.white,),
          SizedBox(width: 10,),
          Icon(Icons.cloud_upload,color:Colors.white,)
        ],
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 650,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40),
              ),),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: providerFalse.readDataFromDatabase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<StudentModal> studentModal = providerTrue.studentList
                    .map(
                      (e) => StudentModal.fromMap(e),
                )
                    .toList();

                return ListView.builder(
                  itemCount: studentModal.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: Text('${index + 1}'),
                    title: Text(studentModal[index].name),
                    subtitle: Text(studentModal[index].attendance),
                    trailing: Text(studentModal[index].date),
                  ),
                );
              },
            ),
          ),
        )
      ])),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0d0603),
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Notes'),
              actions: [
                MyTextField(
                  label: 'Student Name ',
                  controller: providerTrue.txtname,
                ),
                SizedBox(height: 10,),
                MyTextField(
                  label: 'Attendance',
                  controller: providerTrue.txtattendance,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        DateTime dateTime = DateTime.now();
                        providerTrue.date =
                        '${dateTime.month}/ ${dateTime.day}';
                        providerFalse.addNotesDatabase(
                          providerTrue.txtname.text,
                          providerTrue.txtattendance.text,
                          providerTrue.date,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      child: Icon(Icons.add,color: Colors.white,),),
    );
  }
}
