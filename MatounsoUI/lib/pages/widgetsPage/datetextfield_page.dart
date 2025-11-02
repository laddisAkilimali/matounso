import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateField extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final void Function(DateTime?)? onSaved;
  final String? hintText;

  const MyDateField({
    super.key,
    required this.label,
    this.initialDate,
    this.onSaved,
    this.hintText,
  });

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    if (_selectedDate != null) {
      _controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    final now = DateTime.now();
    final firstDate = DateTime(1900);
    var initialDate =
        _selectedDate ?? widget.initialDate ?? DateTime(now.year - 18);
    if (initialDate.isAfter(now)) {
      initialDate = now;
    }
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: now,
      locale: const Locale('fr', 'FR'),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  int? _computeAge(DateTime? date) {
    if (date == null) return null;
    final now = DateTime.now();
    var age = now.year - date.year;
    final birthdayThisYear = DateTime(now.year, date.month, date.day);
    if (birthdayThisYear.isAfter(now)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: widget.hintText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: const Icon(Icons.calendar_today),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            //fillColor: Colors.white,
            filled: true,
          ),
          onTap: () => _pickDate(context),
          validator: (value) {
            if (_selectedDate == null) return 'Veuillez choisir une date';

            final age = _computeAge(_selectedDate);
            if (age == null || age < 17 || age > 120) {
              return 'Veuillez choisir une date raisonnable';
            }

            return null;
          },
          onSaved: (_) => widget.onSaved?.call(_selectedDate),
        ),
      ],
    );
  }
}
