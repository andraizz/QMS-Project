// part of '../pages.dart';

// class CameraWithLocationOverlay extends StatefulWidget {
//   final Function(XFile, Position) onImageTaken;

//   const CameraWithLocationOverlay({required this.onImageTaken, super.key});

//   @override
//   State<CameraWithLocationOverlay> createState() =>
//       _CameraWithLocationOverlayState();
// }

// class _CameraWithLocationOverlayState extends State<CameraWithLocationOverlay> {
//   CameraController? _controller;
//   late Future<void> _initializeControllerFuture;
//   Position? _currentPosition;
//   String? _currentAddress;
//   final documentations = <XFile>[].obs;
//   final edtLatitudeInstall = TextEditingController();
//   final edtLongtitudeInstall = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllerFuture = _initializeCamera(); // Initialize here
//     _getCurrentLocation();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;

//     _controller = CameraController(
//       firstCamera,
//       ResolutionPreset.high,
//     );

//     try {
//       await _controller!.initialize();
//       if (!mounted) return;
//       setState(() {}); // Rebuild the widget after camera is initialized
//     } catch (e) {
//       print('Error initializing camera: $e');
//       _controller = null; // Reset controller to null if initialization fails
//     }
//   }

//   void _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           distanceFilter: 100,
//           accuracy: LocationAccuracy.high,
//         ),
//       );
//       setState(() {
//         _currentPosition = position;
//         edtLatitudeInstall.text = position.latitude.toString();
//         edtLongtitudeInstall.text = position.longitude.toString();
//       });

//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//       if (placemarks.isNotEmpty) {
//         setState(() {
//           _currentAddress =
//               "${placemarks.first.locality}, ${placemarks.first.country}";
//         });
//       }
//     } catch (e) {
//       print('Error fetching location: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   Future<void> _takePicture() async {
//     try {
//       await _initializeControllerFuture;

//       // Cek jika _currentPosition null
//       if (_currentPosition != null) {
//         final image = await _controller!.takePicture();
//         widget.onImageTaken(image, _currentPosition!);
//         Navigator.pop(context);
//       } else {
//         // Tampilkan pesan kesalahan jika _currentPosition belum tersedia
//         print('Position data is not available.');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera with Location Overlay'),
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // Check if _controller is not null before using
//             if (_controller != null) {
//               return Stack(
//                 children: [
//                   CameraPreview(_controller!),
//                   Positioned(
//                     left: 16,
//                     right: 16,
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       color: AppColor.defaultText.withOpacity(0.5),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Latitude: ${_currentPosition?.latitude ?? 'Loading...'}',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           Text(
//                             'Longitude: ${_currentPosition?.longitude ?? 'Loading...'}',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           Text(
//                             'Location: $_currentAddress',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               );
//             } else {
//               // Handle case where controller is null after initialization
//               return Center(
//                 child: Text('Camera not available'),
//               );
//             }
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _takePicture,
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }
