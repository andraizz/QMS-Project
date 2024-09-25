part of 'pages.dart';

class EnvironmentInstallationPage extends StatefulWidget {
  const EnvironmentInstallationPage({super.key});

  @override
  State<EnvironmentInstallationPage> createState() =>
      _EnvironmentInstallationPageState();
}

class _EnvironmentInstallationPageState
    extends State<EnvironmentInstallationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.secondary('Detail', context),
      body: const Center(
        child: Text('Environment Detail Installation'),
      ),
    );
  }
}
