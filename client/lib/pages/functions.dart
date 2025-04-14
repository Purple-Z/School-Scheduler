import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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

String getDatePrintable(DateTime currTime, BuildContext context){
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final currDate = DateTime(currTime.year, currTime.month, currTime.day);

  final difference = currDate.difference(today).inDays;

  if (difference == 0) {
    return AppLocalizations.of(context)!.today;
  } else if (difference == -1) {
    return AppLocalizations.of(context)!.yesterday;
  } else if (difference == 1) {
    return AppLocalizations.of(context)!.tomorrow;
  } else {
    final day = currTime.day.toString().padLeft(2, '0');
    final month = currTime.month.toString().padLeft(2, '0');
    final year = currTime.year.toString();
    return '$day/$month/$year';
  }
}