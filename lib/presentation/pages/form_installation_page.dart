// part of 'pages.dart';

// class FormInstallationPage extends StatefulWidget {
//   const FormInstallationPage({super.key});

//   @override
//   State<FormInstallationPage> createState() => _FormInstallationPageState();
// }

// class _FormInstallationPageState extends State<FormInstallationPage> {
//   String? qmsId;
//   String? initialQMSInstallationStepId; // Ubah dari qmsInstallationStepId
//   String? generatedQMSInstallationStepId;
//   String? qmsInstallationStepId;
//   String? servicePointName;
//   int? typeOfInstallationId;
//   String? typeOfInstallationName;

//   bool isLoadingInstallationSteps = false;
//   bool isLoading = false;

//   List<InstallationStep> installationStep = [];
//   InstallationStep? selectedInstallationStep;

//   int currentStepNumber = 1;
//   int totalSteps = 0;

//   final FocusNode _descriptionFocusNode = FocusNode();

//   final edtDescription = TextEditingController();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     final args = ModalRoute.of(context)?.settings.arguments as Map?;

//     if (args != null) {
//       qmsId = args['qms_id'] as String?;
//       initialQMSInstallationStepId =
//           args['qms_installation_step_id'] as String?;
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

//   final ScrollController _scrollController = ScrollController();

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _descriptionFocusNode.dispose();
//     super.dispose();
//   }

//   final documentations = <XFile>[].obs;

//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       PermissionStatus status = await permission.request();
//       return status == PermissionStatus.granted;
//     }
//   }

//   Future<void> pickImagesFromGallery(InstallationStep currentStep) async {
//     // Memeriksa apakah izin sudah diberikan
//     if (await _requestPermission(
//         (Platform.isAndroid && (await _isAndroid13OrAbove()))
//             ? Permission.photos
//             : Permission.storage)) {
//       // Ambil gambar dari galeri
//       List<XFile>? results = await ImagePicker().pickMultiImage();
//       if (results.isNotEmpty) {
//         int remainingSlots = currentStep.imageLength! - documentations.length;
//         if (results.length > remainingSlots) {
//           results = results.take(remainingSlots).toList();
//         }

//         List<XFile> processedFiles = [];
//         for (XFile file in results) {
//           String originalName = path.basename(file.path);

//           Directory appDocDir =
//               await path_provider.getApplicationDocumentsDirectory();
//           String newPath = path.join(appDocDir.path, originalName);

//           File newFile = await File(file.path).copy(newPath);
//           processedFiles.add(XFile(newFile.path));
//         }

//         setState(() {
//           documentations.addAll(processedFiles);
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

//   // Function to check if the Android version is 13 or higher
//   Future<bool> _isAndroid13OrAbove() async {
//     if (Platform.isAndroid) {
//       var androidInfo = await DeviceInfoPlugin().androidInfo;
//       return androidInfo.version.sdkInt >= 33; // Android 13+ (API 33)
//     }
//     return false;
//   }

//   //Fungsi Untuk Mengahapus Gambar
//   void removeImage(int index) {
//     setState(() {
//       documentations.removeAt(index);
//     });
//   }

//   Future<void> _onWillPop(bool didPop) async {
//     if (didPop) {
//       return;
//     }
//     final bool shouldPop = await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Are you sure?'),
//             content: const Text('Do you want to close this page?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: const Text('No'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 child: const Text('Yes'),
//               ),
//             ],
//           ),
//         ) ??
//         false;

//     if (shouldPop) {
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvoked: _onWillPop,
//       canPop: false,
//       child: Scaffold(
//         appBar: AppBarWidget.cantBack(
//           'Detail',
//           context,
//           onBackPressed: () => _onWillPop(false),
//         ),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(
//                   child: ListView(
//                     controller: _scrollController,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 24),
//                     physics: const BouncingScrollPhysics(),
//                     children: [
//                       const Gap(6),
//                       formInstallation(),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             if (isLoading)
//               Container(
//                 color: Colors.black.withOpacity(0.5),
//                 child: const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//           ],
//         ),
//         bottomNavigationBar: Container(
//           height: 50,
//           decoration: BoxDecoration(
//             color: AppColor.whiteColor,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: const [
//               BoxShadow(
//                   offset: Offset(0, 3),
//                   blurRadius: 10,
//                   blurStyle: BlurStyle.outer)
//             ],
//           ),
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 50,
//                 vertical: 5,
//               ),
//               child: DButtonFlat(
//                 onClick: () {
//                   setState(() {
//                     final currentStep = installationStep.isNotEmpty
//                         ? installationStep[currentStepNumber - 1]
//                         : null;

//                     // if (currentStep != null && documentations.isEmpty) {
//                     //   ScaffoldMessenger.of(context).showSnackBar(
//                     //     const SnackBar(
//                     //       content: Text(
//                     //         'Please upload at least 1 image to continue.',
//                     //       ),
//                     //     ),
//                     //   );
//                     //   return;
//                     // }

//                     if (currentStep != null &&
//                         currentStep.isOptional == 'No' &&
//                         documentations.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                             'Please upload at least 1 image to continue.',
//                           ),
//                         ),
//                       );
//                       return;
//                     }

//                     if (edtDescription.text.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                               'Please fill in the description to continue.'),
//                         ),
//                       );
//                       return; // Jangan lanjutkan jika deskripsi kosong
//                     }

//                     if (currentStepNumber == totalSteps) {
//                       showEnvironmentDialog(context);
//                     } else {
//                       showConfirmationDialog(context);
//                     }
//                   });
//                 },
//                 radius: 10,
//                 mainColor: AppColor.blueColor1,
//                 child: Text(
//                   currentStepNumber < totalSteps
//                       ? 'Next'
//                       : (currentStepNumber == totalSteps)
//                           ? 'Finish'
//                           : 'Next',
//                   style: TextStyle(
//                     color: AppColor.whiteColor,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
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
//                 Navigator.of(context).pop(); // Close dialog without action
//               },
//               child: const Text('Tidak'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 // Close the dialog immediately
//                 Navigator.of(context).pop();

//                 setState(() {
//                   isLoading = true;
//                 });

//                 // Prepare to call the stepInstallation function
//                 final currentStep = installationStep.isNotEmpty
//                     ? installationStep[currentStepNumber - 1]
//                     : null;

//                 if (currentStep != null) {
//                   // Use initialQMSInstallationStepId for step 1, else use the last generated ID
//                   String? finalQmsInstallationStepId = currentStepNumber == 1
//                       ? initialQMSInstallationStepId
//                       : qmsInstallationStepId;

//                   // Call the step installation function
//                   bool result = await InstallationSource.stepInstallation(
//                     installationStepId: currentStep.id,
//                     stepNumber: currentStep.stepNumber!,
//                     qmsId: qmsId,
//                     qmsInstallationStepId:
//                         finalQmsInstallationStepId, // Use the appropriate ID
//                     typeOfInstallation: typeOfInstallationName,
//                     description: edtDescription.text,
//                     photos: documentations,
//                     status: 'Created',
//                   );

//                   setState(() {
//                     isLoading = false;
//                   });

//                   if (result) {
//                     final newId =
//                         await InstallationSource.generateQMSInstallationStepId(
//                             qmsId: qmsId);

//                     if (newId != null &&
//                         newId['qms_installation_step_id'] != null) {
//                       setState(() {
//                         qmsInstallationStepId =
//                             newId['qms_installation_step_id'];
//                       });
//                     } else {
//                       showErrorSnackBar('Failed to generate new step ID.');
//                       return;
//                     }
//                     resetFormAndScroll();
//                   } else {
//                     showErrorSnackBar();
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

//   void showLoadingOverlay(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             color: Colors.black.withOpacity(0.3),
//             child: const Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void hideLoadingOverlay(BuildContext context) {
//     Navigator.of(context).pop(); // Close the loading dialog
//   }

//   void resetFormAndScroll() {
//     setState(() {
//       edtDescription.clear();
//       _descriptionFocusNode.unfocus();
//       documentations.clear();
//       if (currentStepNumber < totalSteps) {
//         currentStepNumber++;
//       }
//     });

//     // Scroll to the top
//     _scrollController.animateTo(
//       0,
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }

//   void showErrorSnackBar([String message = 'Failed to submit step.']) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void showEnvironmentDialog(BuildContext context) {
//     // Capture the context in a local variable
//     final BuildContext dialogContext = context;

//     showDialog(
//       context: dialogContext,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Environmental Information'),
//           content: const Text('Apakah terdapat Environmental Information?'),
//           actions: [
//             TextButton(
//               onPressed: () => _handleEnvironmentResponse(dialogContext, false),
//               child: const Text('No'),
//             ),
//             TextButton(
//               onPressed: () => _handleEnvironmentResponse(dialogContext, true),
//               child: const Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _handleEnvironmentResponse(
//       BuildContext dialogContext, bool hasEnvironmentInfo) async {
//     Navigator.of(dialogContext).pop(); // Close dialog first

//     setState(() {
//       isLoading = true;
//     });

//     final currentStep = installationStep.isNotEmpty
//         ? installationStep[currentStepNumber - 1]
//         : null;

//     if (currentStep != null) {
//       String? finalQmsInstallationStepId = currentStepNumber == 1
//           ? initialQMSInstallationStepId
//           : qmsInstallationStepId;

//       bool result = await InstallationSource.stepInstallation(
//         installationStepId: currentStep.id,
//         stepNumber: currentStep.stepNumber!,
//         qmsId: qmsId,
//         qmsInstallationStepId: finalQmsInstallationStepId,
//         typeOfInstallation: typeOfInstallationName,
//         description: edtDescription.text,
//         photos: documentations,
//         status: 'Created',
//       );

//       setState(() {
//         isLoading = false;
//       });

//       if (result) {
//         if (hasEnvironmentInfo) {
//           final newId = await InstallationSource.generateQMSInstallationStepId(
//               qmsId: qmsId);

//           if (newId != null && newId['qms_installation_step_id'] != null) {
//             setState(() {
//               qmsInstallationStepId = newId['qms_installation_step_id'];
//             });

//             Navigator.pushReplacementNamed(
//               dialogContext,
//               AppRoute.formEnvironemntInstallation,
//               arguments: {
//                 'qms_id': qmsId,
//                 'qmsInstallationStepId': qmsInstallationStepId,
//                 'typeOfInstallationId': typeOfInstallationId ?? 0,
//                 'typeOfInstallationName': typeOfInstallationName,
//               },
//             );
//           } else {
//             _showErrorSnackBar(
//                 dialogContext, 'Failed to generate new step ID.');
//           }
//         } else {
//           Navigator.pushReplacementNamed(
//             dialogContext,
//             AppRoute.summaryInstallation,
//             arguments: {
//               'qms_id': qmsId,
//               'typeOfInstallationId': typeOfInstallationId ?? 0,
//               'typeOfInstallationName': typeOfInstallationName,
//             },
//           );
//         }
//       } else {
//         _showErrorSnackBar(dialogContext);
//       }
//     }
//   }

//   void _showErrorSnackBar(BuildContext context,
//       [String message = 'Failed to submit step.']) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
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
//                 TextEditingController(
//                   text: currentStepNumber == 1
//                       ? initialQMSInstallationStepId
//                       : qmsInstallationStepId,
//                 ),
//               ),
//               const Gap(6),
//               InputWidget.dropDown2(
//                 title: 'Type of installation',
//                 hintText: 'Select Type Of Installation',
//                 value: typeOfInstallationName!,
//                 onChanged: null,
//                 isEnabled: false,
//                 hintTextSearch: 'Search type of installation',
//               ),
//               const Gap(12),
//               ...[
//                 uploadFile(
//                   currentStep.stepDescription ?? 'No Image Uploaded',
//                   'Upload',
//                   'No Image Uploaded',
//                   currentStep,
//                 ),
//                 const Gap(12),
//                 InputWidget.textArea(
//                   title: 'Description',
//                   hintText: 'Description',
//                   controller: edtDescription,
//                   focusNode: _descriptionFocusNode,
//                 ),
//               ],
//               const Gap(24)
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget uploadFile(String title, String textButton, String hintUpload,
//       InstallationStep currentStep) {
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
//                 // Jika documentations kosong
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
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 36),
//                         child: DButtonFlat(
//                           onClick: () {
//                             pickImagesFromGallery(
//                                 currentStep); // Kirim currentStep ke sini
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
//                   return Expanded(
//                     child: GridView.builder(
//                       padding: const EdgeInsets.fromLTRB(12, 12, 24, 12),
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: 8.0,
//                         mainAxisSpacing: 8.0,
//                       ),
//                       itemCount: documentations.length +
//                           (documentations.length <
//                                   (currentStep.imageLength ?? 0)
//                               ? 1
//                               : 0),
//                       itemBuilder: (context, index) {
//                         if (index == documentations.length &&
//                             documentations.length <
//                                 (currentStep.imageLength ?? 0)) {
//                           return GestureDetector(
//                             onTap: () {
//                               pickImagesFromGallery(
//                                   currentStep); // Kirim currentStep ke sini
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
//           "Uploaded: ${documentations.length}/${currentStep.imageLength ?? 0}", // Tampilkan jumlah gambar yang diupload
//           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//         ),
//       ],
//     );
//   }
// }
