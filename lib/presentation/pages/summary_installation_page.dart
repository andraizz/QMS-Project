part of 'pages.dart';

class SummaryInstallationPage extends StatefulWidget {
  const SummaryInstallationPage({super.key});

  @override
  State<SummaryInstallationPage> createState() =>
      _SummaryInstallationPageState();
}

class _SummaryInstallationPageState extends State<SummaryInstallationPage> {
  late InstallationType? selectedInstallationType;
  late List<InstallationStep> installationSteps;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      selectedInstallationType =
          args['selectedInstallationType'] as InstallationType?;
      installationSteps = args['installationSteps'] as List<InstallationStep>;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.secondary('Summary Installation', context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                ticketDMS('Detail Ticket DMS $selectedInstallationType' ),
                const Gap(24),
                summaryInstallation('Summary Installation'),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 10,
                  blurStyle: BlurStyle.outer)
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 5,
            ),
            child: DButtonFlat(
              onClick: () {
                showConfirmationDialog(context);
              },
              radius: 10,
              mainColor: AppColor.blueColor1,
              child: Text(
                'Submit',
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Form Installation'),
          content: const Text('Apakah Anda yakin summary installation form yang diisi sudah benar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                setState(() {
                  Navigator.pushNamed(
                    context,
                    AppRoute.dashboard,
                  );
                });
              },
              child: const Text('Iya'),
            ),
          ],
        );
      },
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
            ItemDescriptionDetail.primary('Worker', 'Batam 1 J'),
            const Gap(12),
            ItemDescriptionDetail.primary('Area', 'MS BATAM'),
            const Gap(12),
          ],
        ),
      ),
    );
  }

  Widget summaryInstallation(String title) {
    final edtQMSTicket =
        TextEditingController(text: 'TT-240818PL.0021-QS.IS-0001');
    final typeOfInstallation = TextEditingController(
        text: selectedInstallationType?.typeName ?? 'Not selected');

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
            InputWidget.disable(
              'QMS Installation Ticket Number',
              edtQMSTicket,
            ),
            const Gap(6),
            InputWidget.disable(
              'Type of installation',
              typeOfInstallation,
            ),
            const Gap(6),
            stepInstallation(),
          ],
        ),
      ),
    );
  }

  Widget stepInstallation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step Installation',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColor.greyColor3,
            fontSize: 10,
          ),
        ),
        const Gap(12),
        ...installationSteps.asMap().entries.map((entry) {
          int index =
              entry.key + 1; // Menambahkan 1 untuk nomor langkah mulai dari 1
          String stepDescription =
              entry.value.stepDescription ?? 'Unknown Step';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              itemStepInstallation('$index. $stepDescription', stepDescription),
              const Gap(6),
            ],
          );
        }),
      ],
    );
  }

  Widget itemStepInstallation(String descriptionStep, String stepDescription) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.detailStepInstallation,
          arguments: {
            'installationTicket':
                'TT-240818PL.0021-QS.IS-0001', // Ganti dengan ticket dinamis
            'typeOfInstallation':
                selectedInstallationType?.typeName ?? 'Not selected',
            'stepDescription': stepDescription,
          },
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          descriptionStep,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColor.defaultText,
          ),
        ),
      ),
    );
  }
}
