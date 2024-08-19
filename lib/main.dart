import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qms_application/common/common.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:d_session/d_session.dart';
import 'package:qms_application/presentation/pages/pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        primaryColor: AppColor.blueColor1,
        colorScheme: ColorScheme.light(
          primary: AppColor.blueColor1,
          secondary: AppColor.backgroundLogo
        ),
        scaffoldBackgroundColor: AppColor.scaffold,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          surfaceTintColor: AppColor.blueColor1,
          backgroundColor: AppColor.blueColor1,
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ), 
        dialogTheme: const DialogTheme(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
        )
      ),
      initialRoute: AppRoute.dashboard,
      routes: {
        AppRoute.dashboard: (context) {
            return FutureBuilder(
              future: DSession.getUser(),
              builder: (context, snapshot) {
                if (snapshot.data == null) return const LoginPage(); //Login
                return const LoginPage(); 
              },
            );
          },
      },
    );
  }
}
