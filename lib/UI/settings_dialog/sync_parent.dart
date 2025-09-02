import 'package:buecherteam_2023_desktop/Models/settings/sync_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/sync_status.dart';
import 'package:buecherteam_2023_desktop/UI/input/dialog_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SyncParent extends StatefulWidget {
  const SyncParent({super.key});

  @override
  State<SyncParent> createState() => _SyncParentState();
}

class _SyncParentState extends State<SyncParent> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _urlController = TextEditingController();

    // Load the current details into the text fields
    final syncState = Provider.of<SyncState>(context, listen: false);
    syncState.getSyncDetails().then((details) {
      _usernameController.text = details['username'] ?? '';
      _passwordController.text = details['password'] ?? '';
      _urlController.text = details['url'] ?? '';
    });
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
              errorText: null,
              enabled: true,
            ),
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
              onPressed: () {
                syncState.saveCredentials(
                  _usernameController.text,
                  _passwordController.text,
                  _urlController.text,
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
