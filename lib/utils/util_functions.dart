import 'package:flutter/material.dart';

//snakbar

showSnackBar(BuildContext context, String res) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(res),
    ),
  );
}
