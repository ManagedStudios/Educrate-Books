import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LFGKeyboard extends StatefulWidget {
  const LFGKeyboard(
      {super.key,
      required this.changePress,
      required this.child,
      required this.focus});

  final Function(Keyboard pressed) changePress;
  final Widget child;
  final FocusNode focus;

  @override
  State<LFGKeyboard> createState() => _LFGKeyboardState();
}

class _LFGKeyboardState extends State<LFGKeyboard> {
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: widget.focus,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          //detect cmd taps on mac and windows
          if (Platform.isMacOS &&
                  event.logicalKey == LogicalKeyboardKey.metaLeft ||
              event.logicalKey == LogicalKeyboardKey.metaRight) {
            widget.changePress(Keyboard.cmd);
          } else if ((Platform.isWindows || Platform.isLinux) &&
                  event.logicalKey == LogicalKeyboardKey.controlLeft ||
              event.logicalKey == LogicalKeyboardKey.controlRight) {
            widget.changePress(Keyboard.cmd);

            //detect shift taps
          } else if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
              event.logicalKey == LogicalKeyboardKey.shiftRight) {
            widget.changePress(Keyboard.shift);
          }

          //detect when shift/cmd is not anymore pressed - or base case, nothing is pressed
        } else if (event is KeyUpEvent) {
          widget.changePress(Keyboard.nothing);
        }
      },
      child: widget.child,
    );
  }
}

enum Keyboard { shift, cmd, nothing }
