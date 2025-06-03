import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_app/home.dart';
import 'package:mini_app/noti_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

   

  NotiService().initNotification().then((_) {
    NotiService().showNotification(0, 'Welcome', 'Rememeber to track your mood today.');
  });
  runApp(const MyApp());
}

final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        ), 
      // GoRoute(
      //   path: '/notification',
      //   builder: (context, state) => const AppNotification()
      // ),
      // GoRoute(
      //   path: '/calendar',
      //   builder: (context, state) => const CalendarScreen(moodEntries: [],)
      // )
    ]
  );


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}

