part of 'pages.dart';

class DetailStepInstallationPage extends StatefulWidget {
  const DetailStepInstallationPage({super.key});

  @override
  State<DetailStepInstallationPage> createState() =>
      _DetailStepInstallationPageState();
}

class _DetailStepInstallationPageState
    extends State<DetailStepInstallationPage> {
  late String installationTicket;
  late String typeOfInstallation;
  late String stepDescription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    installationTicket = arguments['installationTicket'];
    typeOfInstallation = arguments['typeOfInstallation'];
    stepDescription = arguments['stepDescription'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.secondary('Detail Installation', context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          installationTicket,
                          style: const  TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Divider(
                          color: AppColor.divider,
                        ),
                        ItemDescriptionDetail.primary(
                          'Worker',
                          'Purwodadi A',
                        ),
                        const Gap(12),
                         ItemDescriptionDetail.primary(
                          'Service Point',
                          'New Purwodadi',
                        ),
                        const Gap(12),
                        ItemDescriptionDetail.primary(
                          'Type of installation',
                          typeOfInstallation,
                        ),
                        const Gap(12),
                        ItemDescriptionDetail.secondary(
                          stepDescription,
                          [
                            'http://192.168.11.109:8000/storage/installation/4747_Far%20ins1.png',
                            'http://192.168.11.109:8000/storage/installation/5530_Pan%201.png',
                            'http://192.168.11.109:8000/storage/installation/4747_Far%20ins1.png',
                            'http://192.168.11.109:8000/storage/installation/5530_Pan%201.png',
                            'http://192.168.11.109:8000/storage/installation/5530_Pan%201.png',
                            'http://192.168.11.109:8000/storage/installation/5530_Pan%201.png',
                            // 'https://infopublik.id/resources/album/bulan-september-2019/fiber_compressed.jpg',
                          ],
                          context,
                        ),
                        const Gap(12),
                        ItemDescriptionDetail.primary(
                          'Description',
                          stepDescription,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
