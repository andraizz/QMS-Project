part of 'pages.dart';

class SummaryInstallationPage extends StatefulWidget {
  const SummaryInstallationPage({super.key});

  @override
  State<SummaryInstallationPage> createState() =>
      _SummaryInstallationPageState();
}

class _SummaryInstallationPageState extends State<SummaryInstallationPage> {
  String? qmsId;
  String? typeOfInstallationName;
  int? typeOfInstallationId;
  // late InstallationType? selectedInstallationType;
  late List<InstallationStep> installationSteps;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      qmsId = args['qms_id'] as String?;
      typeOfInstallationName = args['typeOfInstallationName'] as String?;
      typeOfInstallationId = args['typeOfInstallationId'] as int?;
    }

    if (qmsId != null) {
      context
          .read<InstallationRecordsBloc>()
          .add(FetchInstallationRecords(qmsId!));

      context
          .read<InstallationStepRecordsBloc>()
          .add(FetchInstallationStepRecords(qmsId!));
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
                ticketDMS(
                  context,
                  'Detail Ticket DMS $typeOfInstallationName',
                ),
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
                showConfirmationDialog(context, qmsId!);
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

  Widget ticketDMS(BuildContext context, String title) {
    return BlocBuilder<InstallationRecordsBloc, InstallationRecordsState>(
        builder: (context, state) {
      if (state is InstallationRecordsLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is InstallationRecordsLoaded) {
        // Mengirimkan objek tunggal ke _buildTicketDMSContent
        return _buildTicketDMSContent(state.record, typeOfInstallationName);
      } else if (state is InstallationRecordsError) {
        return Center(
          child: Text(state.message),
        );
      }

      return const Center(
        child: Text('No Data Available'),
      );
    });
  }

  Widget _buildTicketDMSContent(
      InstallationRecords record, String? typeOfInstallationName) {
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
              'Detail Ticket DMS $typeOfInstallationName',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Divider(
              color: AppColor.divider,
            ),
            ItemDescriptionDetail.primary2(
              title: 'TT Number',
              data: "TT-${record.dmsId}",
            ),
            const Gap(12),
            ItemDescriptionDetail.primary2(
              title: 'Service Point',
              data: record.servicePoint,
            ),
            const Gap(12),
            ItemDescriptionDetail.primary2(
              title: 'Project',
              data: record.project,
            ),
            const Gap(12),
            ItemDescriptionDetail.primary2(
              title: 'Segment',
              data: record.segment,
            ),
            const Gap(12),
            ItemDescriptionDetail.primary2(
              title: 'Section Name',
              data: record.sectionName,
            ),
            const Gap(12),
            ItemDescriptionDetail.primary2(
              title: 'Area',
              data: record.area,
            ),
            const Gap(12),
            ItemDescriptionDetail.primary2(
              title: 'Latitude',
              data: record.latitude.toString(),
            ),
            const Gap(12),
            ItemDescriptionDetail.primary2(
              title: 'Longitude',
              data: record.longitude.toString(),
            ),
            const Gap(12),
          ],
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context, String qmsId) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Form Installation'),
          content: const Text(
              'Apakah Anda yakin summary installation form yang diisi sudah benar?'),
          actions: [
            TextButton(
              onPressed: () {
                navigator.pop(); // Close dialog
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                navigator.pop(); // Close dialog

                showLoadingDialog(context);

                // Call the submission functions
                final installationSuccess =
                    await InstallationSource.submitInstallationRecord(
                        qmsId: qmsId);
                final stepSuccess =
                    await InstallationSource.submitInstallationStepRecord(
                        qmsId: qmsId);

                // Close loading dialog
                if (navigator.canPop()) {
                  navigator.pop(); // Close loading dialog
                }

                if (navigator.mounted) {
                  if (installationSuccess && stepSuccess) {
                    navigator.pushNamed(
                      AppRoute.dashboard,
                      arguments: 2,
                    );
                  } else {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                          content: Text('Submit gagal, silakan coba lagi.')),
                    );
                  }
                }
              },
              child: const Text('Iya'),
            ),
          ],
        );
      },
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from being dismissed
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget summaryInstallation(String title) {
    final edtQMSTicket = TextEditingController(text: qmsId);
    final typeOfInstallation =
        TextEditingController(text: typeOfInstallationName);

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
            BlocBuilder<InstallationStepRecordsBloc,
                InstallationStepRecordsState>(builder: (context, state) {
              if (state is InstallationStepRecordsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is InstallationStepRecordsLoaded) {
                return installationStepRecords(state.records);
              } else if (state is InstallationStepRecordsError) {
                return Center(
                  child: Text('Error : ${state.message}'),
                );
              }

              return const Center(
                child: Text('No Data Available'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget installationStepRecords(
      List<InstallationStepRecords> installationStepRecors) {
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
        ...installationStepRecors.map((record) {
          int stepNumber = record.stepNumber ?? 0;
          String stepDescription = record.stepDescription ?? 'Unknown Step';
          String qmsInstallationStepId = record.qmsInstallationStepId ?? '';
          String description = record.description ?? '';
          String typeOfInstallation = record.typeOfInstallation ?? '';
          String categoryOfEnvironment = record.categoryOfEnvironment ?? '';

          Color borderColor = Colors.black;
          String descriptionStep = '$stepNumber. $stepDescription';

          // If stepNumber is 99, modify the descriptionStep and borderColor
          if (stepNumber == 99) {
            borderColor = Colors.red; // Change border color to red
            descriptionStep =
                'Environmental Information'; // Set custom description
          }

          List<String> photoUrls = [];
          if (record.photos != null) {
            photoUrls = record.photos!
                .map((photo) =>
                    photo.photoUrl ?? '') // Mengganti null dengan string kosong
                .where((url) =>
                    url.isNotEmpty) // Menghapus string kosong jika perlu
                .toList();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              itemStepInstallation(
                descriptionStep: descriptionStep,
                qmsInstallationStepId: qmsInstallationStepId,
                description: description,
                typeOfInstallation: typeOfInstallation,
                photos: photoUrls,
                categoryOfEnvironment: categoryOfEnvironment,
                borderColor: borderColor,
                stepDescription: stepDescription,
              ),
              const Gap(6),
            ],
          );
        })
      ],
    );
  }

  Widget itemStepInstallation({
    String? descriptionStep,
    String? qmsInstallationStepId,
    String? description,
    String? typeOfInstallation,
    String? categoryOfEnvironment,
    List<String>? photos,
    Color? borderColor,
    String? stepDescription,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.detailStepInstallation,
          arguments: {
            'qmsInstallationStepId': qmsInstallationStepId,
            'stepDescription': stepDescription,
            'descriptionStep': descriptionStep,
            'typeOfInstallation': typeOfInstallation,
            'categoryOfEnvironment': categoryOfEnvironment,
            'description': description,
            'photos': photos,
          },
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
        decoration: BoxDecoration(
            border: Border.all(color: borderColor!),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          descriptionStep ?? '',
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
