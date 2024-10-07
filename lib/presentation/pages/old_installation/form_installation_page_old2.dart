// part of 'pages.dart';

// class FormInstallationPage extends StatefulWidget {
//   const FormInstallationPage({super.key});

//   @override
//   State<FormInstallationPage> createState() => _FormInstallationPageState();
// }

// class _FormInstallationPageState extends State<FormInstallationPage> {
//   String? qmsId;
//   String? qmsInstallationStepId;
//   String? servicePointName;
//   int? typeOfInstallationId;
//   String? typeOfInstallationName;

//   bool isLoadingInstallationSteps = false;

//   List<InstallationStep> installationStep = [];
//   InstallationStep? selectedInstallationStep;

//   int currentStepNumber = 1;
//   int totalSteps = 0;

//   final edtDescription = TextEditingController();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     final args = ModalRoute.of(context)?.settings.arguments as Map?;

//     if (args != null) {
//       qmsId = args['qms_id'] as String?;
//       qmsInstallationStepId = args['qms_installation_step_id'] as String?;
//       typeOfInstallationId = args['typeOfInstallationId'] as int?;
//       typeOfInstallationName = args['typeOfInstallationName'] as String?;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Mengirim event untuk memulai pengambilan data dari CategoryInstallationBloc untuk Cable Types
//     if (typeOfInstallationId != null) {
//       // Jika ID valid, langsung fetch langkah-langkah instalasi berdasarkan typeOfInstallationId
//       context
//           .read<InstallationBloc>()
//           .add(FetchInstallationSteps(typeOfInstallationId!));
//     }
//   }

//   final documentations = <XFile>[].obs;

//   Future<bool> _requestPermission(Permission permission) async {
//     final status = await permission.request();
//     return status.isGranted;
//   }

//   pickImagesFromGallery() async {
//     //Meminta Izin akses ke galeri
//     if (await _requestPermission(Permission.storage)) {
//       List<XFile>? results = await ImagePicker().pickMultiImage();
//       if (results.isNotEmpty) {
//         setState(() {
//           documentations.addAll(results);
//         });
//       }
//     } else {
//       if (mounted) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Akses Galeri Ditolak'),
//               content: const Text(
//                   'Akses ke galeri tidak diizinkan. Anda perlu memberikan izin untuk mengakses galeri.'),
//               actions: <Widget>[
//                 TextButton(
//                   child: const Text('Tutup'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }
//   }

//   //Fungsi Untuk Mengahapus Gambar
//   void removeImage(int index) {
//     setState(() {
//       documentations.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarWidget.secondary('Detail', context),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
//               physics: const BouncingScrollPhysics(),
//               children: [
//                 const Gap(6),
//                 formInstallation(),
//               ],
//             ),
//           )
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           color: AppColor.whiteColor,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: const [
//             BoxShadow(
//                 offset: Offset(0, 3),
//                 blurRadius: 10,
//                 blurStyle: BlurStyle.outer)
//           ],
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 50,
//               vertical: 5,
//             ),
//             child: DButtonFlat(
//               onClick: () {
//                 setState(() {
//                   final currentStep = installationStep.isNotEmpty
//                       ? installationStep[currentStepNumber - 1]
//                       : null;

//                   // Cek apakah jumlah gambar yang diunggah sudah sesuai dengan imageLength
//                   if (currentStep != null &&
//                       documentations.length < currentStep.imageLength!) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           'Please upload at least ${currentStep.imageLength} images to continue.',
//                         ),
//                       ),
//                     );
//                     return; // Stop if image upload is not complete
//                   }

//                   if (currentStepNumber == totalSteps) {
//                     showEnvironmentDialog(context);
//                   } else {
//                     showConfirmationDialog(context);
//                   }
//                 });
//               },
//               radius: 10,
//               mainColor: AppColor.blueColor1,
//               child: Text(
//                 currentStepNumber < totalSteps
//                     ? 'Next'
//                     : (currentStepNumber == totalSteps)
//                         ? 'Finish'
//                         : 'Next',
//                 style: TextStyle(
//                   color: AppColor.whiteColor,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void showConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Form Installation'),
//           content: const Text('Apakah Anda yakin form yang diisi sudah benar?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Tutup dialog tanpa aksi
//               },
//               child: const Text('Tidak'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Tutup dialog

//                 // Prepare to call the stepInstallation function
//                 final currentStep = installationStep.isNotEmpty
//                     ? installationStep[currentStepNumber - 1]
//                     : null;

//                 if (currentStep != null) {
//                   // Check if this is the first step, if yes, use the qmsInstallationStepId from arguments
//                   if (currentStepNumber == 1) {
//                     // Step pertama menggunakan qmsInstallationStepId dari argumen awal
//                     bool result = await InstallationSource.stepInstallation(
//                       installationStepId: currentStep.id,
//                       stepNumber: currentStep.stepNumber!,
//                       qmsId: qmsId,
//                       qmsInstallationStepId:
//                           qmsInstallationStepId, // Use ID from args
//                       typeOfInstallation: typeOfInstallationName,
//                       description: edtDescription.text,
//                       photos: documentations,
//                       status: 'created',
//                     );

//                     if (result) {
//                       setState(() {
//                         edtDescription.clear();
//                         documentations.clear();
//                         currentStepNumber++; // Move to next step
//                       });
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Failed to submit step.')),
//                       );
//                     }
//                   } else {
//                     // Step selanjutnya generate ID baru
//                     final newId =
//                         await InstallationSource.generateQMSInstallationStepId(
//                       qmsId: qmsId,
//                     );

//                     if (newId != null &&
//                         newId['qms_installation_step_id'] != null) {
//                       setState(() {
//                         qmsInstallationStepId =
//                             newId['qms_installation_step_id'];
//                       });

//                       bool result = await InstallationSource.stepInstallation(
//                         installationStepId: currentStep.id,
//                         stepNumber: currentStep.stepNumber!,
//                         qmsId: qmsId,
//                         qmsInstallationStepId:
//                             qmsInstallationStepId, // Use newly generated ID
//                         typeOfInstallation: typeOfInstallationName,
//                         description: edtDescription.text,
//                         photos: documentations,
//                         status: 'created',
//                       );

//                       if (result) {
//                         setState(() {
//                           edtDescription.clear();
//                           documentations.clear();

//                           if (currentStepNumber < totalSteps) {
//                             currentStepNumber++; // Move to next step
//                           } else {
//                             showEnvironmentDialog(
//                                 context); // Show environment dialog if it's the last step
//                           }
//                         });
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text('Failed to submit step.')),
//                         );
//                       }
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Failed to generate new step ID.')),
//                       );
//                     }
//                   }
//                 }
//               },
//               child: const Text('Iya'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // void showConfirmationDialog(BuildContext context) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         title: const Text('Form Installation'),
//   //         content: const Text('Apakah Anda yakin form yang diisi sudah benar?'),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () async {
//   //               Navigator.of(context).pop(); // Tutup dialog

//   //               // Prepare to call the generateQMSInstallationStepId function first
//   //               final currentStep = installationStep.isNotEmpty
//   //                   ? installationStep[currentStepNumber - 1]
//   //                   : null;

//   //               if (currentStep != null) {
//   //                 // Generate new QMS Installation Step ID and update it
//   //                 final newId =
//   //                     await InstallationSource.generateQMSInstallationStepId(
//   //                   qmsId: qmsId,
//   //                 );

//   //                 if (newId != null &&
//   //                     newId['qms_installation_step_id'] != null) {
//   //                   setState(() {
//   //                     // Update qmsInstallationStepId with the new value from the response
//   //                     qmsInstallationStepId = newId['qms_installation_step_id'];
//   //                   });

//   //                   // After generating new ID, proceed with the step installation
//   //                   bool result = await InstallationSource.stepInstallation(
//   //                     installationStepId: currentStep.id,
//   //                     stepNumber: currentStep.stepNumber!,
//   //                     qmsId: qmsId,
//   //                     qmsInstallationStepId:
//   //                         qmsInstallationStepId, // Use the new ID here
//   //                     typeOfInstallation: typeOfInstallationName,
//   //                     description: edtDescription.text,
//   //                     photos: documentations,
//   //                     status: 'created',
//   //                   );

//   //                   if (result) {
//   //                     setState(() {
//   //                       edtDescription.clear();
//   //                       documentations.clear();

//   //                       // Check if it's the last step or move to the next one
//   //                       if (currentStepNumber < totalSteps) {
//   //                         currentStepNumber++;
//   //                       } else {
//   //                         showEnvironmentDialog(context);
//   //                       }
//   //                     });
//   //                   } else {
//   //                     // Handle failure case
//   //                     ScaffoldMessenger.of(context).showSnackBar(
//   //                       const SnackBar(content: Text('Failed to submit step.')),
//   //                     );
//   //                   }
//   //                 } else {
//   //                   // Handle failure in generating new QMS Installation Step ID
//   //                   ScaffoldMessenger.of(context).showSnackBar(
//   //                     const SnackBar(
//   //                         content: Text('Failed to generate new step ID.')),
//   //                   );
//   //                 }
//   //               }
//   //             },
//   //             child: const Text('Iya'),
//   //           )
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

//   void showEnvironmentDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Environment Information'),
//           content:
//               const Text('Apakah terdapat environment information? Optional?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Tutup dialog
//                 // Navigasi ke halaman summary
//                 Navigator.pushNamed(
//                   context,
//                   AppRoute.summaryInstallation,
//                   arguments: {
//                     'typeOfInstallationName': typeOfInstallationName,
//                     'installationSteps': installationStep,
//                   },
//                 );
//               },
//               child: const Text('No'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Tutup dialog
//                 // Navigasi ke form lingkungan
//                 Navigator.pushNamed(
//                     context, AppRoute.formEnvironemntInstallation);
//               },
//               child: const Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget formInstallation() {
//     return BlocBuilder<InstallationBloc, InstallationState>(
//       builder: (context, state) {
//         if (state is InstallationStepsLoading) {
//           isLoadingInstallationSteps = true;
//         } else if (state is InstallationStepsLoaded) {
//           // Mengambil langkah instalasi setelah state dimuat
//           installationStep = state.installationSteps
//               .where((step) => step.stepNumber != 99) // Mengabaikan step 99
//               .toList();
//           totalSteps = installationStep.length;
//         } else if (state is InstallationError) {
//           return Center(child: Text(state.message));
//         }
//         if (typeOfInstallationId != null && installationStep.isEmpty) {
//           context
//               .read<InstallationBloc>()
//               .add(FetchInstallationSteps(typeOfInstallationId!));
//         }
//         final currentStep = installationStep.isNotEmpty
//             ? installationStep[currentStepNumber -
//                 1] // Show the current step based on currentStepNumber
//             : InstallationStep();
//         return Container(
//           decoration: BoxDecoration(
//             color: AppColor.whiteColor,
//             borderRadius: BorderRadius.circular(5),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Form Installation',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: AppColor.defaultText,
//                     ),
//                   ),
//                   Text(
//                     typeOfInstallationId != null && typeOfInstallationId != null
//                         ? 'Step Installation $currentStepNumber of $totalSteps'
//                         : '',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: AppColor.defaultText,
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(
//                 color: AppColor.greyColor2,
//               ),
//               InputWidget.disable(
//                 'QMS Installation Ticket Number',
//                 TextEditingController(text: qmsId),
//               ),
//               const Gap(6),
//               InputWidget.disable(
//                 'QMS Installation Step ID',
//                 TextEditingController(text: qmsInstallationStepId),
//               ),
//               const Gap(6),
//               // InputWidget.disable(
//               //   'Type of installation',
//               //   TextEditingController(
//               //       text: typeOfInstallationName ?? 'Unknown'),
//               // ),
//               InputWidget.dropDown2(
//                 title: 'Type of installation',
//                 hintText: 'Select Type Of Installation',
//                 value: typeOfInstallationName!, // Tampilkan typeName
//                 // items: installationType
//                 //     .map((type) => type.typeName ?? '')
//                 //     .toList(),
//                 onChanged:
//                     null, // Dropdown disable karena sudah ada typeOfInstallation
//                 isEnabled: false, // Set dropdown sebagai disable
//                 hintTextSearch: 'Search type of installation',
//               ),
//               const Gap(12),
//               if (currentStep != null) ...[
//                 uploadFile(
//                   currentStep.stepDescription ?? 'No Image Uploaded',
//                   'Upload',
//                   'No Image Uploaded',
//                   currentStep.imageLength ?? 0,
//                 ),
//                 const Gap(12),
//                 InputWidget.textArea(
//                   'Description',
//                   'Description',
//                   edtDescription,
//                 ),
//               ],
//               const Gap(24)
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget uploadFile(
//       String title, String textButton, String hintUpload, int imageLength) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//         ),
//         const Gap(3),
//         Container(
//           height: 300,
//           decoration: BoxDecoration(
//             color: AppColor.whiteColor,
//             border: Border.all(color: AppColor.defaultText),
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Obx(() {
//                 // Jika tidak ada gambar yang dipilih, tampilkan teks 'No Image Selected'
//                 if (documentations.isEmpty) {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(
//                         hintUpload,
//                         style: TextStyle(
//                           color: AppColor.defaultText,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const Gap(20),
//                       // Tampilkan tombol upload menggunakan showModalBottomSheet
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 36),
//                         child: DButtonFlat(
//                           onClick: () {
//                             pickImagesFromGallery();
//                           },
//                           height: 40,
//                           mainColor: AppColor.blueColor1,
//                           radius: 10,
//                           child: Text(
//                             textButton,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 } else {
//                   // Jika ada gambar yang dipilih, tampilkan dalam GridView
//                   return Expanded(
//                     child: GridView.builder(
//                       padding: const EdgeInsets.fromLTRB(12, 12, 24, 12),
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3, // Atur jumlah kolom yang diinginkan
//                         crossAxisSpacing: 8.0,
//                         mainAxisSpacing: 8.0,
//                       ),
//                       itemCount: documentations.length + 1,
//                       itemBuilder: (context, index) {
//                         if (index == documentations.length) {
//                           // Tombol '+' untuk menambahkan gambar
//                           return GestureDetector(
//                             onTap: () {
//                               pickImagesFromGallery();
//                             },
//                             child: Container(
//                               width: 79,
//                               height: 68,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: AppColor.defaultText),
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Icon(
//                                 Icons.add,
//                                 color: AppColor.defaultText,
//                               ),
//                             ),
//                           );
//                         }

//                         String path = documentations[index].path;
//                         return Stack(
//                           children: [
//                             // Tampilkan gambar yang dipilih
//                             GestureDetector(
//                               onTap: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (_) => Dialog(
//                                     child: Image.file(
//                                       File(path),
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: SizedBox(
//                                 width: 79,
//                                 height: 68,
//                                 child: Image.file(
//                                   File(path),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               left: 0,
//                               top: 0,
//                               child: GestureDetector(
//                                 onTap: () => removeImage(index),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: AppColor.closeButton,
//                                   ),
//                                   child: const Icon(
//                                     Icons.close,
//                                     color: Colors.white,
//                                     size: 16,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   );
//                 }
//               }),
//             ],
//           ),
//         ),
//         const Gap(12),
//         Text(
//           "Uploaded: ${documentations.length}/$imageLength", // Display the number of uploaded images
//           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//         ),
//       ],
//     );
//   }
// }
