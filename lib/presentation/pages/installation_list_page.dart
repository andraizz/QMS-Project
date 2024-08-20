part of 'pages.dart';

class ListInstallationPage extends StatefulWidget {
  const ListInstallationPage({super.key});

  @override
  State<ListInstallationPage> createState() => _ListInstallationPageState();
}

class _ListInstallationPageState extends State<ListInstallationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(context, 'Site Installation'),
          Expanded(
              child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            children: [
              cardTicket(
                DateTime.now(),
                'TT-24082800S009',
                'Trias_Jember-Kalibaru',
                'Batam 1',
                context,
              ),
              cardTicket(
                DateTime.now(),
                'TT-24082800S009',
                'Trias_Jember-Kalibaru',
                'Batam 1',
                context,
              ),
              cardTicket(
                DateTime.now(),
                'TT-24082800S009',
                'Trias_Jember-Kalibaru',
                'Batam 1',
                context,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
