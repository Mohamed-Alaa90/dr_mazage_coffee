import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String libelText;
  final IconData? icon;
  final bool? isPassword;
  final String? Function(String?)? validator;

  const MyTextField({
    super.key,
    required this.controller,
    required this.libelText,
    this.icon,
    this.isPassword,
    this.validator,
    required TextInputType keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ?? false,
      decoration: InputDecoration(
        labelText: libelText,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color(0XFF3b2a2a), width: 2.0),
        ),
        prefixIcon:
            icon != null ? Icon(icon, color: const Color(0XFF3b2a2a)) : null,
      ),
      style: const TextStyle(color: Colors.black),
      cursorColor: const Color(0XFF3b2a2a),
      validator: validator,
    );
  }
}
