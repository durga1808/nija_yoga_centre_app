import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:yoga_centre_app/data/api_service.dart';
import 'dart:convert';

import 'package:yoga_centre_app/presentation/model/coursemodel.dart';
import 'package:yoga_centre_app/presentation/model/myscoremode.dart';
import 'package:yoga_centre_app/presentation/util/app_util.dart';
import 'package:yoga_centre_app/presentation/util/appcolor.dart';
import 'package:yoga_centre_app/presentation/util/pref.dart';
class Myreports extends StatefulWidget {
  const Myreports({super.key});

  @override
  _MyReportsState createState() => _MyReportsState();
}

class _MyReportsState extends State<Myreports> {
  List<String> courselist = [];
  bool _isLoading = false;
  String? _selectedMonth;
  String? _selectedCoursename;
  final dropDownKey = GlobalKey<DropdownSearchState>();
  MyScroreModel model = MyScroreModel();
  var _selectedmonthId;
  CourseModel courseModel = CourseModel();
  String altercourseid = "";
  String altercoursename = "";
  List<String> months = [];
  @override
  void initState() {
    months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    getcoursemaster();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
      ),
      body: !_isLoading
          ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                           // ),
                  AppUtils.buildNormalText(text: "Choose Course",fontSize: 15),
                  SizedBox(height: 5,),
                  DropdownSearch<String>(
                    key: dropDownKey,
                    items: courselist,
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      showSelectedItems: true,
                    ),
                    onChanged: (value) {
                      for (int kk = 0; kk < courseModel.message!.length; kk++) {
                        if (courseModel.message![kk].coursename.toString() ==
                            value) {
                          altercourseid =
                              courseModel.message![kk].id.toString();
                          altercoursename =
                              courseModel.message![kk].coursename.toString();
                        }
                      }
                    },
                    selectedItem: altercoursename,
                  ),
                  SizedBox(height: 5,),
                  AppUtils.buildNormalText(text: "Choose Month",fontSize: 15),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text('Select Month'),
                              value: _selectedMonth,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMonth = newValue;
                                  if (_selectedMonth == "January") {
                                    _selectedmonthId = 1;
                                  }
                                  if (_selectedMonth == "Febrauary") {
                                    _selectedmonthId = 2;
                                  }
                                  if (_selectedMonth == "March") {
                                    _selectedmonthId = 3;
                                  }
                                  if (_selectedMonth == "April") {
                                    _selectedmonthId = 4;
                                  }
                                  if (_selectedMonth == "May") {
                                    _selectedmonthId = 5;
                                  }
                                  if (_selectedMonth == "June") {
                                    _selectedmonthId = 6;
                                  }
                                  if (_selectedMonth == "July") {
                                    _selectedmonthId = 7;
                                  }
                                  if (_selectedMonth == "August") {
                                    _selectedmonthId = 8;
                                  }
                                  if (_selectedMonth == "September") {
                                    _selectedmonthId = 9;
                                  }
                                  if (_selectedMonth == "October") {
                                    _selectedmonthId = 10;
                                  }
                                  if (_selectedMonth == "November") {
                                    _selectedmonthId = 11;
                                  }
                                  if (_selectedMonth == "December") {
                                    _selectedmonthId = 12;
                                  }
                                });
                                print(_selectedmonthId);
                              },
                              items: months.map<DropdownMenuItem<String>>(
                                  (String month) {
                                return DropdownMenuItem<String>(
                                  value: month,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(month),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        color: AppColor.primary,
                        onPressed: () {
                          if (altercourseid.isEmpty) {
                          } else if (_selectedmonthId == 0) {
                          } else {
                            getlist(altercourseid, _selectedmonthId);
                          }
                        },
                      ),
                    ],
                  ),
                  Expanded(
                      child: model.message != null || model.message!.isNotEmpty
                          ? ListView.builder(
                              itemCount: model.message!.length,
                              itemBuilder: (context, index) {
                                final report = model.message![index];
                                final date = report.currentdate.toString();
                                return Card(
                                  margin: const EdgeInsets.all(16.0),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Course: ${report.coursename}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Date: $date',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'No.Occurrence: ${report.occurance}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                         Text(
                                          '${report.remarks}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(child: Text('No reports found.'))),
                ],
              ),
          )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void getcoursemaster() async {
    var body = {"createdBy": Prefs.getID("UserID")};
    setState(() {
      _isLoading = true;
    });

    Apiservice.getenrollmaster(body).then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == true) {
          courseModel = CourseModel.fromJson(jsonDecode(response.body));
          print(jsonDecode(response.body));
          courselist.clear();

          for (int k = 0; k < courseModel.message!.length; k++) {
            courselist.add(courseModel.message![k].coursename.toString());
          }
          print(courselist.length);
          _selectedmonthId = DateFormat.M().format(DateTime.now());
          getlist(1, _selectedmonthId);
        } else {
          AppUtils.showSingleDialogPopup(context,
              jsonDecode(response.body)['message'].toString(), "Ok", exitpopup);
        }
      } else {
        AppUtils.showSingleDialogPopup(
            context, response.reasonPhrase, "Ok", exitpopup);
      }
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
    });
  }

  void getlist(courseid, monthid) async {
    var body = {
      "createdBy": Prefs.getID("UserID"),
      "courseId": courseid,
      "date": monthid
    };
    print(jsonEncode(body));
    setState(() {
      _isLoading = true;
    });

    Apiservice.getscrorelist(body).then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == true) {
          model = MyScroreModel.fromJson(jsonDecode(response.body));
        } else {
          model.message = [];
          setState(() {});
        }
      } else {
        AppUtils.showSingleDialogPopup(
            context, response.reasonPhrase, "Ok", exitpopup);
      }
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", exitpopup);
    });
  }

  void exitpopup() {
    AppUtils.pop(context);
  }
}
