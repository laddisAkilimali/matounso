import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MyDropdownButtonFormField extends StatefulWidget {
  final List<String> elementListe;
  final String hint;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const MyDropdownButtonFormField({
    super.key,
    required this.elementListe,
    required this.hint,
    required this.label,
    this.validator,
    this.onSaved,
  });

  @override
  State<MyDropdownButtonFormField> createState() =>
      _MyDropdownButtonFormFieldState();
}

class _MyDropdownButtonFormFieldState extends State<MyDropdownButtonFormField> {
  String? _valeurSelectionnee;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        DropdownButtonFormField2<String>(
          value: _valeurSelectionnee,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          hint: Text(widget.hint),
          items: widget.elementListe.map((element) {
            return DropdownMenuItem<String>(
              value: element,
              child: Text(element, style: const TextStyle(fontSize: 16)),
            );
          }).toList(),
          validator: widget.validator,
          onSaved: widget.onSaved,
          onChanged: (value) => setState(() => _valeurSelectionnee = value),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(borderRadius: borderRadius),
          ),
        ),
      ],
    );
  }
}
