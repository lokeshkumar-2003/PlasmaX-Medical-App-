import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/firebase_options.dart';
import 'package:quizapp/pages/donorsection/AddDonorsForm.dart';
import 'package:quizapp/pages/donorsection/AuthPage.dart';
import 'package:quizapp/pages/donorsection/DonorHomePage.dart';
import 'package:quizapp/pages/GetStarted.dart';
import 'package:quizapp/pages/OptionPage.dart';
import 'package:quizapp/pages/ReceiverHomePage.dart';
import 'package:quizapp/pages/donorsection/ProfileMainForm.dart';
import 'package:quizapp/pages/receiversection/HospitalIntakePage.dart';
import 'package:quizapp/pages/receiversection/Donorintakepage.dart';
import 'package:quizapp/pages/receiversection/ReceiverOptionPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => SafeArea(child: GetStarted()),
        "/option": (context) => OptionPage(),
        "/auth": (context) => AuthPage(),
        "/receiverhome": (context) => ReceiverHomePage(),
        "/receiverprofile": (context) => ProfileMainForm(),
        "/donorhome": (context) => DonorHomePage(),
        "/donors/add/donor": (context) => AddDonorForm(),
        "/receiver/option": (context) => Receiveroptionpage(),
        "/receiver/donor": (context) => Donorintakepage(),
        "/receiver/hospital": (context) => Hospitalintakepage()
      },
    );
  }
}

// class Main extends StatefulWidget {
//   const Main({super.key});

//   @override
//   _MainState createState() => _MainState();
// }

// class _MainState extends State<Main> {
//   String? username;
//   User? currentUser;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: "/",
//         routes: {
//           "/": (context) => AuthPage(),
//           "/home": (context) => Homepage()
//         },
//       ),
//     );
//   }
// }
