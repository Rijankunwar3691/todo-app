import 'package:flutter/material.dart';

void showsucessMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }