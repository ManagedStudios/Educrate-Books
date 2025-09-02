import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  // State variable to toggle password visibility
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSmall),
      child: TextField(
        controller: widget.controller,
        // This is the key property for password fields
        obscureText: _isObscured,
        decoration: InputDecoration(
          labelText: 'Password',
          border: const OutlineInputBorder(),
          // Icon button to toggle visibility
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              // Update the state to redraw the widget
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          ),
        ),
      ),
    );
  }
}