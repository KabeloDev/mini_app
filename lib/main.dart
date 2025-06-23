import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_app/home.dart';
import 'package:mini_app/app_cubit.dart';
import 'package:mini_app/mode.dart';
import 'package:mini_app/noti_service.dart';
import 'package:mini_app/notifications_cubit.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  NotiService().initNotification().then((_) {
    NotiService().showNotification(0, 'Welcome', 'Rememeber to track your mood today.');
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModeController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
    final modeController = Provider.of<ModeController>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppCubit(),
        ),
        BlocProvider(
          create: (_) => NotificationsCubit(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness : modeController.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        routerConfig: _router,
      ),
    );
  }
}

