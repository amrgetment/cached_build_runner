import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

@RoutePage()
class SplashRoute extends StatelessWidget {
  const SplashRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
