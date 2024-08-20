part of 'pages.dart';

class InstallationHistory extends StatefulWidget {
  const InstallationHistory({super.key});

  @override
  State<InstallationHistory> createState() => _InstallationHistoryState();
}

class _InstallationHistoryState extends State<InstallationHistory> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Installation History'),
      ),
    );
  }
}