import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'widgets/moto_lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  String _titleToShow = '';
  final String _fullTitle = 'Benskin';
  late final AnimationController _typingController;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..addListener(() {
        final int count = ((_typingController.value) * _fullTitle.length).clamp(0, _fullTitle.length).toInt();
        setState(() {
          _titleToShow = _fullTitle.substring(0, count);
        });
      })
      ..forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/consent');
    });
  }

  @override
  void dispose() {
    _typingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B5E20),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MotoLottie(
              assetPath: 'assets/lottie/moto_splash.json',
              networkUrl: 'https://assets9.lottiefiles.com/packages/lf20_2ksk7x3i.json',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 24),
            Text(
              _titleToShow,
              style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}


