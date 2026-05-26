part of '../main.dart';

String? requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required';
  }
  return null;
}

List<String> linesFrom(String value) {
  return value
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
}

List<Widget> numberedTiles(List<String> lines) {
  return lines.indexed
      .map(
        (entry) => ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 14,
            child: Text('${entry.$1 + 1}'),
          ),
          title: Text(entry.$2),
        ),
      )
      .toList();
}
