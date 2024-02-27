import 'package:dental/pages/calendar.dart';
import 'package:dental/services/appointment.service.dart';
import 'package:dental/services/details.service.dart';
import 'package:dental/services/dropdownService.dart';
import 'package:dental/services/holiday.service.dart';
import 'package:dental/services/util.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class Event {
  final String eventName;

  Event(this.eventName);
}

class AddAppointmentPage extends StatefulWidget {
  final appointment;
  const AddAppointmentPage(this.appointment, {super.key});

  @override
  State<AddAppointmentPage> createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  var showNextPage = false;
  var selectedPatient;
  var selectedDoctor;
  var selectedTreatment;
  var shiftOfDoctorList = [];
  var shiftTimeOfDoctorList = [];
  var bookedSlotsList = [];
  var selectedShiftTimeOfDoctor = '';
  var shiftSelectIndex = null;

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
  final TextEditingController doctor_name = TextEditingController();
  TimeOfDay? appointment_from;
  final TextEditingController appointment_from_time = TextEditingController();
  final TextEditingController appointment_to = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Event>> events = {};
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  String selectedValue = '';

  var patientList = [];

  var treatmentList = [];

  var monthHolidayData = [];

  var availableDoctorList = [];

  @override
  void initState() {
    super.initState();
    showNextPage = false;

    getPatientList();
    getTreatmentList();
    getMonthHolidayData();
    getEvents();
    getAvailableDoctors();
    checkHoliday();
    if (widget.appointment != null) {
      populateForm();
    }
  }

  populateForm() {
    print(widget.appointment);
    patient_name.text = widget.appointment['patient_name'];
    patient_code.text = widget.appointment['patient_code'];
    contact_no.text = widget.appointment['contact_number'];

    chief_problem.text = widget.appointment['chief_problem'];

    onTreatmentSelect({
      'name': widget.appointment['treatment_name'],
      'id': widget.appointment['treatment_id']
    });
    note.text = widget.appointment['note'] ?? '';
    print(_selectedDay);
    var modifiedDay = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(
        DateTime.parse(
            '${widget.appointment['appointment_date']} 00:00:00.000'));

    _selectedDay = DateTime.parse(modifiedDay);
    _focusedDay = DateTime.parse(modifiedDay);
  }

  getMonthHolidayData() async {
    int year = _selectedDay.year;
    int month = _selectedDay.month;
    var data = await HolidayService().getHolidayByMonth(month, year);

    if (data != null) {
      setState(() {
        monthHolidayData = data;
        getEvents();
      });
    }
  }

  getEvents() {
    this.monthHolidayData.forEach((holiday) {
      DateTime date = DateTime.parse('${holiday} 00:00:00.000Z').toUtc();
      events[date] = [Event("$holiday")];
    });
  }

  getPatientList() async {
    var data = await DropDownService().getPatientDropDownList('') ?? [];
    setState(() {
      patientList = data;
      if (widget.appointment != null) {
        patientList.forEach((patient) {
          if (patient['id'] == widget.appointment['patient_id']) {
            address.text = patient['address'];
          }
        });
      }
    });
  }

  getTreatmentList() async {
    var data = await DropDownService().getTreatmentDropDownList('') ?? [];
    setState(() {
      treatmentList = data;
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

  onPatientSelect(patient) {
    selectedPatient = patient;
    patient_name.text =
        '${selectedPatient['name']} (${selectedPatient['registration_no']})';
    patient_code.text = '${selectedPatient['registration_no']}';
    contact_no.text = '${selectedPatient['contact_number']}';
    address.text = '${selectedPatient['address']}';
  }

  onDoctorSelect(doctor) {
    selectedDoctor = doctor;
    doctor_name.text = doctor['name'];
    shiftTimeOfDoctorList = [];
    shiftOfDoctorList = [];
    bookedSlotsList = [];

    print(doctor);

    setState(() {
      if (doctor['shifts'].length > 0) {
        doctor['shifts'].forEach((var shift) {
          shiftTimeOfDoctorList.add(
              '${UtilService().timeConverter(shift['start_time'])} - ${UtilService().timeConverter(shift['end_time'])}');
          shiftOfDoctorList.add(shift);
        });
      }
    });

    checkDoctorLeave(doctor['id']);
  }

  checkDoctorLeave(id) async {
    var modifiedDay = DateFormat('yyyy-MM-dd').format(_selectedDay);

    var data = await DetailService().checkUserLeave(modifiedDay, id);

    data['messages'].forEach((message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Info: ${message['message']}!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  onTreatmentSelect(tempTreatment) async {
    treatment.text = '${tempTreatment['name']}';

    var data =
        await DetailService().getTreatmentDetailsById(tempTreatment['id']) ??
            null;
    print(data);
    if (data != null) {
      selectedTreatment = data;
      treatment_time.text = '${data['duration'].toInt()}';
      buffer_time.text = '${data['bufferTime'].toInt()}';
      total_treatment_time.text =
          '${(data['duration'] + data['bufferTime']).toInt()}';
    }
  }

  getAvailableDoctors() async {
    var modifiedDay = DateFormat('yyyy-MM-dd').format(_selectedDay);

    var data =
        await DropDownService().getAvailableDoctorByDate(modifiedDay) ?? [];

    availableDoctorList = data;
  }

  onShiftSelect(shift, index) {
    shiftSelectIndex = index;
    bookedSlotsList = [];
    setState(() {
      selectedShiftTimeOfDoctor = shift;
      shiftOfDoctorList[index]['booked_slots'].forEach((slot) {
        bookedSlotsList.add(
            '${UtilService().timeConverter(slot['start_time'])} - ${UtilService().timeConverter(slot['end_time'])}');
        // print(bookedSlotsList);
      });
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    var picked = await showTimePicker(
      context: context,
      initialTime: appointment_from ?? TimeOfDay.now(),
    );

    if (picked != null && picked != appointment_from) {
      setState(() {
        appointment_from = picked;
        appointment_from_time.text = '${picked.format(context)}';
        int? treatmentTime = int.tryParse(treatment_time.text);
        int? bufferTime = int.tryParse(buffer_time.text);

        if (treatmentTime != null && bufferTime != null) {
          var tempTime = treatmentTime + bufferTime;
          setState(() {
            TimeOfDay appointmentToTime = addMinutesToTime(picked, tempTime);
            appointment_to.text = appointmentToTime.format(context);
          });
        }
      });
    }
  }

  TimeOfDay addMinutesToTime(originalTime, minutesToAdd) {
    int totalMinutes =
        originalTime.hour * 60 + originalTime.minute + minutesToAdd;
    return TimeOfDay(
      hour: totalMinutes ~/ 60,
      minute: totalMinutes % 60,
    );
  }

  validateFirstPage() {
    if (patient_name.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient Name is required!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (chief_problem.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chief Problem is required!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (treatment.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Treatment is required!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (treatment_time.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Treatment Time is required!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (buffer_time.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Buffer Time is required!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      showNextPage = true;
    });
  }

  saveAppointment() {
    if (doctor_name.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a Doctor!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (selectedShiftTimeOfDoctor == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a Shift Time!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (appointment_from_time.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment Time is required!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    var valid = validateShiftAndBookedSlots();

    if (valid) {
      addAppointment();
    }
  }

  String convert12HourTo24Hour(String time12Hour) {
    DateFormat inputFormat = DateFormat('h:mm a', 'en_US');
    DateFormat outputFormat = DateFormat('HH:mm');
    DateTime dateTime = inputFormat.parse(time12Hour);
    return outputFormat.format(dateTime);
  }

  addAppointment() async {
    var modifiedDay = DateFormat('yyyy-MM-dd').format(_selectedDay);

    String modifiedStartTime =
        convert12HourTo24Hour(appointment_from_time.text);
    String modifiedEndTime = convert12HourTo24Hour(appointment_to.text);
    var appointmentData = {
      "patient_id": selectedPatient['id'],
      "chief_problem": chief_problem.text,
      "treatment_id": selectedTreatment['id'],
      "treatment_time": selectedTreatment['duration'],
      "buffer_time": selectedTreatment['bufferTime'],
      "note": note.text,
      "appointment_date": modifiedDay,
      "doctor_id": selectedDoctor['id'],
      "start_time": modifiedStartTime,
      "end_time": modifiedEndTime
    };

    var res = await AppointmentService().addAppointment(appointmentData);

    if (res['title'] == 'Success' && res['http_status'] == 200) {
      res['messages'].forEach((message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${message['message']}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add Appoinrment!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool validateShiftAndBookedSlots() {
    var valid = true;

    // Shift Validation
    valid = checkRange(appointment_from_time.text, selectedShiftTimeOfDoctor);
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment Time does not fall under Shift Time!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return valid;
    }
    valid = checkRange(appointment_to.text, selectedShiftTimeOfDoctor);
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment Time does not fall under Shift Time!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return valid;
    }

    // Booked Slots Validation
    var validSlot = false;
    for (String slot in bookedSlotsList) {
      validSlot = checkSlotRange(appointment_from_time.text, slot);
      if (validSlot) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please check booked slots!'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      }
      validSlot = checkSlotRange(appointment_to.text, slot);
      if (validSlot) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please check booked slots!'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      }
    }

    // break time validation

    var validBreak = false;
    var breakStartTime = convert24HourTo12Hour(
        shiftOfDoctorList[shiftSelectIndex]['break_start_time']);
    var breakEndTime = convert24HourTo12Hour(
        shiftOfDoctorList[shiftSelectIndex]['break_stop_time']);
    validBreak = checkSlotRange(
        appointment_from_time.text, '${breakStartTime} - ${breakEndTime}');
    if (validBreak) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment falls under brteak time!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    validBreak = checkSlotRange(
        appointment_to.text, '${breakStartTime} - ${breakEndTime}');
    if (validBreak) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment falls under brteak time!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return valid && !validSlot && !validBreak;
  }

  String convert24HourTo12Hour(String time24Hour) {
    DateFormat inputFormat = DateFormat('HH:mm:ss');
    DateFormat outputFormat = DateFormat('h:mm a');

    try {
      // Trim the input string to remove leading and trailing spaces
      time24Hour = time24Hour.trim();

      DateTime dateTime = inputFormat.parseStrict(time24Hour);
      return outputFormat.format(dateTime);
    } catch (e) {
      print("Error parsing time: $e");
      return "Invalid Time";
    }
  }

  checkRange(inputTime, timeRangeStr) {
    List<String> timeParts = timeRangeStr.split(" - ");
    String startTimeStr = timeParts[0];
    String endTimeStr = timeParts[1];

    // Convert input and range times to DateTime objects
    DateTime inputTimeObj = DateFormat("h:mm a").parse(inputTime);
    DateTime startTimeObj = DateFormat("h:mm a").parse(startTimeStr);
    DateTime endTimeObj = DateFormat("h:mm a").parse(endTimeStr);

    // Check if input time falls within the range
    if (inputTimeObj.isAtSameMomentAs(startTimeObj) ||
        (inputTimeObj.isAfter(startTimeObj) &&
                inputTimeObj.isAtSameMomentAs(endTimeObj) ||
            inputTimeObj.isBefore(endTimeObj))) {
      return true;
    } else {
      return false;
    }
  }

  checkSlotRange(inputTime, timeRangeStr) {
    List<String> timeParts = timeRangeStr.split(" - ");
    String startTimeStr = timeParts[0];
    String endTimeStr = timeParts[1];

    // Convert input and range times to DateTime objects
    DateTime inputTimeObj = DateFormat("h:mm a").parse(inputTime);
    DateTime startTimeObj = DateFormat("h:mm a").parse(startTimeStr);
    DateTime endTimeObj = DateFormat("h:mm a").parse(endTimeStr);

    // Check if input time falls within the range
    if ((inputTimeObj.isAfter(startTimeObj) &&
        inputTimeObj.isBefore(endTimeObj))) {
      return true;
    } else {
      return false;
    }
  }

  checkHoliday() {
    var modifiedDay = DateFormat('yyyy-MM-dd').format(_selectedDay);

    monthHolidayData.forEach((holiday) {
      if (modifiedDay == holiday) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment is set on Holiday!'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
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

                                  getMonthHolidayData();
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
                                  markerDecoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2))),
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

                                    getAvailableDoctors();
                                    checkHoliday();
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
                                controller: doctor_name,
                                suggestionsCallback: (pattern) {
                                  return availableDoctorList
                                      .where((item) => item['name']
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()))
                                      .toList();
                                },
                                builder: (context, doctor_name, focusNode) {
                                  return TextField(
                                    controller: doctor_name,
                                    focusNode: focusNode,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                    ),
                                  );
                                },
                                itemBuilder: (context, doctor) {
                                  return ListTile(
                                    title: Text('${doctor['name']}'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${doctor['qualification'] ?? ''} ${doctor['qualification'].length > 0 && doctor['specialization'].length > 0 ? '|' : ''} ${doctor['specialization'] ?? ''}'),
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
                                onSelected: (doctor) {
                                  onDoctorSelect(doctor);
                                },
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
                              Container(
                                height: 40,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (int index = 0;
                                          index < shiftTimeOfDoctorList.length;
                                          index++)
                                        GestureDetector(
                                          onTap: () {
                                            onShiftSelect(
                                                shiftTimeOfDoctorList[index],
                                                index);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                1, 0, 10, 0),
                                            padding: EdgeInsets.fromLTRB(
                                                12, 10, 12, 10),
                                            decoration: BoxDecoration(
                                              color:
                                                  selectedShiftTimeOfDoctor ==
                                                          shiftTimeOfDoctorList[
                                                              index]
                                                      ? const Color.fromARGB(
                                                          255, 154, 197, 155)
                                                      : Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                                '${shiftTimeOfDoctorList[index]}'),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            ]),
                        bookedSlotsList.length > 0
                            ? SizedBox(
                                height: 12,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        bookedSlotsList.length > 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      'Booked Slots',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 40,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for (int index = 0;
                                                index < bookedSlotsList.length;
                                                index++)
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    1, 0, 10, 0),
                                                padding: EdgeInsets.fromLTRB(
                                                    12, 10, 12, 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white70,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                    '${bookedSlotsList[index]}'),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ])
                            : SizedBox(
                                height: 0,
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
                                  child: GestureDetector(
                                    onTap: () => _selectTime(context),
                                    child: TextField(
                                      controller: appointment_from_time,
                                      enabled: false,
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
                                    controller: appointment_to,
                                    enabled: false,
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
                    GestureDetector(
                      onTap: () {
                        saveAppointment();
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(37, 94, 102, 1),
                            border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(37, 94, 102, 1)),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
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
                            child: TypeAheadField(
                              controller: treatment,
                              suggestionsCallback: (pattern) {
                                return treatmentList
                                    .where((item) => item['name']
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()))
                                    .toList();
                              },
                              builder: (context, treatment, focusNode) {
                                return TextField(
                                  controller: treatment,
                                  focusNode: focusNode,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                  ),
                                );
                              },
                              itemBuilder: (context, treatment) {
                                return ListTile(
                                  title: Text('${treatment['name']}'),
                                );
                              },
                              emptyBuilder: (context) {
                                // Customize the message when no suggestions are found
                                return Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Please type to Search'));
                              },
                              onSelected: (treatment) {
                                onTreatmentSelect(treatment);
                              },
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
                                  onChanged: (value) {
                                    if (buffer_time.text != '') {
                                      total_treatment_time.text =
                                          ((int.tryParse(treatment_time.text) ??
                                                          0)
                                                      .toDouble() +
                                                  (int.tryParse(buffer_time
                                                              .text) ??
                                                          0)
                                                      .toDouble())
                                              .toInt()
                                              .toString();
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
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
                                  onChanged: (value) {
                                    if (int.tryParse(treatment_time.text) !=
                                        null) {
                                      total_treatment_time.text =
                                          ((int.tryParse(treatment_time.text) ??
                                                          0)
                                                      .toDouble() +
                                                  (int.tryParse(buffer_time
                                                              .text) ??
                                                          0)
                                                      .toDouble())
                                              .toInt()
                                              .toString();
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
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
                              controller: total_treatment_time,
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
                        validateFirstPage();
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
