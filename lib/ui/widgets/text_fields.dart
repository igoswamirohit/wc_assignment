import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wc_assignment/utils/extensions.dart';

class CustomTextField extends StatelessWidget {
  final Widget? prefix;
  final String hintText;
  final String label;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool isNumeric;
  final bool enabled;
  final GlobalKey? formKey;

  const CustomTextField({
    Key? key,
    this.formKey,
    this.prefix,
    required this.hintText,
    required this.label,
    this.onChanged,
    this.onFieldSubmitted,
    required this.onSaved,
    this.validator,
    this.isNumeric = false,
    this.enabled = true,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formKey,
      initialValue: initialValue,
      enabled: enabled,
      keyboardType: isNumeric ? TextInputType.phone : null,
      inputFormatters: isNumeric
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : null,
      style: 16.mediumStyle.copyWith(color: Colors.black),
      maxLines: 1,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        errorMaxLines: 2,
        prefixIcon: prefix,
        label: Text(label),
        hintText: hintText,
        hintStyle: 16.semiBoldStyle.copyWith(
              color: Colors.grey,
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
    );
  }
}
