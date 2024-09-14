import 'package:flutter/material.dart';

import '../../core/canvas/shader_manager.dart';
import '../../core.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  void _navigateToNextScreen() {
    const MainRoute().go(context);
  }

  void _init() async {
    await ShaderManager().loadShaders();
    Future.delayed(const Duration(seconds: 2), _navigateToNextScreen);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
