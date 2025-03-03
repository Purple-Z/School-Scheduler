import 'package:flutter/material.dart';

Future<DateTime?> selectDate(BuildContext context, DateTime initialDate, {DateTime? firstDate = null, DateTime? lastDate = null}) async {
  if (firstDate == null) {
    firstDate = DateTime.now();
  }

  if (lastDate == null) {
    lastDate = DateTime(2100);
  }

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );


  if (pickedDate != null) {
    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      initialDate.hour,
      initialDate.minute,
    );
  }

  return null;
}

Future<DateTime?> selectTime(BuildContext context, DateTime initialDate) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );

  if (pickedTime != null) {
    return DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  return null;
}

String getTimePrintable(DateTime currTime){
  String out = '';
  out += currTime.hour.toString();
  out += ':';
  if (currTime.minute < 10) {
    out += '0';
  }
  out += currTime.minute.toString();

  return out;
}