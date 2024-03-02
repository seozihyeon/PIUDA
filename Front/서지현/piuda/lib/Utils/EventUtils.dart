import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Event {
  final int id;
  final String name;
  final String library;
  final DateTime date;

  Event({required this.id, required this.name, required this.library, required this.date});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['event_id'],
      name: json['event_name'],
      library: json['event_library'],
      date: DateTime.parse(json['event_date']),
    );
  }
}





