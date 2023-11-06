import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {required this.label, required this.controller, super.key});
  final String label;
  final TextEditingController controller;
  InputDecoration inputDecoration(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child:
          TextField(decoration: inputDecoration(label), controller: controller),
    );
  }
}
