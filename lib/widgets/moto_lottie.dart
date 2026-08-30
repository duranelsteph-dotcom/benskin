import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MotoLottie extends StatelessWidget {
  final String assetPath;
  final String networkUrl;
  final double width;
  final double height;

  const MotoLottie({
    super.key,
    required this.assetPath,
    required this.networkUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
      repeat: true,
      errorBuilder: (context, error, stackTrace) {
        return Lottie.network(
          networkUrl,
          width: width,
          height: height,
          repeat: true,
        );
      },
    );
  }
}


