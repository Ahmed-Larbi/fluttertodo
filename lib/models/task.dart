import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Task {
  final int? id;
  final String? title;
  final String description;
  Task({
    this.id,
    this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
