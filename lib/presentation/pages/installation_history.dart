part of 'pages.dart';

class InstallationHistory extends StatefulWidget {
  const InstallationHistory({super.key});

  @override
  State<InstallationHistory> createState() => _InstallationHistoryState();
}

class _InstallationHistoryState extends State<InstallationHistory> {
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              children: [
                const Text(
                  'Installation History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(6),
                ItemHistory.installation(
                  'QMS-2408130T1022',
                  'Submitted',
                  AppColor.blueColor1,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.detailHistoryInstallation);
                  },
                  date: dateFormat.format(DateTime.now()),
                  createdBy: 'SPV MS BATAM',
                  ttDms: 'TT-24082800S009',
                  servicePoint: 'Serpo Batam 2',
                  sectionName: 'TRIAS_Diversity Tanjung Pinggir - Batam Center',
                ),
                const Gap(24),
                ItemHistory.installation(
                  'QMS-2408130T1022',
                  'On Review',
                  AppColor.installation,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.detailHistoryInstallation);
                  },
                  date: dateFormat.format(DateTime.now()),
                  createdBy: 'SPV MS BATAM',
                  ttDms: 'TT-24082800S009',
                  servicePoint: 'Serpo Batam 2',
                  sectionName: 'TRIAS_Diversity Tanjung Pinggir - Batam Center',
                ),
                const Gap(24),
                ItemHistory.installation(
                  'QMS-2408130T1022',
                  'On Review',
                  AppColor.greyColor1,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.detailHistoryInstallation);
                  },
                  date: dateFormat.format(DateTime.now()),
                  createdBy: 'SPV MS BATAM',
                  ttDms: 'TT-24082800S009',
                  servicePoint: 'Serpo Batam 2',
                  sectionName: 'TRIAS_Diversity Tanjung Pinggir - Batam Center',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
