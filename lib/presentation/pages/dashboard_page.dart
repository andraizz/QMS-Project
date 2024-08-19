part of 'pages.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.primary(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          welcomeCard(),
          const Gap(36),
          buildQmsModule(),
          const Gap(36),
          buildProgressQmsTicket(),
        ],
      ),
    );
  }

  Widget welcomeCard() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text(
              'Welcome To QMS Mobile Apps',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Divider(
            color: AppColor.scaffold,
            thickness: 2,
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInfoRow(
                        'assets/icons/ic_nama.png', 'Xaviera Ysabella'),
                    buildInfoRow(
                        'assets/icons/ic_position.png', 'Jointer SP Batam'),
                    buildInfoRow(
                        'assets/icons/ic_servicepoint.png', 'SP Batam'),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    'Wednesday \n 14 Agustus 2024',
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQmsModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Module',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(20),
        GridView.count(
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            buildItemModuleMenu(
                'assets/images/inspection_bg.png', 'Inspection', 1, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()));
            }),
            buildItemModuleMenu(
                'assets/images/installation_bg.png', 'Installation', 1, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardPage(),
                ),
              );
            }),
            buildItemModuleMenu(
                'assets/images/rectification_bg.png', 'Rectification', 1, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()));
            }),
            buildItemModuleMenu(
                'assets/images/qualityaudit_bg.png', 'Quality Audit', 1, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()));
            }),
          ],
        )
      ],
    );
  }

  Widget buildProgressQmsTicket() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QMS Ticket',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(20),
        ListView(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildItemProgressTickets(
              'assets/icons/ic_approved.png',
              'TT-24082800S009',
              '14 aug 2024, 12:00',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
              },
            ),
            buildItemProgressTickets(
              'assets/icons/ic_process.png',
              'TT-24082800S009',
              '14 aug 2024, 12:00',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
              },
            )
          ],
        )
      ],
    );
  }
}
