// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; 
// import 'package:yoga_centre_app/presentation/model/coursemodel.dart'; 
// import 'package:yoga_centre_app/presentation/util/Appconstatnts.dart';
// import 'package:yoga_centre_app/presentation/util/appcolor.dart'; 

// class EnrollNow extends StatefulWidget {
//   @override
//   _EnrollNowState createState() => _EnrollNowState();
// }

// class _EnrollNowState extends State<EnrollNow> {
//   List<Message> courses = []; 
//   Message? selectedCourse; 
//   String successMessage = '';
//   String errorMessage = ''; 

//   @override
//   void initState() {
//     super.initState();
    
//     courses = [
//       Message(id: 1, coursename: 'KUNDALINI AWAKENING COURSE', status: 1),
//       Message(id: 2, coursename: 'KAYAKALPA YOGA', status: 1),
//       Message(id: 3, coursename: 'INTROSPECTION (I STAGE – III STAGE)', status: 1),
//       Message(id: 4, coursename: 'BRAHMAGNANAM COURSE [DIVINE REALISATION COURSE]', status: 1),
//     ];
    
  
//   }

//   Future<void> enrollCourse() async {
//     if (selectedCourse != null) {
     
//       final response = await http.post(
//            Uri.parse('http://192.168.29.121:3000/yogaapp/storeenroll'),
//             // Uri.parse(AppConstants.LIVE_URL+AppConstants.storeEnroll),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'id': selectedCourse!.id,
//           'coursename': selectedCourse!.coursename, 
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status']) {
//           setState(() {
//             successMessage = 'Successfully enrolled in ${selectedCourse!.coursename}!';
//             errorMessage = ''; 
//           });
//         } else {
//           setState(() {
//             errorMessage = 'Enrollment failed: ${data['message']}';
//             successMessage = ''; 
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = 'Error occurred: ${response.reasonPhrase}';
//           successMessage = ''; 
//         });
//       }
//     } else {
//       setState(() {
//         successMessage = '';
//         errorMessage = 'Please select a course to enroll!';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.primary,
//         title: Text('Enroll Now'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
           
//             DropdownButton<Message>(
//               hint: Text('Select a Course'),
//               value: selectedCourse,
//               isExpanded: true,
//               items: courses.map((Message course) {
//                 return DropdownMenuItem<Message>(
//                   value: course,
//                   child: Text(course.coursename ?? ''),
//                 );
//               }).toList(),
//               onChanged: (Message? newValue) {
//                 setState(() {
//                   selectedCourse = newValue; 
//                   successMessage = ''; 
//                   errorMessage = ''; 
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: enrollCourse,
//               child: Text('Enroll', style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColor.primary,
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               successMessage,
//               style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               errorMessage,
//               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
