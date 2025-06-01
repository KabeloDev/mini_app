import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNotification extends StatelessWidget {
  const AppNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            context.go('/calendar');
          },
          child: Text('Calendar'),
        ),
      ),
    );
  }

}