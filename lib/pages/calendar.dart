import 'package:dental/components/drawer.dart';
import 'package:dental/services/appointment.service.dart';
import 'package:dental/services/calendar.service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String eventName;

  Event(this.eventName);
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var monthAppointmentData = [];
  var dayAppointmentData = [];
  var fromDate = '';
  var toDate = '';
  DateTime _selectedDay = DateTime.utc(2024, 01, 02);
  DateTime _focusedDay = DateTime.utc(2024, 01, 02);
  DateTime _lastSelectedDay = DateTime.utc(2024, 01, 02);
  Map<DateTime, List<Event>> events = {};

  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  // Map<DateTime, List<Event>> events = {
  //   DateTime.parse('2024-02-17 00:00:00.000Z').toUtc(): [
  //     Event("Meeting 1"),
  //     Event("Meeting 2")
  //   ],
  //   DateTime.parse('2024-02-18 00:00:00.000Z').toUtc(): [Event("Meeting 3")],
  // };
  TextEditingController dateInput = TextEditingController();
  @override
  void initState() {
    super.initState();
    fromDate = DateFormat('yyyy-MM-dd')
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1));

    toDate = DateFormat('yyyy-MM-dd')
        .format(DateTime(DateTime.now().year, DateTime.now().month + 1, 0));

    getMonthAppointmentData();
    getEvents();
    getAppointmentsForTheDay();
  }

  getMonthAppointmentData() async {
    var data = await CalendarService().getAppointmentData(fromDate, toDate);
    if (data != null) {
      setState(() {
        monthAppointmentData = data['content'];
        getEvents();
      });
    }
  }

  getEvents() {
    this.monthAppointmentData.forEach((appointment) {
      DateTime date =
          DateTime.parse('${appointment['appointment_date']} 00:00:00.000Z')
              .toUtc();
      events[date] = [Event("${appointment['appointment_status']}")];
    });
  }

  getAppointmentsForTheDay() async {
    var tempDay = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(_selectedDay.toString()));
    var data = await AppointmentService().getAppointmentData(tempDay) ??
        {'content': []};
    dayAppointmentData = await data['content'];
  }

  List<Event> _getEventsForDay(DateTime day) {
    // print("Events for $day: ${events[day]}");
    return events[day] ?? [];
  }

  String dateConverter(date) {
    String dateString = date;
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object as "MMM d, y" (e.g., "Jun 1, 2024")
    String formattedDate = DateFormat('MMM d, y').format(dateTime);
    return formattedDate;
  }

  String timeConverter(time) {
    // Parse the string to a DateTime object (assuming it represents a time)
    String timeString = time;
    DateTime dateTime = DateFormat('HH:mm:ss').parse(timeString);

    // Format the DateTime object as "h:mm a" (e.g., "12:42 PM")
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: Text(
          'Calendar',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(54, 135, 147, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: TableCalendar(
              eventLoader: (day) {
                return _getEventsForDay(day);
              },
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(color: Colors.white),
                selectedTextStyle: TextStyle(color: Colors.black),
                weekNumberTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                    color: Colors
                        .white70, // Set the color of the today date background
                    shape: BoxShape
                        .circle // You can use other shapes like BoxShape.rectangle
                    ),
                selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  // or use any shape you prefer
                ),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: Colors.white, // Set the color of the month text
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.white),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white)),
              selectedDayPredicate: (DateTime date) {
                return isSameDay(_selectedDay, date);
              },
              onDaySelected: (selectedDay, focusedDay) {
                getAppointmentsForTheDay();
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  print(_selectedDay);
                  print(_focusedDay);
                });
              },
            ),
          ),
          FutureBuilder<void>(
              future: getAppointmentsForTheDay(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      height: 100, child: Center(child: Text('Loading...')));
                } else {
                  // ignore: unnecessary_null_comparison
                  return dayAppointmentData.length > 0
                      ? Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                                child: Text(
                              '${dayAppointmentData.length} appointment record(s)',
                              style: TextStyle(
                                  color: Color.fromRGBO(54, 135, 147, 1),
                                  fontWeight: FontWeight.w700),
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 400,
                              child: ListView.builder(
                                  itemCount: dayAppointmentData.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        height: 120,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 0, 10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: index % 2 != 0
                                              ? Colors.white
                                              : Color.fromRGBO(
                                                  199, 233, 238, 1),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 10, 0),
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(
                                                          width: 2,
                                                          color:
                                                              Colors.white))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dayAppointmentData[index]
                                                        ['doctor_name'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Color.fromRGBO(
                                                            33, 82, 90, 1)),
                                                    softWrap: true,
                                                  ),
                                                  Text(
                                                    dateConverter(
                                                        dayAppointmentData[
                                                                index][
                                                            'appointment_date']),
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                  Text(
                                                    '${timeConverter(dayAppointmentData[index]['start_time'])} - ${timeConverter(dayAppointmentData[index]['end_time'])}',
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dayAppointmentData[index]
                                                        ['patient_name'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Color.fromRGBO(
                                                            5, 5, 5, 1)),
                                                  ),
                                                  Text(
                                                    'Problem:',
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                  Text(
                                                      dayAppointmentData[index]
                                                          ['chief_problem'],
                                                      style: TextStyle(
                                                          fontSize: 13)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ));
                                  }),
                            ),
                          ],
                        )
                      : Container(
                          height: 200,
                          child: Center(
                              child: Text("No Appointments to Display")));
                }
              })
        ],
      ),
      drawer: NavDrawer(),
    );
  }
}
