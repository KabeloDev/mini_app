// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mini_app/stats_noti.dart';

// class AppNotification extends StatelessWidget {
//   const AppNotification({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             MaterialButton(
//               onPressed: () {
//                 context.go('/calendar');
//               },
//               child: Text('Calendar'),
//             ),
//             const SizedBox(height: 20),
//             MaterialButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (cpntext) => MyPieChart()),
//                 );
//               },
//               child: Text('Stats'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
