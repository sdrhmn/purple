// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:timely/modules/home/views/tab_buttons.dart';
// import 'package:timely/reusables.dart';

// class SignInView extends ConsumerWidget {
//   const SignInView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final providers = [EmailAuthProvider()];

//     return SignInScreen(
//       providers: providers,
//       actions: [
//         AuthStateChangeAction<SignedIn>((context, state) {
//           Navigator.of(context).pushReplacement(MaterialPageRoute(
//             builder: (context) => tabs[ref.read(tabIndexProvider)],
//           ));
//         }),
//       ],
//     );
//   }
// }
