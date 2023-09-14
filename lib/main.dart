import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/common/loader.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/firebase_options.dart';
import 'package:socialmedia/provider/user_provider.dart';
import 'package:socialmedia/responsive/mobile_layout.dart';
import 'package:socialmedia/responsive/responsive_layout.dart';
import 'package:socialmedia/responsive/web_layout.dart';
import 'package:socialmedia/utils/colors.dart';

import 'features/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.getToken().then((value) {
    debugPrint("geting Token : $value ");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        title: 'iplexgram',
        debugShowCheckedModeBanner: false,
        // darkTheme: ThemeData.dark().copyWith(
        //   scaffoldBackgroundColor: mobileBgColor,
        // ),
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBgColor,
        ),

        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebscreenLayout(),
                  mobileScreenLayout: MobilescreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Loader(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
    // home: const ResponsiveLayout(
    //     webScreenLayout: WebscreenLayout(),
    //     mobileScreenLayout: MobilescreenLayout()));    //     mobileScreenLayout: MobilescreenLayout()));
  }
}
