part of 'pages.dart';

class EnvironmentInstallationPage extends StatefulWidget {
  const EnvironmentInstallationPage({super.key});

  @override
  State<EnvironmentInstallationPage> createState() =>
      _EnvironmentInstallationPageState();
}

class _EnvironmentInstallationPageState
    extends State<EnvironmentInstallationPage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoadingInstallationSteps = false;
  bool isLoading = false;

  final edtDescription = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();

  List<InstallationStep> listInstallationStep = [];
  InstallationStep? installationStep;

  String? qmsId;
  String? qmsInstallationStepId;
  int? typeOfInstallationId;
  String? typeOfInstallationName;

  final documentations = <XFile>[].obs;

  List<String> environmentalCategories = [
    'Terdapat tanaman merambat / alang-alang',
    'Cabang/Ranting Pohon Menghalangi Kabel',
    'Tanah berpotensi longsor',
    'Atribut Kegiatan Masyarakat',
    'Government / Non Government Activity',
    'Ditumpangi Kabel Operator Lain',
    'Others'
  ];

  List<bool> selectedCategories = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final args = ModalRoute.of(context)?.settings.arguments as Map?;
        if (args != null) {
          setState(() {
            qmsId = args['qms_id'] as String?;
            qmsInstallationStepId = args['qmsInstallationStepId'] as String?;
            typeOfInstallationId = args['typeOfInstallationId'] as int?;
            typeOfInstallationName = args['typeOfInstallationName'] as String?;
          });
        }
        if (typeOfInstallationId != null) {
          context
              .read<InstallationBloc>()
              .add(FetchInstallationSteps(typeOfInstallationId!));
        }
      }
    });
  }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final args = ModalRoute.of(context)?.settings.arguments as Map?;

  //   if (args != null) {
  //     qmsId = args['qms_id'] as String?;
  //     qmsInstallationStepId = args['qmsInstallationStepId'] as String?;
  //     typeOfInstallationId = args['typeOfInstallationId'] as int?;
  //     typeOfInstallationName = args['typeOfInstallationName'] as String?;
  //   }

  //   if (typeOfInstallationId != null &&
  //       ModalRoute.of(context)?.isActive == true) {
  //     context
  //         .read<InstallationBloc>()
  //         .add(FetchInstallationSteps(typeOfInstallationId!));
  //   }
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus status = await permission.request();
      return status == PermissionStatus.granted;
    }
  }

  Future<void> pickImagesFromGallery() async {
    if (await _requestPermission(
        (Platform.isAndroid && (await _isAndroid13OrAbove()))
            ? Permission.photos
            : Permission.storage)) {
      List<XFile>? results = await ImagePicker().pickMultiImage();
      if (results.isNotEmpty) {
        List<XFile> processedFiles = [];
        for (XFile file in results) {
          String originalName =
              path.basename(file.path); // Ambil nama file asli

          Directory appDocDir =
              await path_provider.getApplicationDocumentsDirectory();
          String newPath = path.join(appDocDir.path, originalName);

          File newFile = await File(file.path).copy(newPath);
          processedFiles.add(XFile(newFile.path));
        }

        setState(() {
          documentations.addAll(processedFiles);
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

  // Function to check if the Android version is 13 or higher
  Future<bool> _isAndroid13OrAbove() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt >= 33; // Android 13+ (API 33)
    }
    return false;
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
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Gap(6),
                    formEnvironmentInstallations(),
                  ],
                ),
              )
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
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
                blurStyle: BlurStyle.outer,
              )
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 5,
            ),
            child: DButtonFlat(
              onClick: () async {
                for (InstallationStep step in listInstallationStep) {
                  if (documentations.length < (step.imageLength ?? 0)) {
                    // Jika gambar kurang, tampilkan snackbar dan hentikan eksekusi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please upload at least ${step.imageLength} images for this step',
                        ),
                      ),
                    );
                    return; // Hentikan eksekusi jika gambar kurang
                  }
                }

                showConfirmationDialog(context);
              },
              radius: 10,
              mainColor: AppColor.blueColor1,
              child: Text(
                'Finish',
                style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
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
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Form Environment Installation'),
          content: const Text('Apakah Anda yakin form yang diisi sudah benar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without action
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleInstallationSubmission();
              },
              child: const Text('Iya'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleInstallationSubmission() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    String categoryOfEnvironment = getSelectedCategories(environmentalCategories, selectedCategories);

    try {
      for (InstallationStep step in listInstallationStep) {
        bool result = await InstallationSource.stepInstallation(
          installationStepId: step.id,
          stepNumber: step.stepNumber!,
          qmsId: qmsId,
          qmsInstallationStepId: qmsInstallationStepId,
          typeOfInstallation: typeOfInstallationName,
          categoryOfEnvironment: categoryOfEnvironment,
          description: edtDescription.text,
          photos: documentations,
          status: 'created',
        );

        if (!result) {
          if (mounted) {
            showErrorSnackBar();
          }
          return;
        }
      }

      if (mounted) {
        await Navigator.pushNamed(
          context,
          AppRoute.summaryInstallation,
          arguments: {
            'qms_id': qmsId,
            'typeOfInstallationId': typeOfInstallationId ?? 0,
            'typeOfInstallationName': typeOfInstallationName,
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showErrorSnackBar([String message = 'Failed to submit step.']) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String getSelectedCategories(List<String> items, List<bool> selectedItems) {
    List<String> selectedCategories = [];
    for (int i = 0; i < items.length; i++) {
      if (selectedItems[i]) {
        selectedCategories.add(items[i]);
      }
    }
    return selectedCategories
        .join(', '); // Menggabungkan pilihan menjadi satu string
  }

  Widget formEnvironmentInstallations() {
    return BlocBuilder<InstallationBloc, InstallationState>(
      builder: (context, state) {
        if (state is InstallationStepsLoading) {
          isLoadingInstallationSteps = true;
        } else if (state is InstallationStepsLoaded) {
          listInstallationStep = state.installationSteps
              .where((step) => step.stepNumber == 99)
              .toList();
        } else if (state is InstallationError) {
          return Center(child: Text(state.message));
        }

        if (typeOfInstallationId != null && listInstallationStep.isEmpty) {
          context
              .read<InstallationBloc>()
              .add(FetchInstallationSteps(typeOfInstallationId!));
        }

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
                    'Environment Information',
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
              InputWidget.disable(
                'QMS Installation Ticket Number',
                TextEditingController(text: qmsId),
              ),
              const Gap(6),
              InputWidget.disable(
                'QMS Installation Step ID',
                TextEditingController(
                  text:
                      qmsInstallationStepId, // Step selanjutnya: ID dari generate
                ),
              ),
              const Gap(6),
              InputWidget.dropDown2(
                title: 'Type of installation',
                hintText: 'Select Type Of Installation',
                value: typeOfInstallationName ?? '', // Tampilkan typeName
                onChanged:
                    null, // Dropdown disable karena sudah ada typeOfInstallation
                isEnabled: false, // Set dropdown sebagai disable
                hintTextSearch: 'Search type of installation',
              ),
              const Gap(6),
              InputWidget.checkboxList(
                  title: 'Category Of Environment',
                  items: environmentalCategories,
                  selectedItems: selectedCategories,
                  onChanged: (int index) {
                    setState(() {
                      // Ubah nilai checkbox yang dipilih
                      selectedCategories[index] = !selectedCategories[index];
                    });
                  }),
              const Gap(6),
              for (var step in listInstallationStep) ...[
                uploadFile(
                  step.stepDescription ?? 'No Image Uploaded',
                  'Upload',
                  'No Image Uploaded',
                  step.imageLength ??
                      0, // Asumsikan ini adalah jumlah gambar yang diupload
                ),
                const Gap(6),
                InputWidget.textArea(
                  title: 'Description',
                  hintText: 'Description',
                  controller: edtDescription,
                  focusNode: _descriptionFocusNode,
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
                      physics: const NeverScrollableScrollPhysics(),
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
