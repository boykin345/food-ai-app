import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

/// A future that initialises the camera screen.
/// Returns the image path of the picture taken.
Future<String?> initialiseTakePictureScreen(BuildContext context) async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  // potentially add functionality to change cameras in the future?
  final firstCamera = cameras.first;

  // Navigate to the Take Picture Screen
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TakePictureScreen(camera: firstCamera),
    ),
  );

  return result as String?; // Return the image path
}

/// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}
/// The state for [TakePictureScreen].
class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a photo')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            if (!mounted) return;

            // If the picture was taken, navigate to the display picture screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                    imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
          foregroundColor: Color(0xFF2D3444),
          backgroundColor: Color(0xFFFAF0F0),
      ),
    );
  }
}

/// A widget that displays the picture taken by the user.
/// Allows the user to confirm or reject & retake a photo taken.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Photo?')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 100, // Adjust this value to increase or decrease the space
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reject Photo
                  FloatingActionButton.extended(
                    onPressed: () {
                      // Go back to the camera preview screen
                      Navigator.pop(context);
                    },
                    label: Icon(Icons.close_rounded),
                    foregroundColor: Color(0xFF2D3444),
                    backgroundColor: Color(0xFFFAF0F0),
                  ),
                  FloatingActionButton.extended(
                    // Accept Photo
                    onPressed: () {
                      // Handle choose photo action
                      Navigator.pop(context, imagePath);
                      Navigator.pop(context, imagePath);
                    },
                    label: Icon(Icons.check),
                    foregroundColor: Color(0xFF2D3444),
                    backgroundColor: Color(0xFFFAF0F0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}