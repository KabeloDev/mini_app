import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_app/noti_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () async {
            
            context.go('/notification');
            NotiService().initNotification().then((_) {
              // Delay notification by 5 seconds
              Future.delayed(Duration(seconds: 5), () {
                NotiService().showNotification(
                  1,
                  'Delayed Notification',
                  'This notification appeared after 5 seconds!',
                );
              });
            });
          },
          child: Text('Send notification'),
        ),
      ),
    );
  }
}
