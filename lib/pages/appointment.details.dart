import 'package:dental/components/drawer.dart';
import 'package:dental/services/util.services.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsPage extends StatefulWidget {
  final appointment;
  const AppointmentDetailsPage(this.appointment, {super.key});

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  @override
  void initState() {
    super.initState();

    print(widget.appointment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: const Text(
          'Appointment Details',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Row(
            children: [
              Icon(
                Icons.image,
                size: 40,
              ),
              SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.appointment['title']} ${widget.appointment['doctor_name']}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      '${widget.appointment['qualification']} | - ${widget.appointment['specialization']}',
                      style: TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Appointment No.',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text(widget.appointment['system_appointment_no'],
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Date',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text(widget.appointment['appointment_date'],
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Time',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text(
                        '${UtilService().timeConverter(widget.appointment['start_time'])} - ${UtilService().timeConverter(widget.appointment['end_time'])}',
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Patient Name',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text(widget.appointment['patient_name'],
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Patient Code',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text(widget.appointment['patient_code'],
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Contact No.',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('-', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Address',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('-', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Chief Problem',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text(widget.appointment['chief_problem'],
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Treatment',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text(widget.appointment['treatment_name'],
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Treatment Time',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('${widget.appointment['treatment_time']} min',
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Buffer Time',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('${widget.appointment['buffer_time']} min',
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Note',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text(widget.appointment['note'] ?? '-',
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Status',
                    style: TextStyle(fontSize: 13),
                  )),
                  widget.appointment['appointment_status'] == 'Booked'
                      ? Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(117, 255, 156, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Center(
                                    child: Text('Booked',
                                        style: TextStyle(fontSize: 13)))),
                          ),
                        )
                      : widget.appointment['appointment_status'] == 'Cancelled'
                          ? Expanded(
                              child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                      child: Text('Cancelled',
                                          style: TextStyle(fontSize: 13)))),
                            ))
                          : widget.appointment['appointment_status'] ==
                                  'Reschedule'
                              ? Expanded(
                                  child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      width: 95,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(117, 255, 156, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Center(
                                          child: Text('Rescheduled',
                                              style: TextStyle(fontSize: 13)))),
                                ))
                              : Expanded(
                                  child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(226, 232, 240, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Center(
                                          child: Text('Completed',
                                              style: TextStyle(fontSize: 13)))),
                                ))
                ],
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
          decoration: BoxDecoration(color: Color.fromRGBO(238, 248, 239, 1)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Created By',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Created Date',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Text(
                'Cancel Appt',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Color.fromRGBO(37, 94, 102, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Text(
                'Re-Schedule',
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(37, 94, 102, 1)),
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
                'Complete',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        )
      ]),
      drawer: NavDrawer(),
    );
  }
}
