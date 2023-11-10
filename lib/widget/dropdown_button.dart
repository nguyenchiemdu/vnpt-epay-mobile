import 'package:flutter/material.dart';

class AppDropdownButton<T> extends StatefulWidget {
  const AppDropdownButton(
      {required this.items,
      this.initValue,
      this.onChanged,
      this.textBuilder,
      this.hint,
      super.key});
  final List<T> items;
  final T? initValue;
  final String? hint;
  final Function(T?)? onChanged;
  final String Function(T)? textBuilder;
  @override
  State<AppDropdownButton<T>> createState() => _AppDropdownButtonState<T>();
}

class _AppDropdownButtonState<T> extends State<AppDropdownButton<T>> {
  late T? dropdownValue;
  @override
  void initState() {
    dropdownValue = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 8),
      child: DropdownButton<T>(
        isExpanded: true,
        hint: Text(widget.hint ?? ''),
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        underline: Container(
          height: 2,
        ),
        onChanged: (T? value) {
          setState(() {
            dropdownValue = value;
          });
          widget.onChanged?.call(value);
        },
        items: widget.items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              widget.textBuilder?.call(value) ?? value.toString(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
