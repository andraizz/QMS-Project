part of 'pages.dart';

class FormInstallationPageOld extends StatefulWidget {
  const FormInstallationPageOld({super.key});

  @override
  State<FormInstallationPageOld> createState() => _FormInstallationPageOldState();
}

class _FormInstallationPageOldState extends State<FormInstallationPageOld> {
  final documentations = <XFile>[].obs;

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  pickImagesFromGallery() async {
    //Meminta Izin akses ke galeri
    if (await _requestPermission(Permission.storage)) {
      List<XFile>? results = await ImagePicker().pickMultiImage();
      if (results != null && results.isNotEmpty) {
        documentations.addAll(results);
      }
    } else {
      print('Akses galeri tidak diizinkan');
    }
  }

  //Fungsi Untuk Mengambil Gambar dari Kamera
  pickImagesFromCamera() async {
    //Meminta izin akses ke kamera
    if (await _requestPermission(Permission.camera)) {
      List<XFile> cameraImages = [];
      // Loop untuk memungkinkan mengambil beberapa gambar dari kamera
      while (true) {
        XFile? result =
            await ImagePicker().pickImage(source: ImageSource.camera);
        if (result != null) {
          cameraImages.add(result);
        } else {
          // Hentikan loop jika pengguna membatalkan atau menutup kamera
          break;
        }
      }
      if (cameraImages.isNotEmpty) {
        documentations.addAll(cameraImages);
      }
    }else {
      //Tampilkan pesan jika izin tidak diberikan
      print("Akses kamera tidak diizinkan");
    }
  }

  //Fungsi Pick Images camera + location
    // pickImagesFromCamera(BuildContext context) async {
  //   if (await _requestPermission(Permission.camera) &&
  //       await _requestPermission(Permission.locationWhenInUse)) {
  //     if (!mounted) return; // Check mounted to avoid context issues
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CameraWithLocationOverlay(
  //           onImageTaken: (XFile image, Position position) {
  //             documentations.add(image);
  //             edtLatitudeInstall.text = position.latitude.toString();
  //             edtLongtitudeInstall.text = position.longitude.toString();
  //           },
  //         ),
  //       ),
  //     );
  //   } else {
  //     print("Camera or location access not granted");
  //   }
  // }

  //Fungsi Untuk Mengahapus Gambar
  void removeImage(int index) {
    documentations.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.secondary('Detail Ticket', context),
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
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 5,
            ),
            child: DButtonFlat(
              onClick: () {
                Navigator.pushNamed(context, AppRoute.dashboard);
              },
              radius: 10,
              mainColor: AppColor.blueColor1,
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
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

  Widget contentTicketDMS() {
    final edtServicePoint = TextEditingController(text: 'Serpo Batam 1');
    final edtProject = TextEditingController(text: 'B2JS');
    final edtSegment =
        TextEditingController(text: 'TRIAS_Tanjung Bemban - Tanjung Pinggir');
    final edtSection = TextEditingController(
        text: 'TRIAS_Diversity Tanjung Pinggir - Batam Center');
    final edtWorker = TextEditingController(
        text: 'TRIAS_Diversity Tanjung Pinggir - Batam Center');
    final edtArea = TextEditingController(text: 'West 1');
    final edtLatitude = TextEditingController(text: '-6.225678');
    final edtLongtitude = TextEditingController(text: '106.873981');
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
            'TT-24082800S009',
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
            edtServicePoint,
          ),
          const Gap(6),
          InputWidget.disable(
            'Project',
            edtProject,
          ),
          const Gap(6),
          InputWidget.disable(
            'Segment',
            edtSegment,
          ),
          const Gap(6),
          InputWidget.disable(
            'Section Name',
            edtSection,
          ),
          const Gap(6),
          InputWidget.disable(
            'Worker',
            edtWorker,
          ),
          const Gap(6),
          InputWidget.disable(
            'Area',
            edtArea,
          ),
          const Gap(6),
          InputWidget.disable(
            'Latitude',
            edtLatitude,
          ),
          const Gap(6),
          InputWidget.disable(
            'Longitude',
            edtLongtitude,
          ),
          const Gap(6),
        ],
      ),
    );
  }


  Widget formInstallation() {
    String? selectedValue;
    final edtDescription = TextEditingController();
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
            'Form Installation',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColor.defaultText,
            ),
          ),
          Divider(
            color: AppColor.greyColor2,
          ),
          InputWidget.dropDown2('Type of cable/enviroment installation',
              "Select Type Of Cable", selectedValue, ["KT", "KU"], (newValue) {
            setState(() {
              selectedValue = newValue;
            });
          }, 'Search type cable/enviroment installation'),
          InputWidget.dropDown2('Category of installation',
              "Select Category of installation", selectedValue, [
            "Spare Kabel di Closure",
            "Kabel Menjuntai",
            "Pembaruan Kabel",
            "Kabel Terputus"
          ], (newValue) {
            setState(() {
              selectedValue = newValue;
            });
          }, 'Search category of installation'),
          const Gap(6),
          InputWidget.dropDown2('Category of installation Details',
              "Select Category of installation Details", selectedValue, [
            "Pergantian Kabel Cacat Karena Bite By Animal",
            "Kabel Terputus",
            "Kabel 1 di Gigit Harimau",
            "Kabel Terputus",
          ], (newValue) {
            setState(() {
              selectedValue = newValue;
            });
          }, 'Search category of installation'),
          const Gap(6),
          InputWidget.textArea(
            'Description',
            'Description',
            edtDescription,
          ),
          const Gap(6),
          uploadFile('Documentation/Photo', 'Upload'),
          const Gap(12),
        ],
      ),
    );
  }

  Widget uploadFile(String title, String textButton) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'No Image Selected',
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
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.photo),
                                      title: const Text('Pilih dari Galeri'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        pickImagesFromGallery();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Ambil dari Kamera'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        pickImagesFromCamera();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
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
                      itemCount: documentations.length +
                          1, // Tambahkan 1 untuk tombol tambah
                      itemBuilder: (context, index) {
                        if (index == documentations.length) {
                          // Tombol '+' untuk menambahkan gambar
                          return GestureDetector(
                            onTap: () {
                              // Tampilkan dialog untuk memilih sumber gambar
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Wrap(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.photo),
                                        title: const Text('Pilih dari Galeri'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          pickImagesFromGallery();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('Ambil dari Kamera'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          pickImagesFromCamera();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
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
                            SizedBox(
                              width: 79,
                              height: 68,
                              child: Image.file(
                                File(path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Tombol delete untuk menghapus gambar
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
      ],
    );
  }
}
