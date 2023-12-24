import 'dart:math';

import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';

class BookView extends StatelessWidget {


  const BookView({super.key, required this.leftColumn, required this.middleColumn, required this.rightColumn});

  final Widget leftColumn;
  final Widget middleColumn;
  final Widget rightColumn;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    /*
    use sigmoid function for a smooth margin/space transitioning
     */
    final double marginWidth = mediaQuery.width * (0.02+0.045/(1+pow(2.71, -0.005*(mediaQuery.width-1150))));
    final double space = mediaQuery.width * (0.01+0.02/(1+pow(2.71, -0.005*(mediaQuery.width-1150))));

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingVeryBig),
      child: Row(

        children: [
          SizedBox(width: marginWidth),
          Expanded(child: leftColumn),
          SizedBox(width: space,),
          Container(
            width: Dimensions.lineWidth,
            height: MediaQuery.of(context).size.height*0.7,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(width: space,),
          Expanded(child: middleColumn),
          SizedBox(width: space,),
          Container(
            width: Dimensions.lineWidth,
            height: MediaQuery.of(context).size.height*0.7,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(width: space,),
          Expanded(child: rightColumn),
          SizedBox(width: marginWidth)
        ],
      ),
    );
  }
}
