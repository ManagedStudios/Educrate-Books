import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/settings/sync_state.dart';
import '../../../Models/settings/sync_status.dart';
import '../input/dialog_text_field.dart';
import '../input/password_text_field.dart';


class SyncForm extends StatefulWidget {

  const SyncForm({super.key});

  @override
  State<SyncForm> createState() => _SyncFormState();
}

class _SyncFormState extends State<SyncForm> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _urlController = TextEditingController();


  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncState>(
      builder: (context, syncState, child) {
        final status = syncState.status;
        String statusText;
        Color statusColor;

        switch (status.status) {
          case SyncConnectionStatus.noCredentials:
            statusText = 'No credentials';
            statusColor = Colors.grey;
            break;
          case SyncConnectionStatus.connected:
            statusText = 'Connected';
            statusColor = Colors.green;
            break;
          case SyncConnectionStatus.disconnected:
            statusText = 'Not connected: ${status.error ?? "Unknown error"}';
            statusColor = Colors.red;
            break;
          case SyncConnectionStatus.connecting:
            statusText = 'Connecting...';
            statusColor = Colors.orange;
            break;
          case SyncConnectionStatus.stopped:
            statusText = 'Sync stopped';
            statusColor = Colors.grey;
            break;
        }

        return Column(
          children: [
            Chip(
              label: Text(statusText),
              backgroundColor: statusColor,
            ),
            const SizedBox(height: 16),
            DialogTextField(
              controller: _urlController,
              onTextChanged: (_) => setState(() {}),
              hint: 'Sync URL',
              errorText: syncState.urlError,
              enabled: true,
            ),
            DialogTextField(
              controller: _usernameController,
              onTextChanged: (_) => setState(() {}),
              hint: 'Username',
              errorText: syncState.credentialsError,
              enabled: true,
            ),
            PasswordField(controller: _passwordController),
            ElevatedButton(
              onPressed: () {
                syncState.saveCredentials(
                  _urlController.text,
                  _usernameController.text,
                  _passwordController.text,
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}