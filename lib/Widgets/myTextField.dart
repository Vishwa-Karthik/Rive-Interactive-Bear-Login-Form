import 'package:flutter/material.dart';
import 'package:interactive_ui/Utils/colors.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    required this.suffixIcon,
    this.onTap,
    this.onChanged,
  });

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final IconButton suffixIcon;
  final Function()? onTap;
  final Function()? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onTap: onTap,
        //onChanged: onChanged,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: kTextBgColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: kSecondaryColor,
            ),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.black,
            letterSpacing: 3,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
