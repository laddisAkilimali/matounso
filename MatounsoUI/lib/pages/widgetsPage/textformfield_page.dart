import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? initialValue;

  const MyTextField({
    super.key,
    required this.label,
    required this.validator,
    required this.onSaved,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          initialValue: controller == null ? initialValue : null,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
          style: const TextStyle(fontSize: 14),
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }
}
