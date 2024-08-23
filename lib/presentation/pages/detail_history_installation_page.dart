part of 'pages.dart';

class DetailHistoryInstallationPage extends StatefulWidget {
  const DetailHistoryInstallationPage({super.key});

  @override
  State<DetailHistoryInstallationPage> createState() =>
      _DetailHistoryInstallationPageState();
}

class _DetailHistoryInstallationPageState
    extends State<DetailHistoryInstallationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.secondary('Installation', context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                ticketDMS('Detail Ticket DMS'),
                const Gap(24),
                installation('Installation'),
                const Gap(24),
                opsTeamReview('Ops Team Review'),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget ticketDMS(String title) {
    return Container(
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
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Divider(
              color: AppColor.divider,
            ),
            ItemDescriptionDetail.primary('TT Number', 'TT-24082800S009'),
            const Gap(12),
            ItemDescriptionDetail.primary('Service Point', 'Serpo Batam 2'),
            const Gap(12),
            ItemDescriptionDetail.primary('Project', 'B2JS'),
            const Gap(12),
            ItemDescriptionDetail.primary(
                'Segment', 'TRIAS_Tanjung Bemban - Tanjung Pinggir'),
            const Gap(12),
            ItemDescriptionDetail.primary('Section Name',
                'TRIAS_Diversity Tanjung Pinggir - Batam Center'),
            const Gap(12),
            ItemDescriptionDetail.primary('Worker', 'Harizaldy'),
            const Gap(12),
            ItemDescriptionDetail.primary('Area', 'MS BATAM'),
            const Gap(12),
          ],
        ),
      ),
    );
  }

  Widget installation(String title) {
    return Container(
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
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Divider(
              color: AppColor.divider,
            ),
            ItemDescriptionDetail.primary(
                'Type of cable/enviroment installation', 'KT'),
            const Gap(12),
            ItemDescriptionDetail.primary('Category of installation', 'Kabel'),
            const Gap(12),
            ItemDescriptionDetail.primary('Category of installation Details',
                'Spare kabel di closure pada kabel eksisting lebih dari 3m'),
            const Gap(12),
            ItemDescriptionDetail.primary('description',
                'Spare Kabel di Pasag Pada Section Tanjung Emban'),
            const Gap(12),
            ItemDescriptionDetail.primary('latitude', '-6.225678'),
            const Gap(12),
            ItemDescriptionDetail.primary('longitude', '106.873981'),
            const Gap(12),
            ItemDescriptionDetail.secondary(
                'Documentation/Photo',
                [
                  'https://infopublik.id/resources/album/bulan-september-2019/fiber_compressed.jpg',
                  'https://infopublik.id/resources/album/bulan-september-2019/fiber_compressed.jpg',
                  'https://infopublik.id/resources/album/bulan-september-2019/fiber_compressed.jpg',
                  'https://infopublik.id/resources/album/bulan-september-2019/fiber_compressed.jpg',
                  'https://infopublik.id/resources/album/bulan-september-2019/fiber_compressed.jpg',
                  'https://infopublik.id/resources/album/bulan-september-2019/fiber_compressed.jpg',
                  // 'https://infopublik.id/resources/album/bulan-september-2019/fiber_compressed.jpg',
                ],
                context),
            const Gap(12),
          ],
        ),
      ),
    );
  }

  static Widget opsTeamReview(String title) {
    return Container(
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
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Divider(
              color: AppColor.divider,
            ),
            ItemDescriptionDetail.primary(
                'Installation Report Status', 'Rejected'),
            const Gap(12),
            ItemDescriptionDetail.primary(
                'Installation Report Remark', 'Foto Panoramtik Tidak Ada'),
            const Gap(12),
            ItemDescriptionDetail.primary(
                'Installation Review Result', 'Improper'),
            const Gap(12),
          ],
        ),
      ),
    );
  }
}
