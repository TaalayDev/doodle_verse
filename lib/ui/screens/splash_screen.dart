import 'package:flutter/material.dart';

import '../../core/canvas/tools_manager.dart';
import '../../core/canvas/shader_manager.dart';
import '../../core.dart';
import 'demo_draw_screen.dart';

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
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const DemoDrawingScreen(),
    //   ),
    // );
  }

  void _init() async {
    await ShaderManager().loadShaders();
    await ToolsManager().loadTools();
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
