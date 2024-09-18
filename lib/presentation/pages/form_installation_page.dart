part of 'pages.dart';

class FormInstallationPage extends StatefulWidget {
  // final String? ticketNumber;
  const FormInstallationPage({super.key});

  @override
  State<FormInstallationPage> createState() => _FormInstallationPageState();
}

class _FormInstallationPageState extends State<FormInstallationPage> {
  String? ticketNumber;
  String? servicePointName;

  bool isLoadingInstallationTypes = false;
  bool isLoadingInstallationSteps = false;

  List<InstallationType> installationType = [];
  InstallationType? selectedInstallationType;

  List<InstallationStep> installationStep = [];
  InstallationStep? selectedInstallationStep;

  int currentStepNumber = 1;
  int totalSteps = 0;

  final edtDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mengirim event untuk memulai pengambilan data dari CategoryInstallationBloc untuk Cable Types
    context.read<InstallationBloc>().add(FetchInstallationTypes());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as Map?;

    if (args != null) {
      ticketNumber = args['ticketNumber'] as String?;
      servicePointName = args['servicePointName'] as String?;
    }

    if (ticketNumber != null) {
      context.read<TicketDetailBloc>().add(FetchTicketDetail(ticketNumber!));
    }
  }

  final documentations = <XFile>[].obs;

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  pickImagesFromGallery() async {
    //Meminta Izin akses ke galeri
    if (await _requestPermission(Permission.storage)) {
      List<XFile>? results = await ImagePicker().pickMultiImage();
      if (results.isNotEmpty) {
        setState(() {
          documentations.addAll(results);
        });
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Akses Galeri Ditolak'),
              content: const Text(
                  'Akses ke galeri tidak diizinkan. Anda perlu memberikan izin untuk mengakses galeri.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Tutup'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  //Fungsi Untuk Mengahapus Gambar
  void removeImage(int index) {
    setState(() {
      documentations.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.secondary('Detail', context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                contentTicketDMS(),
                const Gap(24),
                formInstallation(),
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
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 5,
            ),
            child: DButtonFlat(
              onClick: () {
                setState(() {
                  final currentStep = installationStep.isNotEmpty
                      ? installationStep[currentStepNumber - 1]
                      : null;

                  // Cek apakah jumlah gambar yang diunggah sudah sesuai dengan imageLength
                  if (currentStep != null &&
                      documentations.length < currentStep.imageLength!) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please upload at least ${currentStep.imageLength} images to continue.',
                        ),
                      ),
                    );
                    return; // Stop if image upload is not complete
                  }

                  showConfirmationDialog(context);
                });
              },
              radius: 10,
              mainColor: AppColor.blueColor1,
              child: Text(
                currentStepNumber < totalSteps
                    ? 'Next'
                    : (currentStepNumber == totalSteps)
                        ? 'Finish'
                        : 'Next',
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
          content: const Text('Apakah Anda yakin form yang diisi sudah benar?'),
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
                // Lanjutkan ke langkah berikutnya atau halaman ringkasan
                setState(() {
                  if (currentStepNumber < totalSteps) {
                    currentStepNumber++;
                  } else {
                    Navigator.pushNamed(
                      context,
                      AppRoute.summaryInstallation,
                      arguments: {
                        'selectedInstallationType': selectedInstallationType,
                        'installationSteps': installationStep,
                      },
                    );
                  }
                });
              },
              child: const Text('Iya'),
            ),
          ],
        );
      },
    );
  }

  Widget contentTicketDMS() {
    return BlocBuilder<TicketDetailBloc, TicketDetailState>(
        builder: (context, state) {
      if (state is TicketDetailLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is TicketDetailLoaded) {
        final ticketDetails = state.ticketDetail;
        return Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TT-$ticketNumber',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.defaultText,
                ),
              ),
              Divider(
                color: AppColor.greyColor2,
              ),
              InputWidget.disable(
                'Service Point',
                TextEditingController(text: servicePointName),
              ),
              const Gap(6),
              InputWidget.disable(
                'Project',
                TextEditingController(text: ticketDetails.projectName),
              ),
              const Gap(6),
              InputWidget.disable(
                'Segment',
                TextEditingController(text: ticketDetails.spanName),
              ),
              const Gap(6),
              InputWidget.disable(
                'Section Name',
                TextEditingController(text: ticketDetails.sectionName),
              ),
              const Gap(6),
              InputWidget.disable(
                'Area',
                TextEditingController(
                    text: ticketDetails.ticketAssignees?[0].serviceAreaName),
              ),
              const Gap(6),
              InputWidget.disable(
                'Latitude',
                TextEditingController(text: ticketDetails.latitude.toString()),
              ),
              const Gap(6),
              InputWidget.disable(
                'Longitude',
                TextEditingController(text: ticketDetails.longitude.toString()),
              ),
              const Gap(6),
            ],
          ),
        );
      } else if (state is TicketDetailError) {
        return Center(
          child: Text('Error: ${state.message}'),
        );
      } else {
        return const Center(
          child: Text('No Detail Available'),
        );
      }
    });
  }

  Widget formInstallation() {
    return BlocBuilder<InstallationBloc, InstallationState>(
      builder: (context, state) {
        if (state is InstallationLoading) {
          isLoadingInstallationTypes = true;
        } else if (state is InstallationTypesLoading) {
          isLoadingInstallationTypes = true;
          if (state.previousState is InstallationTypesLoaded) {
            installationType = (state.previousState as InstallationTypesLoaded)
                .installationTypes
                .toList();
          }
        } else if (state is InstallationStepsLoading) {
          isLoadingInstallationSteps = true;
          if (state.previousState is InstallationTypesLoaded) {
            installationType = (state.previousState as InstallationTypesLoaded)
                .installationTypes
                .toList();
          } else if (state.previousState is InstallationStepsLoaded) {
            installationStep = (state.previousState as InstallationStepsLoaded)
                .installationSteps
                .toList();
          }
        } else if (state is InstallationTypesLoaded) {
          installationType = state.installationTypes.toList();
        } else if (state is InstallationStepsLoaded) {
          installationStep = state.installationSteps;
          totalSteps = state.installationSteps.length;
        } else if (state is InstallationError) {
          return Center(child: Text(state.message));
        }

        final currentStep = installationStep.isNotEmpty
            ? installationStep[currentStepNumber -
                1] // Show the current step based on currentStepNumber
            : InstallationStep();

        return Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Form Installation',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColor.defaultText,
                    ),
                  ),
                  Text(
                    selectedInstallationType != null &&
                            selectedInstallationType!.id != null
                        ? 'Step Installation $currentStepNumber of $totalSteps'
                        : '',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColor.defaultText,
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColor.greyColor2,
              ),
              if (currentStepNumber == 1)
                InputWidget.dropDown2(
                  title: 'Type of installation',
                  hintText: 'Select Type Of Installation',
                  value: selectedInstallationType?.typeName ??
                      '', // Handle potential null value
                  items: installationType
                      .map((type) => type.typeName ?? '')
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      // Cari objek InstallationType berdasarkan typeName yang dipilih
                      selectedInstallationType = installationType.firstWhere(
                        (element) => element.typeName == newValue,
                        orElse: () => InstallationType(
                            id: null,
                            typeName:
                                null), // Hindari pengembalian null, buat objek kosongp
                      );

                      selectedInstallationStep = null;

                      // Pastikan selectedInstallationType tidak null dan id tersedia
                      if (selectedInstallationType != null &&
                          selectedInstallationType!.id != null) {
                        context.read<InstallationBloc>().add(
                            FetchInstallationSteps(selectedInstallationType!
                                .id!)); // Kirimkan id ke event
                      } else {
                        installationStep.clear();
                        totalSteps = 0;
                      }
                    });
                  },
                  hintTextSearch: 'Search type of installation',
                ),
              if (currentStepNumber > 1)
                InputWidget.dropDown2(
                  title: 'Type of installation',
                  hintText: 'Select Type Of Installation',
                  value: selectedInstallationType?.typeName ?? '',
                  items: installationType
                      .map((type) => type.typeName ?? '')
                      .toList(),
                  onChanged:
                      null, // Dropdown di-disable pada step setelah Step 1
                  hintTextSearch: 'Search type of installation',
                  isEnabled: false, // Disable the dropdown
                ),
              const Gap(12),
              if (selectedInstallationType != null &&
                  selectedInstallationType!.id != null) ...[
                uploadFile(
                    currentStep.stepDescription ?? 'No Image Uploaded',
                    'Upload',
                    'No Image Uploaded',
                    currentStep.imageLength ?? 0),
                const Gap(12),
                InputWidget.textArea(
                  'Description',
                  'Description',
                  edtDescription,
                ),
              ],
              const Gap(24)
            ],
          ),
        );
      },
    );
  }

  Widget uploadFile(
      String title, String textButton, String hintUpload, int imageLength) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(3),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            border: Border.all(color: AppColor.defaultText),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() {
                // Jika tidak ada gambar yang dipilih, tampilkan teks 'No Image Selected'
                if (documentations.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        hintUpload,
                        style: TextStyle(
                          color: AppColor.defaultText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(20),
                      // Tampilkan tombol upload menggunakan showModalBottomSheet
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: DButtonFlat(
                          onClick: () {
                            pickImagesFromGallery();
                          },
                          height: 40,
                          mainColor: AppColor.blueColor1,
                          radius: 10,
                          child: Text(
                            textButton,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Jika ada gambar yang dipilih, tampilkan dalam GridView
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 12, 24, 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Atur jumlah kolom yang diinginkan
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: documentations.length + 1,
                      itemBuilder: (context, index) {
                        if (index == documentations.length) {
                          // Tombol '+' untuk menambahkan gambar
                          return GestureDetector(
                            onTap: () {
                              pickImagesFromGallery();
                            },
                            child: Container(
                              width: 79,
                              height: 68,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.defaultText),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.add,
                                color: AppColor.defaultText,
                              ),
                            ),
                          );
                        }

                        String path = documentations[index].path;
                        return Stack(
                          children: [
                            // Tampilkan gambar yang dipilih
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    child: Image.file(
                                      File(path),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: 79,
                                height: 68,
                                child: Image.file(
                                  File(path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => removeImage(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.closeButton,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              }),
            ],
          ),
        ),
        const Gap(12),
        Text(
          "Uploaded: ${documentations.length}/$imageLength", // Display the number of uploaded images
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
