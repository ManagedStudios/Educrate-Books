import 'package:flutter/material.dart';


import '../input/dialog_text_field.dart';

class SyncParent extends StatefulWidget {

  const SyncParent({super.key});

  @override
  State<SyncParent> createState() => _SyncParentState();
}

class _SyncParentState extends State<SyncParent> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DialogTextField(
          controller: _usernameController,
          onTextChanged: (_) => setState(() {}),
          hint: 'Username',
          errorText: null,
          enabled: true,
        ),
        DialogTextField(
          controller: _passwordController,
          onTextChanged: (_) => setState(() {}),
          hint: 'Password',
          errorText: null,
          enabled: true,
        ),
        ElevatedButton(
          onPressed: () => {},
          child: const Text('Save'),
        ),
      ],
    );
  }
}
