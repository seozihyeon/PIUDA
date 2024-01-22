import 'package:flutter/material.dart';

class Book{
  final String imageUrl;
  final String bookTitle;
  final String author;
  final String library;
  final String publisher;
  final String location;
  final bool loanstatus;

  Book(
    this.imageUrl,
    this.bookTitle,
    this.author,
    this.library,
    this.publisher,
    this.location,
    this.loanstatus,
  );

}