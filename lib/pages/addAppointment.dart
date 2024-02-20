import 'package:dental/pages/calendar.dart';
import 'package:dental/services/dropdownService.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddAppointmentPage extends StatefulWidget {
  const AddAppointmentPage({super.key});

  @override
  State<AddAppointmentPage> createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  var showNextPage = false;
  var selectedPatient;
  final TextEditingController patient_name = TextEditingController();
  final TextEditingController patient_code = TextEditingController();
  final TextEditingController contact_no = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController chief_problem = TextEditingController();
  final TextEditingController treatment = TextEditingController();
  final TextEditingController treatment_time = TextEditingController();
  final TextEditingController buffer_time = TextEditingController();
  final TextEditingController total_treatment_time = TextEditingController();
  final TextEditingController note = TextEditingController();
  final TextEditingController appointment_from = TextEditingController();
  final TextEditingController appointment_to = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Event>> events = {};
  String selectedValue = '';

  // patient name
  var patientList = [];
  // patient name end

  @override
  void initState() {
    super.initState();
    showNextPage = false;

    getPatientList();
  }

  getPatientList() async {
    var data = await DropDownService().getPatientDropDownList('') ?? [];
    setState(() {
      patientList = data;
      // print(patientList);
    });
  }

  goToCalendarPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CalendarPage()),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  dropDownChange(selectedValue) {
    // print(selectedValue);
  }

  onPatientSelect(patient) {
    print(patient);
    selectedPatient = patient;
    patient_name.text =
        '${selectedPatient['name']} (${selectedPatient['registration_no']})';
    print('${selectedPatient['registration_no']}');
    patient_code.text = '${selectedPatient['registration_no']}';
    contact_no.text = '${selectedPatient['contact_number']}';
    address.text = '${selectedPatient['address']}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: Text(
          'Appointment Add',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: showNextPage
          ? ListView(
              children: [
                Container(
                    color: Color.fromRGBO(249, 249, 250, 1),
                    padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calendar',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              TableCalendar(
                                onPageChanged: (focusedDay) async {
                                  _focusedDay = focusedDay;
                                  _selectedDay = focusedDay;

                                  // getMonthAppointmentData();
                                },
                                eventLoader: (day) {
                                  return _getEventsForDay(day);
                                },
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                focusedDay: _focusedDay,
                                headerStyle: HeaderStyle(
                                  formatButtonVisible: false,
                                ),
                                calendarStyle: CalendarStyle(
                                  selectedDecoration: BoxDecoration(
                                    color: Color.fromRGBO(54, 135, 147, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  todayDecoration: BoxDecoration(
                                      color: Color.fromRGBO(54, 135, 147,
                                          0.6), // Set the color of the today date background
                                      shape: BoxShape
                                          .circle // You can use other shapes like BoxShape.rectangle
                                      ),
                                ),
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                  });
                                },
                                selectedDayPredicate: (DateTime date) {
                                  return isSameDay(_selectedDay, date);
                                },
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(12, 48, 12, 48),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  54, 135, 147, 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2))),
                                          height: 10,
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('Selected Date')
                                      ],
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2))),
                                          height: 10,
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Holidays')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Available Doctor',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    items: const [
                                      DropdownMenuItem(
                                        child: Text('1'),
                                        value: "1",
                                      ),
                                      DropdownMenuItem(
                                        child: Text('2'),
                                        value: "2",
                                      ),
                                    ],
                                    onChanged: dropDownChange,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shift Time of Doctor',
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(12, 10, 12, 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Text('08:00 AM - 11:30 AM'),
                                  )
                                ],
                              )
                            ]),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Appointment Time From',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: appointment_from,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            SizedBox(
                              width: 24,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'To',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: contact_no,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Color.fromRGBO(199, 233, 238, 1),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => goToCalendarPage(),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(37, 94, 102, 1)),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(37, 94, 102, 1)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(37, 94, 102, 1),
                          border: Border.all(
                              width: 1, color: Color.fromRGBO(37, 94, 102, 1)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            )
          : ListView(
              children: [
                SizedBox(
                  height: 12,
                ),
                Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(249, 249, 250, 1)),
                  padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Patient Name*',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TypeAheadField(
                              controller: patient_name,
                              suggestionsCallback: (pattern) {
                                return patientList
                                    .where((item) => item['name']
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()))
                                    .toList();
                              },
                              builder: (context, patient_name, focusNode) {
                                return TextField(
                                  controller: patient_name,
                                  focusNode: focusNode,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                  ),
                                );
                              },
                              itemBuilder: (context, patient) {
                                return ListTile(
                                  title: Text(
                                      '${patient['name']} (${patient['registration_no']})'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${patient['contact_number']}'),
                                      Text('${patient['address']}'),
                                    ],
                                  ),
                                );
                              },
                              emptyBuilder: (context) {
                                // Customize the message when no suggestions are found
                                return Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Please type to Search'));
                              },
                              onSelected: (patient) {
                                onPatientSelect(patient);
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Patient Code',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: patient_code,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color.fromRGBO(199, 233, 238, 1),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 0, 12, 0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                            width: 24,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact No.',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: contact_no,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color.fromRGBO(199, 233, 238, 1),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 0, 12, 0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: address,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(199, 233, 238, 1),
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chief Problem*',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: chief_problem,
                              maxLines: 5,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                              obscureText: false,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Treatment*',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: treatment,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Treatment Time*',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: treatment_time,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 0, 12, 0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                            width: 24,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Buffer Time*',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: buffer_time,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 0, 12, 0),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Treatment Time',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: address,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(199, 233, 238, 1),
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: note,
                              maxLines: 5,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                              obscureText: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => goToCalendarPage(),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(37, 94, 102, 1)),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(37, 94, 102, 1)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showNextPage = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(37, 94, 102, 1)),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(37, 94, 102, 1)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
    );
  }
}
