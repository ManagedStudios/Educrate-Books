
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:flutter/material.dart';

class NavigationButton extends StatefulWidget {
   const NavigationButton({super.key, required this.isClicked, required this.onClickAction, required this.text});

  final bool isClicked;
  final Function onClickAction;
  final String text;

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> with SingleTickerProviderStateMixin { //SingleTickerProviderStateMixin handles animations
  late AnimationController _controller;
  late Animation _widthAnimation;
  late Animation _backgroundAnimation;
  late Animation _textAnimation;

  /*
  initialize the animation controller and the animations
   */
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _widthAnimation = Tween<double>(begin: 128, end:224).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack));
    _backgroundAnimation = ColorTween(begin: Colors.transparent, end: lightColorScheme.primary).animate(_controller);
    _textAnimation = ColorTween(begin: lightColorScheme.onBackground, end:lightColorScheme.onPrimary).animate(_controller);
    _controller.addListener(() { //updates the UI appropriately with the listener
      setState(() {});
    });
    if(widget.isClicked) _controller.forward(); //start the animation on start if button is clicked
  }

  /*
  Use didUpdateWidget to detect configuration/argument changes (e.g. isClicked).
  Process the changes to start the animation if button turned from not clicked to clicked
  or reverse the animation if the way around applies.
   */
  @override
  void didUpdateWidget(NavigationButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isClicked != oldWidget.isClicked) {
      if (widget.isClicked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: () => widget.onClickAction(),
    style: ButtonStyle(
      fixedSize: MaterialStatePropertyAll(Size.fromWidth(_widthAnimation.value)),
      backgroundColor: MaterialStatePropertyAll(_backgroundAnimation.value),
      side: MaterialStatePropertyAll(BorderSide(width: widget.isClicked?0:1,
          color: Theme.of(context).colorScheme.outline)
        )
      ),
        child: Text(widget.text, style: TextStyle(color: _textAnimation.value),),
    );
  }
}
