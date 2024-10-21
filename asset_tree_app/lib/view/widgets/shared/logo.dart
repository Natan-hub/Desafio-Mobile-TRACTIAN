import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double? tamanhoWidth;

  const Logo(this.tamanhoWidth, {super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      alignment: Alignment.center,
      'assets/images/logo.png',
      // height: (MediaQuery.of(context).size.height * tamanhoWidth!) / 1.15,
      height: (MediaQuery.of(context).size.height * tamanhoWidth!) * 0.85,
    );
  }
}
