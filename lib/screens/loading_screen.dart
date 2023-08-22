import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'dart:io';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Position? _currentPosition;
  late ImagePicker _imagePicker;
  final String _uploadedImageUrl = "";
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
    print(position);
  }

  Future<void> takeAndDisplayImage() async {
    final XFile? imageFile =
        await _imagePicker.pickImage(source: ImageSource.camera);

    if (imageFile == null) return;

    setState(() {
      _imageFile = File(imageFile.path);
    });
  }

  void uploadImage() async {
    if (_imageFile == null) return;

    // Upload logic remains the same

    // After successful upload, you can reset the image
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                getLocation();
              },
              child: Text('Get Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                takeAndDisplayImage();
              },
              child: Text('Take Image'),
            ),
            if (_imageFile != null)
              _imageFile!.path.contains('http') // Check if it's a network image
                  ? Image.network(
                      _imageFile!.path,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      // Local image asset
                      _imageFile!.path,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
            if (_imageFile != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      uploadImage();
                    },
                    child: Text('Upload'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _imageFile = null;
                      });
                    },
                    child: Text('Retake'),
                  ),
                ],
              ),
            if (_currentPosition != null)
              Text(
                'Latitude: ${_currentPosition!.latitude}\nLongitude: ${_currentPosition!.longitude}',
              ),
            if (_uploadedImageUrl.isNotEmpty)
              Image.network(
                _uploadedImageUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: LoadingScreen()));
