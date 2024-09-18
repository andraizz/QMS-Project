import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qms_application/common/common.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qms_application/data/source/sources.dart';
import 'package:qms_application/presentation/bloc/category_installation/category_installation_bloc.dart';
import 'package:qms_application/presentation/bloc/installation/installation_bloc.dart';
import 'package:qms_application/presentation/bloc/ticket_by_user/ticket_by_user_bloc.dart';
import 'package:qms_application/presentation/bloc/ticket_detail/ticket_detail_bloc.dart';
// import 'package:qms_application/presentation/bloc/ticket_detail/ticket_detail_bloc.dart';
// import 'package:d_session/d_session.dart';
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
    final categoryInstallationSource = CategoryInstallationSource();
    final installationSource = InstallationSource();
    final ticketByUserSource = TicketByUserSource();
    final ticketDetailSource = TicketDetailSource();
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryInstallationBloc>(
          create: (context) =>
              CategoryInstallationBloc(categoryInstallationSource),
        ),
        BlocProvider<InstallationBloc>(
          create: (context) => InstallationBloc(installationSource),
        ),
        BlocProvider<TicketByUserBloc>(
          create: (context) => TicketByUserBloc(ticketByUserSource),
        ),
        BlocProvider<TicketDetailBloc>(
          create: (context) => TicketDetailBloc(ticketDetailSource: ticketDetailSource),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true).copyWith(
            primaryColor: AppColor.blueColor1,
            colorScheme: ColorScheme.light(
                primary: AppColor.blueColor1,
                secondary: AppColor.backgroundLogo),
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
            )),
        initialRoute: AppRoute.login,
        routes: {
          // AppRoute.dashboard: (context) {
          //     return FutureBuilder(
          //       future: DSession.getUser(),
          //       builder: (context, snapshot) {
          //         if (snapshot.data == null) return const LoginPage(); //Login
          //         return const LoginPage();
          //       },
          //     );
          //   },
          AppRoute.login: (context) => const LoginPage(),
          AppRoute.dashboard: (context) => const MainPage(),
          AppRoute.listInstallation: (context) => const ListInstallationPage(),
          AppRoute.formInstallation: (context) => const FormInstallationPage(),
          AppRoute.historyInstallation: (context) =>
              const InstallationHistory(),
          AppRoute.detailHistoryInstallation: (context) =>
              const DetailHistoryInstallationPage(),
          AppRoute.summaryInstallation: (context) =>
              const SummaryInstallationPage(),
          AppRoute.detailStepInstallation: (context) =>
              const DetailStepInstallationPage(),
        },
      ),
    );
  }
}
