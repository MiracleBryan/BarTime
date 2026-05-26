part of '../main.dart';

String dateOnlyKey(DateTime date) {
  final normalizedDate = DateTime(date.year, date.month, date.day);
  return normalizedDate.toIso8601String().split('T').first;
}

String formatDate(DateTime date) {
  return '${monthName(date.month)} ${date.day}, ${date.year}';
}

String monthTitle(DateTime date) {
  return '${monthName(date.month)} ${date.year}';
}

String monthName(int month) {
  const names = [
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
    'December',
  ];
  return names[month - 1];
}
