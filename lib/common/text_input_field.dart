import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPass;
  final String hint;
  final TextInputType inputType;
  final IconData? suffixicon;
  final VoidCallback? sufficonpressed;
  const TextFieldInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.inputType,
    this.sufficonpressed,
    this.suffixicon,
    this.isPass = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(suffixicon),
          onPressed: sufficonpressed,
        ),
        hintText: hint,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: inputType,
      obscureText: isPass,
    );
  }
}
