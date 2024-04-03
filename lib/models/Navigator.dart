import 'package:flutter/material.dart';

class NavigatorModel {
  String label;
  IconData icon;
  Widget page;

  NavigatorModel({required this.label, required this.page, required this.icon});
}
